Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C452F7F55
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:47:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6750CAC001
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 09:47:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kBdn5qq1vdYFVUze (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 09:47:30 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2JGlTjB007605
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 12:47:30 -0400
Date: Thu, 19 Mar 2015 12:47:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 13/13] xfs_repair: validate & fix inode CRCs
Message-ID: <20150319164727.GF11669@laptop.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-14-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1426624395-8258-14-git-send-email-sandeen@redhat.com>
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
Cc: xfs@oss.sgi.com

On Tue, Mar 17, 2015 at 03:33:15PM -0500, Eric Sandeen wrote:
> xfs_repair doesn't ever check an inode's CRC, so it never repairs
> them.  If the root inode or realtime inodes have bad crcs, the
> fs won't even mount and can't be fixed (without using xfs_db).
> 
> It's fairly straightforward to just test the inode CRC before
> we do any other checking or modification of the inode, and
> just mark it dirty if it's wrong and needs to be re-written.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  repair/dinode.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 5d9094b..05db838 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2291,6 +2291,30 @@ process_dinode_int(xfs_mount_t *mp,
>  	 */
>  	ASSERT(uncertain == 0 || verify_mode != 0);
>  
> +	/*
> +	 * This is the only valid point to check the CRC; after this we may have
> +	 * made changes which invalidate it, and the CRC is only updated again
> +	 * when it gets written out.
> +	 *
> +	 * Of course if we make any modifications after this, the inode gets
> +	 * rewritten, and the CRC is updated automagically.
> +	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    !xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
> +                		XFS_DINODE_CRC_OFF)) {

   ^^^^^^ whitespace ;)

Otherwise looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		retval = 1;
> +		if (!uncertain)
> +			do_warn(_("bad CRC for inode %" PRIu64 "%c"),
> +				lino, verify_mode ? '\n' : ',');
> +		if (!verify_mode) {
> +			if (!no_modify) {
> +				do_warn(_(" will rewrite\n"));
> +				*dirty = 1;
> +			} else
> +				do_warn(_(" would rewrite\n"));
> +		}
> +	}
> +
>  	if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)  {
>  		retval = 1;
>  		if (!uncertain)
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
