Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31F947F60
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:28:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 12CC18F8049
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 11:28:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IAcFohK3IZKK4YOx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 11:28:23 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sABJSL3o002597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 14:28:22 -0500
Date: Tue, 11 Nov 2014 14:28:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] Make xfs_vn_rename compliant with renameat2() syscall
Message-ID: <20141111192819.GB38867@bfoster.bfoster>
References: <1415725273-5083-1-git-send-email-cmaiolino@redhat.com>
	<1415725273-5083-2-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415725273-5083-2-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 11, 2014 at 03:01:12PM -0200, Carlos Maiolino wrote:
> To be able to support RENAME_EXCHANGE flag from renameat2() system call, XFS
> must have its inode_operations updated, exporting .rename2 method, instead of
> .rename.
> 
> This patch just replaces the (now old) .rename method by .rename2, using the
> same infra-structure, but checking rename flags.
> 
> calls to .rename2 using RENAME_EXCHANGE flag, although now handled inside XFS,
> still returns -EINVAL.
> 
> RENAME_NOREPLACE is handled via VFS and we don't need to care about it inside
> xfs_vn_rename.
> 
> Changelog:
> 
> 	V2: Use xfs_vn_rename as-is, instead of rename it to xfs_vn_rename2
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Thanks for rebasing these Carlos...

>  fs/xfs/xfs_iops.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ec6dcdc..0b8704c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -383,18 +383,23 @@ xfs_vn_rename(
>  	struct inode	*odir,
>  	struct dentry	*odentry,
>  	struct inode	*ndir,
> -	struct dentry	*ndentry)
> +	struct dentry	*ndentry,
> +	unsigned int	flags)
>  {
>  	struct inode	*new_inode = ndentry->d_inode;
>  	struct xfs_name	oname;
>  	struct xfs_name	nname;
>  
> +	/* XFS does not support RENAME_EXCHANGE yet */
> +	if (flags & ~RENAME_NOREPLACE)
> +		return -EINVAL;
> +
>  	xfs_dentry_to_name(&oname, odentry, 0);
>  	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);

This still looks like a problem (as noted in v1). We can confirm with
xfs_io on a v5 XFS (mkfs.xfs -m crc=1) as follows:

- Original dir with a character device node and regular file:

# xfs_io -c "readdir -v" /mnt/
00000000: d_ino: 0x00000040 d_off: 0x0000000a d_reclen: 0x18 d_type: DT_DIR d_name: .
0000000a: d_ino: 0x00000040 d_off: 0x0000000c d_reclen: 0x18 d_type: DT_DIR d_name: ..
0000000c: d_ino: 0x00000043 d_off: 0x0000000e d_reclen: 0x18 d_type: DT_CHR d_name: zero
0000000e: d_ino: 0x00000044 d_off: 0x00000200 d_reclen: 0x18 d_type: DT_REG d_name: file
...

- After rename exchange of zero and file:

# xfs_io -c "readdir -v" /mnt/
00000000: d_ino: 0x00000040 d_off: 0x0000000a d_reclen: 0x18 d_type: DT_DIR d_name: .
0000000a: d_ino: 0x00000040 d_off: 0x0000000c d_reclen: 0x18 d_type: DT_DIR d_name: ..
0000000c: d_ino: 0x00000044 d_off: 0x0000000e d_reclen: 0x18 d_type: DT_UNKNOWN d_name: zero
0000000e: d_ino: 0x00000043 d_off: 0x00000200 d_reclen: 0x18 d_type: DT_CHR d_name: file
...

We can see that the file dentry inherited the d_type of zero, but the
d_type of zero was reset.

Brian

>  
>  	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
> -			  XFS_I(ndir), &nname, new_inode ?
> -						XFS_I(new_inode) : NULL);
> +			  XFS_I(ndir), &nname,
> +			  new_inode ? XFS_I(new_inode) : NULL);
>  }
>  
>  /*
> @@ -1147,7 +1152,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
>  	 */
>  	.rmdir			= xfs_vn_unlink,
>  	.mknod			= xfs_vn_mknod,
> -	.rename			= xfs_vn_rename,
> +	.rename2		= xfs_vn_rename,
>  	.get_acl		= xfs_get_acl,
>  	.set_acl		= xfs_set_acl,
>  	.getattr		= xfs_vn_getattr,
> @@ -1175,7 +1180,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
>  	 */
>  	.rmdir			= xfs_vn_unlink,
>  	.mknod			= xfs_vn_mknod,
> -	.rename			= xfs_vn_rename,
> +	.rename2		= xfs_vn_rename,
>  	.get_acl		= xfs_get_acl,
>  	.set_acl		= xfs_set_acl,
>  	.getattr		= xfs_vn_getattr,
> -- 
> 2.1.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
