Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 917EA7F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:01:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FE318F804C
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 08:01:43 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id IBCTLoZMlyYn2u65 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 08:01:42 -0800 (PST)
Date: Thu, 12 Dec 2013 11:01:28 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] nfsd: revoking of suid/sgid bits after chown() in a
	consistent way
Message-ID: <20131212160128.GC11521@fieldses.org>
References: <20131206204747.GB12613@fieldses.org>
	<1386756996-28083-1-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386756996-28083-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, hch@infradead.org, linux-nfs@vger.kernel.org, sprabhu@redhat.com, xfs@oss.sgi.com

Thanks, applying for 3.14.--b.

On Wed, Dec 11, 2013 at 02:16:36PM +0400, Stanislav Kholmanskikh wrote:
> There is an inconsistency in the handling of SUID/SGID file
> bits after chown() between NFS and other local file systems.
> 
> Local file systems (for example, ext3, ext4, xfs, btrfs) revoke
> SUID/SGID bits after chown() on a regular file even if
> the owner/group of the file has not been changed:
> 
> ~# touch file; chmod ug+s file; chmod u+x file
> ~# ls -l file
> -rwsr-Sr-- 1 root root 0 Dec  6 04:49 file
> ~# chown root file; ls -l file
> -rwxr-Sr-- 1 root root 0 Dec  6 04:49 file
> 
> but NFS doesn't do that:
> 
> ~# touch file; chmod ug+s file; chmod u+x file
> ~# ls -l file
> -rwsr-Sr-- 1 root root 0 Dec  6 04:49 file
> ~# chown root file; ls -l file
> -rwsr-Sr-- 1 root root 0 Dec  6 04:49 file
> 
> NFS does that only if the owner/group has been changed:
> 
> ~# touch file; chmod ug+s file; chmod u+x file
> ~# ls -l file
> -rwsr-Sr-- 1 root root 0 Dec  6 05:02 file
> ~# chown bin file; ls -l file
> -rwxr-Sr-- 1 bin root 0 Dec  6 05:02 file
> 
> See: http://pubs.opengroup.org/onlinepubs/9699919799/functions/chown.html
> 
>  "If the specified file is a regular file, one or more of
>  the S_IXUSR, S_IXGRP, or S_IXOTH bits of the file mode are set,
>  and the process has appropriate privileges, it is
>  implementation-defined whether the set-user-ID and set-group-ID
>  bits are altered."
> 
> So both variants are acceptable by POSIX.
> 
> This patch makes NFS to behave like local file systems.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>  fs/nfsd/vfs.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 72cb28e..8226991 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -348,8 +348,7 @@ nfsd_sanitize_attrs(struct inode *inode, struct iattr *iap)
>  
>  	/* Revoke setuid/setgid on chown */
>  	if (!S_ISDIR(inode->i_mode) &&
> -	    (((iap->ia_valid & ATTR_UID) && !uid_eq(iap->ia_uid, inode->i_uid)) ||
> -	     ((iap->ia_valid & ATTR_GID) && !gid_eq(iap->ia_gid, inode->i_gid)))) {
> +	    ((iap->ia_valid & ATTR_UID) || (iap->ia_valid & ATTR_GID))) {
>  		iap->ia_valid |= ATTR_KILL_PRIV;
>  		if (iap->ia_valid & ATTR_MODE) {
>  			/* we're setting mode too, just clear the s*id bits */
> -- 
> 1.7.1
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
