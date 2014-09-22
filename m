Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C873A7F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 08:19:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B6B468F8035
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 06:18:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XPzIDTqJbY4a1Y1P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 06:18:57 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8MDIu83030626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 09:18:57 -0400
Date: Mon, 22 Sep 2014 09:18:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: validate & fix inode CRCs
Message-ID: <20140922131855.GA29156@bfoster.bfoster>
References: <5418AC01.30006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5418AC01.30006@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 16, 2014 at 04:30:41PM -0500, Eric Sandeen wrote:
> xfs_repair doesn't ever check an inode's CRC, so it never repairs
> them.  If the root inode or realtime inodes have bad crcs, the
> fs won't even mount and can't be fixed (without using xfs_db).
> 
> It's fairly straightforward to just test the inode CRC before
> we do any other checking or modification of the inode, once we
> get past the "verify only" phase of process_dinode_int();
> just mark it dirty if it's wrong and needs to be re-written.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> forgive the gratuitous big honkin' comment line, but
> process_dinode_int is so long, I thought the visual delimiter was
> useful.  ;)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8891e84..27c0da6 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2524,6 +2524,30 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	if (verify_mode)
>  		return retval;
>  
> +	/* =========== END OF VERIFY MODE =================== */
> +
> +	/*
> +	 * We'd really like to know if the CRC is bad before we
> +	 * go fixing anything; that way we have some hint about
> +	 * bit-rot vs bugs.  Also, any changes will invalidate the
> +	 * existing CRC, so this is the only valid point to test it.
> +	 *
> +	 * Of course if we make any modifications after this, the
> +	 * inode gets rewritten, and CRC is updated automagically.
> +	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		ASSERT(!verify_mode);
> +		if(!xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
> +                		XFS_DINODE_CRC_OFF)) {
> +			do_warn(_("bad CRC for inode %" PRIu64), lino);
> +			if (!no_modify) {
> +				do_warn(_(", will rewrite\n"));
> +				*dirty = 1;
> +			} else
> +				do_warn(_(", would rewrite\n"));
> +		}
> +	}
> +

So we verify each inode first in process_inode_chunk() and then follow
on with process_dinode(). There's a comment further up in
process_dinode_int() that indicates we explicitly do not check the crc
at that point, presumably considering verify_mode. I only see one call
to each of verify_inode() and process_dinode() (in that order). The
other process_dinode_int() caller is verify_uncertain_dinode(), which
looks like it occurs ultimately from process_uncertain_aginodes() in
phase 3.

I suppose that logic makes sense, but it's not totally clear tbh. We do
fix up the crc in the caller if the inode is marked dirty. It also seems
like it's possible to modify the inode before this point where we check
the crc. Given that, it seems like we could just add an "if
(!verify_mode)" hunk to the preexisting hascrc() hunk further up in the
function..?

I don't really have a clear beat on this at the moment. I think what I'm
getting after is that right now if we see the new crc message, it isn't
necessarily clear if that is because repair changed something or it is
legitimately wrong on-disk, depending on how the inode might be
corrupted or if the inode is free (do we care about crc's in that case?
it looks like we miss that as well). It would be nice if we had some
kind of consistent rule for this scenario, such as "always print the
error if the crc is wrong" (e.g., before we make any modifications) or
"only print the error if the crc is the only thing wrong" (e.g., we've
already verified the inode and the crc itself is wrong). Either way it
seems inappropriate to print a crc error that might be caused by repair
itself.

Brian

>  	/*
>  	 * clear the next unlinked field if necessary on a good
>  	 * inode only during phase 4 -- when checking for inodes
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
