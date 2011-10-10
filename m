Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AEFjVL181907 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:15:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06E881F1F3D0
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 07:15:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KYjeZEG5Zkl4MSWx for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 07:15:44 -0700 (PDT)
Date: Mon, 10 Oct 2011 10:15:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] repair: don't cache large blkmap allocations
Message-ID: <20111010141542.GD31429@infradead.org>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318208915-14975-5-git-send-email-david@fromorbit.com>
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

Looks reasonable.


Reviewed-by: Christoph Hellwig <hch@lst.de>

Although as said my gut feeling is that the cutoff should be lower.
We'd probably need measurements to decide where to go.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
