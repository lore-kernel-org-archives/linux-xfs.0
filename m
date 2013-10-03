Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 791337F4E
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 17:11:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36D82304053
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 15:11:03 -0700 (PDT)
Message-ID: <524DEB74.6090905@redhat.com>
Date: Thu, 03 Oct 2013 17:11:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: handle large, wholly-sparse files
References: <524AF8AE.5030300@sgi.com> <20131003212114.493910914@sgi.com>
In-Reply-To: <20131003212114.493910914@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: rjohnston@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/3/13 4:20 PM, rjohnston@sgi.com wrote:
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
> [rjohnston: partial_reg() was added Jun 11 1998 to fix a multi-stream
>   bug. With Eric's patch above, the multi-stream check in partial_reg 
>   can be removed because single stream restores will never be partially
>   restored.]

No, please don't add this to my patch; that part was still under discussion
AFAIK.

The [lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]

type stuff is for minor changes:

"If you are a subsystem or branch maintainer, sometimes you need to slightly
modify patches you receive in order to merge them, because the code is not
exactly the same in your tree and the submitters'. If you stick strictly to
rule (c), you should ask the submitter to rediff, but this is a totally
counter-productive waste of time and energy. Rule (b) allows you to adjust
the code, but then it is very impolite to change one submitter's code and
make him endorse your bugs. To solve this problem, it is recommended that
you add a line between the last Signed-off-by header and yours, indicating
the nature of your changes."

Aside from that, Signed-off-by: from a maintainer means:

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

Removing that non-multistream test is (possibly) a cleanup pretty much
unrelated to the bug at hand, and if you _really_ want to make the change,
just submit a patch after the bugfix patch, and we can evaluate it on its
merits.

IOWS: I understand the bugfix part of the patch.  Whether it's safe to
remove the early return from partial_reg() has never actually been reviewed;
you wrote it, I at a minimum still had questions about it, and I think that's
where it stands.

I know it got complicated when I rewrote things, and so we had 2 patches out
there, but it only gets more complicated if you mush them together & add both
our signed-off-bys to the result.  :)

Thanks,
-Eric


> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
> Change History
> 
> Original patch  "[PATCH] xfsrestore: fix multi stream support"
> - Patch rename, fixes to code and commit messages by sandeen.
> - Additional changes by rjohnston
> 
> ---
>  restore/content.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Index: b/restore/content.c
> ===================================================================
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -7516,6 +7516,11 @@ restore_extent_group( drive_t *drivep,
>  		 * we are done.
>  		 */
>  		if ( ehdr.eh_type == EXTENTHDR_TYPE_LAST ) {
> +			/* For a wholly sparse file, there is no HOLE
> +			 * record; advance restoredsz to EOF.
> +			 */
> +			if (!restoredsz)
> +				restoredsz = bstatp->bs_size;
>  			break;
>  		}
>  
> @@ -8959,9 +8964,6 @@ partial_reg( ix_t d_index,
>  
>  	endoffset = offset + sz;
>  
> -	if ( partialmax == 0 )
> -		return;
> -
>  	pi_lock();
>  
>  	/* Search for a matching inode.  Gaps can exist so we must search
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
