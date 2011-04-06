Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36IUdnC048480 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 13:30:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5D073AD672
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 11:33:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BEPpnENL0Qg0fLBz for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 11:33:56 -0700 (PDT)
Date: Wed, 6 Apr 2011 14:33:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] xfs: push the AIL from memory reclaim and periodic
	sync
Message-ID: <20110406183356.GA23275@infradead.org>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302070758-17312-8-git-send-email-david@fromorbit.com>
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

The patch looks correct, but I wonder what the performance implications
of flushing the AIL every 30 seconds are.  Did you benchmark the
patchset to see what it does to performance numbers for metadata
intensive workloads?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
