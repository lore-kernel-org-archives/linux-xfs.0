Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9EFC29DF9
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 07:46:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B835F304067
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 05:46:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id u4PplgrFjdh5CTrn for
	<xfs@oss.sgi.com>; Mon, 18 Nov 2013 05:46:21 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAIDkKAX031691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 08:46:21 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rAIDkK8p013786
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 08:46:20 -0500
Message-ID: <528A1BA5.7060004@redhat.com>
Date: Mon, 18 Nov 2013 08:52:37 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: tiny xfs_setattr_mode cleanup
References: <20131118131040.GA21649@infradead.org>
In-Reply-To: <20131118131040.GA21649@infradead.org>
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

On 11/18/2013 08:10 AM, Christoph Hellwig wrote:
> Remove the pointless tp argument, and properly align the local variable
> declarations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iops.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> Index: linux/fs/xfs/xfs_iops.c
> ===================================================================
> --- linux.orig/fs/xfs/xfs_iops.c	2013-11-14 17:58:06.612700222 +0100
> +++ linux/fs/xfs/xfs_iops.c	2013-11-18 11:54:46.083792257 +0100
> @@ -459,14 +459,12 @@ xfs_vn_getattr(
>  
>  static void
>  xfs_setattr_mode(
> -	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	struct iattr		*iattr)
>  {
> -	struct inode	*inode = VFS_I(ip);
> -	umode_t		mode = iattr->ia_mode;
> +	struct inode		*inode = VFS_I(ip);
> +	umode_t			mode = iattr->ia_mode;
>  
> -	ASSERT(tp);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	ip->i_d.di_mode &= S_IFMT;
> @@ -633,7 +631,7 @@ xfs_setattr_nonsize(
>  	 * Change file access modes.
>  	 */
>  	if (mask & ATTR_MODE)
> -		xfs_setattr_mode(tp, ip, iattr);
> +		xfs_setattr_mode(ip, iattr);
>  
>  	/*
>  	 * Change file access or modified times.
> @@ -871,7 +869,7 @@ xfs_setattr_size(
>  	 * Change file access modes.
>  	 */
>  	if (mask & ATTR_MODE)
> -		xfs_setattr_mode(tp, ip, iattr);
> +		xfs_setattr_mode(ip, iattr);
>  
>  	if (mask & ATTR_CTIME) {
>  		inode->i_ctime = iattr->ia_ctime;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
