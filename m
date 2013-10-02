Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DAD77F98
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 15:03:10 -0500 (CDT)
Message-ID: <524C7BF6.5050107@sgi.com>
Date: Wed, 2 Oct 2013 15:03:02 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix multi stream support
References: <524AF8AE.5030300@sgi.com> <524C68C5.2030202@sandeen.net>
In-Reply-To: <524C68C5.2030202@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>



On 10/02/2013 01:41 PM, Eric Sandeen wrote:
> Ok me again.  ;)  Here's a testcase:
>
> #!/bin/bash
>
> # paths to binaries under test
> DUMP=/mnt/test2/git/xfsdump/dump/xfsdump
> RESTORE=/mnt/test2/git/xfsdump/restore/xfsrestore
>
> # dir we'll create files in & dump
> DUMPDIR=/mnt/test
> # dir where we'll restore
> RESTOREDIR=/mnt/test2/restore
>
> mkdir -p $DUMPDIR/dir
> mkdir -p $RESTOREDIR
> rm -rf $DUMPDIR/dir/*
> rm -rf $RESTOREDIR/*
>
> truncate --size=1t $DUMPDIR/dir/sparsefile1
> truncate --size=1t $DUMPDIR/dir/sparsefile2
> truncate --size=1t $DUMPDIR/dir/sparsefile3
> truncate --size=1t $DUMPDIR/dir/sparsefile4
>
> rm -f stream1 stream2
> $DUMP -L session -M label1 -M label2 -f stream1 -f stream2 $DUMPDIR
> $RESTORE -F -f stream1 -f stream2 $RESTOREDIR
>
> ---
>
> so we go down this path:
>
> restore_extent_group
> 	<loop over extent headers adding up restoredsz>
>          if (bstatp->bs_size > restoredsz) {
>                  partial_reg()
>
> In that loop, if we find DATA or HOLE, it advances "restoredsz" so it
> generally does handle sparse files properly.
>
> But a wholly sparse file has only the LAST header type, and resetoredsz
> never moves.  This is important.  ;)  That's why the condition necessary
> to go to partial_reg() is true.
>
> in partial_reg(), with multiple streams, we check persp->a.parrest[i].is_ino
> for each stream ("i") to see if the inode we're restoring i in any is_ino:
>
>          /* Search for a matching inode.  Gaps can exist so we must search
>           * all entries.
>           */
>          for (i=0; i < partialmax; i++ ) {
>                  if (persp->a.parrest[i].is_ino == ino) {
>                          isptr = &persp->a.parrest[i];
>                          break;
>                  }
>          }
>
> If this is the first time we've hit this inode we won't find it, and so we fill
> it in on one slot:
>
>          /* If not found, find a free one, fill it in and return */
>          if ( ! isptr ) {
>                  /* find a free one */
>                  for (i=0; i < partialmax; i++ ) {
>                          if (persp->a.parrest[i].is_ino == 0) {
>                                  isptr->is_ino = ino;
> 				<snip>
>                                  goto found;
>                          }
>                  }
>                  /* Should never get here. */
>                  pi_unlock();
>                  mlog( MLOG_NORMAL | MLOG_WARNING, _(
>                    "partial_reg: Out of records. Extend attrs applied early.\n"));
> #ifdef DEBUGPARTIALS
> 	}
>
> Otherwise, we go to found:  which calls partial_check2().
>
> So the only way we can not "find a free one" is if every a.parrest[i].is_ino
> is set to something.  Well, we only have a few of them based on the number of
> streams; what clears it?  partial_check2(), which is looking to see if the file
> is wholly restored:
>
>          /* Check if all bytes are accounted for.  */
>          if (curoffset >= fsize) {
>                  isptr->is_ino = 0;  /* clear the entry */
>
> But since the wholly-sparse file had only a LAST record, and no HOLE, nothing
> advanced, and it doesn't look "done" - so partial_check2() fails, we fill all
> the slots, and we hit the dreaded "partial_reg: Out of records."
>
> Bleah.
>
> So I agree, this does seem to only happen with wholly-sparse files.
>
> Adding a HOLE record for them would fix it, but that doesn't fix old dumps.
>
> So I thought about doing something like this:
>
>
> [PATCH] xfsdump: handle large, wholly-sparse files
>
> In restore_extent_group(), we loop over all extent headers for an inode
> in the stream, and add up the cumulatively restored size, accounting
> for both HOLE and DATA records and advancing restoredsz as we go.
>
> But for a wholly-sparse file, we have no HOLE header, only
> a LAST header, and restoredsz remains at 0.
>
> This makes it look like it's a partially-restored file, split
> across streams because the final restoredsz for this stream is
> less than the file size, and we go to partial_reg(), which
> allocates one slot in persp->a.parrest[] for this inode.  But
> we've also called partial_reg() with offset/sz of 0/0, which is
> less than the file size so this inode never looks "done."
>
> Normally partial_check2() would clear the persp->a.parrest[]
> slot in the array when the file is fully restored, but in
> this case, that is never satisfied.  So all stream slots
> get filled as we encounter more inodes like this, and we
> eventually get:
>
> "partial_reg: Out of records. Extend attrs applied early."
>
> Fix this by recognizing that if we hit a LAST header with
> no restoredsz set (i.e. the LAST header is the only header),
> set restoredsz to EOF (bstatp->bs_size) to indicate that
> restoration of this file is complete, skip the call to
> partial_reg(), and all is well.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/restore/content.c b/restore/content.c
> index 54d933c..8949a7e 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -7516,6 +7516,11 @@ restore_extent_group( drive_t *drivep,
>   		 * we are done.
>   		 */
>   		if ( ehdr.eh_type == EXTENTHDR_TYPE_LAST ) {
> +			/* For a wholly sparse file, there is no HOLE
> +			 * record; advance restoredsz to EOF.
> +			 */
> +			if (!restoredsz)
> +				restoredsz = bstatp->bs_size;
>   			break;
>   		}
>
>
> So, ok, fine - that's essentially what your patch did.  ;)  But
> now I understand it, and the above to me seems to keep more in  line
> with the original logic, for better or worse.
>
> What ,do you think?

Sure go for it. That was one of my test programs but obviously I choose 
the wrong one. ;) Its really sixes to me.

I still think the the check in partial_reg is not needed. I never saw a 
case where single stream restore hits that check except when there are 
no extents. Do you have an case/example?

We saw this issue with DMF offline files because DMF removes the extents 
and the file has an attribute which is not restored with the current 
code using multistream.

So I thinks a simple test case is:

Create a file with no extents.
Give that file an attribute
dump and restore it (both single and multistream)
verify the file still has the attribute.

Your thoughts?
--Rich

>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
