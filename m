Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AA9KEa174547 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:09:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1045C15FAC75
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 03:10:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YHhRx3n4XLfLbJXt for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 03:10:45 -0700 (PDT)
Date: Wed, 10 Aug 2011 06:09:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: "xfs: fix error handling for synchronous writes" revisited
Message-ID: <20110810100916.GA27094@infradead.org>
References: <CAB4K4y6-2odbRhqn6q7ZDOxqF9oUcj2zKvyCEV6374QGyM-ddA@mail.gmail.com>
	<20110728145020.GA30785@infradead.org>
	<CAB4K4y4Ns5woUJyPv_NuW0GYSb5ZcFkqnF-DxRB1MESibc1Knw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAB4K4y4Ns5woUJyPv_NuW0GYSb5ZcFkqnF-DxRB1MESibc1Knw@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Looks good.

Alex, any chance to pick this one up for 3.1?


Reviewed-by: Christoph Hellwig <hch@lst.de>

On Fri, Jul 29, 2011 at 01:12:59PM +0530, Ajeet Yadav wrote:
> xfs: fix for hang during synchronous buffer write error
> 
> If removed storage while synchronous buffer write underway,
> "xfslogd" hangs.
> 
> Detailed log http://oss.sgi.com/archives/xfs/2011-07/msg00740.html
> 
> Related work bfc60177f8ab509bc225becbb58f7e53a0e33e81
> "xfs: fix error handling for synchronous writes"
> 
> Given that xfs_bwrite actually does the shutdown already after
> waiting for the b_iodone completion and given that we actually
> found that calling xfs_force_shutdown from inside
> xfs_buf_iodone_callbacks was a major contributor the problem
> it better to drop this call.
> 
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> 
> diff -Nurp -X linux/Documentation/dontdiff linux/fs/xfs/xfs_buf_item.c
> linux-Dirty/fs/xfs/xfs_buf_item.c
> --- linux/fs/xfs/xfs_buf_item.c 2011-06-09 10:05:18.000000000 +0530
> +++ linux-Dirty/fs/xfs/xfs_buf_item.c   2011-07-28 15:53:51.000000000 +0530
> @@ -1028,7 +1028,6 @@ xfs_buf_iodone_callbacks(
>         XFS_BUF_UNDELAYWRITE(bp);
> 
>         trace_xfs_buf_error_relse(bp, _RET_IP_);
> -       xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> 
>  do_callbacks:
>         xfs_buf_do_callbacks(bp, lip);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
