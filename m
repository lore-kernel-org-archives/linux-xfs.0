Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCDB57F3F
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 08:20:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6ADC2AC002
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 06:20:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sPUH8XBOgg1qVDk2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Mar 2015 06:20:11 -0700 (PDT)
Date: Fri, 13 Mar 2015 09:20:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs_repair: validate & fix inode CRCs
Message-ID: <20150313132006.GA2678@laptop.bfoster>
References: <54F77199.8030708@redhat.com>
 <54F771DE.40107@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F771DE.40107@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 04, 2015 at 02:58:06PM -0600, Eric Sandeen wrote:
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
> Resend of patch from a while ago, but with CRC verification
> now earlier in the function, prior to any changes are made.
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 5d9094b..384e2dd 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2291,6 +2291,27 @@ process_dinode_int(xfs_mount_t *mp,
>  	 */
>  	ASSERT(uncertain == 0 || verify_mode != 0);
>  
> +	/*
> +	 * We'd really like to know if the CRC is bad before we
> +	 * go fixing anything; that way we have some hint about
> +	 * bit-rot vs bugs.  Also, any changes will invalidate the
> +	 * existing CRC, so this is the only valid point to test it.
> +	 *
> +	 * Of course if we make any modifications after this, the
> +	 * inode gets rewritten, and CRC is updated automagically.
> +	 */
> +	if (!verify_mode && xfs_sb_version_hascrc(&mp->m_sb)) {

What about verify_mode? It should probably report the inode as bunk if
the crc is bad. Some of the subsequent checks handle this with some
logic to just return 1 if something is bogus and we're in verify mode.

> +		if(!xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
> +                		XFS_DINODE_CRC_OFF)) {

I got a whitespace damage warning here:

/.../xfsprogs-dev/.git/rebase-apply/patch:25: space before tab in indent.
                		XFS_DINODE_CRC_OFF)) {
warning: 1 line adds whitespace errors.

Brian

> +			do_warn(_("bad CRC for inode %" PRIu64), lino);
> +			if (!no_modify) {
> +				do_warn(_(", will rewrite\n"));
> +				*dirty = 1;
> +			} else
> +				do_warn(_(", would rewrite\n"));
> +		}
> +	}
> +
>  	if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)  {
>  		retval = 1;
>  		if (!uncertain)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
