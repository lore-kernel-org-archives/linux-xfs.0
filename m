Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C7517CA5
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 16:59:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D1D7304032
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 14:59:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DjXSORrvy6HLDWHm for <xfs@oss.sgi.com>;
	Thu, 18 Feb 2016 14:58:53 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A292165E4189
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 16:58:52 -0600 (CST)
Subject: Re: [PATCH] libxfs: fix up mismerge in libxfs_iflush_int
References: <56C62FC1.60205@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C64CAB.8020607@sandeen.net>
Date: Thu, 18 Feb 2016 16:58:51 -0600
MIME-Version: 1.0
In-Reply-To: <56C62FC1.60205@redhat.com>
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

Oh, if you think of it, you can note that this
is coverity ID 1353345 in the changelog as well;
not sure we care too much about that, but *shrug*

-Eric

On 2/18/16 2:55 PM, Eric Sandeen wrote:
> XFS_ISDIR is a bool, don't compare it to S_IFDIR
> 
> e37bf5 xfs: mode di_mode to vfs inode had a small mis-merge
> from kernelspace, when moving from
> 
> 	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) 
> to
> 	if (XFS_ISDIR(ip) == S_IFDIR
> 
> that "==" should have been dropped.
> 
> Signed-off-by: ERic Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 576f954..f3b9895 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -420,7 +420,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
>  	if (XFS_ISREG(ip)) {
>  		ASSERT( (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS) ||
>  			(ip->i_d.di_format == XFS_DINODE_FMT_BTREE) );
> -	} else if (XFS_ISDIR(ip) == S_IFDIR) {
> +	} else if (XFS_ISDIR(ip)) {
>  		ASSERT( (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS) ||
>  			(ip->i_d.di_format == XFS_DINODE_FMT_BTREE)   ||
>  			(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) );
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
