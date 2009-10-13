Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9D1RPj0065634 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 20:27:25 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: fix double IRELE in xfs_dqrele_inode
Date: Mon, 12 Oct 2009 20:27:14 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AD88@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091012234210.GA31892@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On , Christoph Hellwig wrote:
> xfs_dqrele_inode calls xfs_iput to release the ilock and a reference
> and then also calls IRELE which does a second decrement of the reference
> count.  This leads to a premature freeing of inodes when quotas were turned
> off while the filesystem was mounted.

Regression was caused by fe588ed32867b42e0d906db558ca92fd9f8b128e

Fix looks good.  I'll push it to Linus tomorrow.

> Thanks to Utako Kusaka for reporting the bug and provinding a good testcase.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-10-11 13:41:52.932012023 -0300
> +++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-10-11 13:42:04.060016467 -0300
> @@ -876,7 +876,6 @@ xfs_dqrele_inode(
>  		ip->i_gdquot = NULL;
>  	}
>  	xfs_iput(ip, XFS_ILOCK_EXCL);
> -	IRELE(ip);
> 
>  	return 0;
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
