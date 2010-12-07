Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7AmA6Y135501 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 04:48:11 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B616A1C9E0C9
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 02:49:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	x5az2KiRp6qBzdy4 for <xfs@oss.sgi.com>;
	Tue, 07 Dec 2010 02:49:56 -0800 (PST)
Date: Tue, 7 Dec 2010 21:49:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: dynamic speculative EOF preallocation
Message-ID: <20101207104952.GC16103@dastard>
References: <1290991431-20519-1-git-send-email-david@fromorbit.com>
	<1290991431-20519-2-git-send-email-david@fromorbit.com>
	<20101207101746.GB25995@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101207101746.GB25995@infradead.org>
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

On Tue, Dec 07, 2010 at 05:17:46AM -0500, Christoph Hellwig wrote:
> I need the patch below to make the new code link on 32-bit systems:
> 
> Index: xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.c	2010-12-07 11:01:50.394021585 +0100
> +++ xfs/fs/xfs/xfs_mount.c	2010-12-07 11:02:46.231256257 +0100
> @@ -1111,7 +1111,10 @@ xfs_set_low_space_thresholds(
>  	int i;
>  
>  	for (i = 0; i < XFS_LOWSP_MAX; i++) {
> -		mp->m_low_space[i] = mp->m_sb.sb_dblocks / 100 * (i + 1);
> +		__uint64_t space = mp->m_sb.sb_dblocks;
> +		do_div(space, 100);
> +
> +		mp->m_low_space[i] = space * (i + 1);
>  	}
>  }

Yes, makes sense. I'll fold that into the latest version of the
patch. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
