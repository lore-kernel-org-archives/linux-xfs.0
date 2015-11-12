Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D3477F66
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:05:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A94F304032
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 08:05:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eq91RkDknVgEsO5s (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 08:05:23 -0800 (PST)
Date: Thu, 12 Nov 2015 11:05:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs_fsr: more selinux fixes
Message-ID: <20151112160521.GE5068@bfoster.bfoster>
References: <5643B8B7.9030708@sandeen.net>
 <5644B735.2090002@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5644B735.2090002@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Thu, Nov 12, 2015 at 09:58:45AM -0600, Eric Sandeen wrote:
> Commit:
> 
> 1adfe5c xfs_fsr: fix SWAPEXT failures under selinux
> 
> attempted to fix up the fork offset under selinux, where
> the temp file is created with a local attribute, but the
> target file has remote attributes; this can lead to a smaller
> data area in the temp inode, without enough room to swap extents
> from the target inode.  I remedied this by pushing the temp
> file attribute to remote, but *only* if the target file's attr
> was also remote.
> 
> However, I have a case from the field where the parent dir
> and the target file both have a context of:
> 
> system_u:object_r:samba_share_t:s0
> 
> but new files created in the dir have a context of
> 
> unconfined_u:object_r:samba_share_t:s0
> 
> This means the temp file has a smaller forkoff, and less space
> in the inode for data, so we fail to swap the extents between
> the two, because they don't fit.
> 
> The following patch fixes this by allowing xfs_fsr to
> kick the tempfile's attr out of local format even if the target
> file's attr is local, if this will move the forkoff in the right
> direction.  This does pass all our fsr xfstests, though I'm not
> sure we have any real coverage of fsr under selinux...
> 
> The only functional change is the test at the very end of the
> patch; the rest is comments, ascii art, and removing the
> now-extraneous XFS_IOC_FSGETXATTRA ioctl.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Fix a whitespace issue.
> 
> Brian, I didn't add the debug printf; we don't do it for any
> other attr operations unless they fail, and I don't think it's needed
> here either.  And I couldn't fit it gracefully into 80 cols.  ;)
> 

Ok, no problem. I was originally thinking that this would affect the
target file. As pointed out on IRC, the target file xattrs should remain
unmodified and the extent information is just swapped into the data
area. Looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index b902acc..2bae1d0 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1115,14 +1115,12 @@ fsr_setup_attr_fork(
>  			}
>  			continue;
>  		} else if (i == 0) {
> -			struct fsxattr	fsx;
>  			/*
>  			 * First pass, and temp file already has an inline
>  			 * xattr, probably due to selinux.
>  			 *
>  			 * It's *possible* that the temp file attr area
> -			 * is larger than the target file's, if the 
> -			 * target file's attrs are not inline:
> +			 * is larger than the target file's:
>  			 *
>  			 *  Target		 Temp
>  			 * +-------+ 0		+-------+ 0
> @@ -1132,28 +1130,18 @@ fsr_setup_attr_fork(
>  			 * |	   |		v-------v forkoff
>  			 * |	   |		|       |
>  			 * v-------v forkoff	| Attr  | local
> -			 * | Attr  | ext/btree	|       |
> +			 * | Attr  | 		|       |
>  			 * +-------+		+-------+
> -			 *
> -			 * FSGETXATTRA will tell us nr of attr extents in
> -			 * target, if any.  If none, it's local:
>  			 */
>  
> -			memset(&fsx, 0, sizeof(fsx));
> -			if (ioctl(fd, XFS_IOC_FSGETXATTRA, &fsx)) {
> -				fsrprintf(_("FSGETXATTRA failed on target\n"));
> -				return -1;
> -			}
> -
>  			/*
> -			 * If target attr area is less than the temp's (diff < 0)
> -			 * and the target is not local, write a big attr to
> -			 * the temp file to knock the attr out of local format,
> -			 * to match the target.  (This should actually *increase*
> -			 * the temp file's forkoffset when the attr moves out
> -			 * of the inode)
> +			 * If target attr area is less than the temp's
> +			 * (diff < 0) write a big attr to the temp file to knock
> +			 * the attr out of local format.
> +			 * (This should actually *increase* the temp file's
> +			 * forkoffset when the attr moves out of the inode)
>  			 */
> - 			if (diff < 0 && fsx.fsx_nextents > 0) {
> +			if (diff < 0) {
>  				char val[2048];
>  				memset(val, 'X', 2048);
>  				if (fsetxattr(tfd, name, val, 2048, 0)) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
