Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AEHegJ181972 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:17:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B692555F817
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 07:17:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VQsAcSMzobCllm0v for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 07:17:39 -0700 (PDT)
Date: Mon, 10 Oct 2011 10:17:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] repair: prevent blkmap extent count overflows
Message-ID: <20111010141738.GE31429@infradead.org>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318208915-14975-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> Add overflow detection code into the blkmap allocation code to avoid
> this problem.

The code looks a bit odd with the conditional defintion of
BLKMAP_NEXTS_MAX, and the ifdefed printfs after that, but I can't
think of a better way to handle it either.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
