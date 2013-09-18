Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E75497F37
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 13:19:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD7488F8039
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 11:19:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TXH3mprM3GDcS5Ch for
	<xfs@oss.sgi.com>; Wed, 18 Sep 2013 11:19:47 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8IIJkqp014547
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:19:46 -0400
Received: from laptop.bfoster (vpn-51-254.rdu2.redhat.com [10.10.51.254])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8IIA7LW016565
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:10:08 -0400
Message-ID: <5239EBA2.4070207@redhat.com>
Date: Wed, 18 Sep 2013 14:06:26 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: push down inactive transaction mgmt for remote
	symlinks
References: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
	<1379520960-22972-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1379520960-22972-2-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On 09/18/2013 12:15 PM, Brian Foster wrote:
> Push down the transaction management for remote symlinks from
> xfs_inactive() down to xfs_inactive_symlink_rmt(). The latter is
> cleaned up to avoid transaction management intended for the
> calling context (i.e., trans duplication, reservation, item
> attachment).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c   | 15 ++++++------
>  fs/xfs/xfs_symlink.c | 64 ++++++++++++++++++----------------------------------
>  fs/xfs/xfs_symlink.h |  2 +-
>  3 files changed, 31 insertions(+), 50 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index f622a97..f85f6f2 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -424,8 +424,7 @@ xfs_symlink(
>   */
...
>  
> @@ -563,16 +546,13 @@ xfs_inactive_symlink_rmt(
>   */
>  int
>  xfs_inactive_symlink(
> -	struct xfs_inode	*ip,
> -	struct xfs_trans	**tp)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			pathlen;
>  
>  	trace_xfs_inactive_symlink(ip);
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -

I just want to call out one thing here in case it isn't noticed on
review... the safety of this is something I was curious about.
Specifically, note that I've removed the inode locking from
xfs_inactive(), which previously covered xfs_inactive_symlink() (for
xfs_idata_realloc()), down into xfs_inactive_symlink_rmt().

My assumption was that this is currently ok since at this point we have
an inode with di_nlink == 0. If that's not accurate or not expected to
remain so after O_TMPFILE related work, I suppose I could pull the
locking back up into xfs_inactive_symlink().

Brian

>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return XFS_ERROR(EIO);
>  
> @@ -599,5 +579,5 @@ xfs_inactive_symlink(
>  	}
>  
>  	/* remove the remote symlink */
> -	return xfs_inactive_symlink_rmt(ip, tp);
> +	return xfs_inactive_symlink_rmt(ip);
>  }
> diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
> index 99338ba..e75245d 100644
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -22,6 +22,6 @@
>  int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
>  		const char *target_path, umode_t mode, struct xfs_inode **ipp);
>  int xfs_readlink(struct xfs_inode *ip, char *link);
> -int xfs_inactive_symlink(struct xfs_inode *ip, struct xfs_trans **tpp);
> +int xfs_inactive_symlink(struct xfs_inode *ip);
>  
>  #endif /* __XFS_SYMLINK_H */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
