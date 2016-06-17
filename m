Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EF147CAF
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 06:34:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9901AC002
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:34:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id teZg9C4Cok9J3ZEW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:34:25 -0700 (PDT)
Date: Fri, 17 Jun 2016 04:34:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 004/119] xfs: enable buffer deadlock postmortem diagnosis
	via ftrace
Message-ID: <20160617113423.GC19042@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612629822.12839.7938642541078923297.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612629822.12839.7938642541078923297.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index efa2a73..2333db7 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -947,7 +947,8 @@ xfs_buf_trylock(
>  	if (locked)
>  		XB_SET_OWNER(bp);
>  
> -	trace_xfs_buf_trylock(bp, _RET_IP_);
> +	locked ? trace_xfs_buf_trylock(bp, _RET_IP_) :
> +		 trace_xfs_buf_trylock_fail(bp, _RET_IP_);
>  	return locked;

I think this should be something like:

	if (locked) {
		XB_SET_OWNER(bp);
		trace_xfs_buf_trylock(bp, _RET_IP_);
	} else {
		trace_xfs_buf_trylock_fail(bp, _RET_IP_);
	}

otherwise this looks good and can go in without the rest of the series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
