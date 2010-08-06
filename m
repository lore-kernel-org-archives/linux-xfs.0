Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o76D2XSv141052 for <xfs@oss.sgi.com>; Fri, 6 Aug 2010 08:02:33 -0500
Date: Fri, 6 Aug 2010 09:02:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: ensure f_ffree returned by statfs() is
	non-negative
Message-ID: <20100806130253.GB16818@infradead.org>
References: <1280931359.12084.2519.camel@superior.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280931359.12084.2519.camel@superior.americas.sgi.com>
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
To: Stuart Brodsky <sbrodsky@sgi.com>
Cc: xfs@oss.sgi.com

Good changelog this time around, thanks.

> -       statp->f_ffree = statp->f_files - (sbp->sb_icount -
> sbp->sb_ifree);

Your mailer line-wrapper the patch here.

> +       ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
> +       statp->f_ffree = (__u64) (ffree < 0 ? 0 : ffree);

Why not just use min_t here?

	statp->f_ffree = max_t(__int64_t, ffree, 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
