Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EFC017CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 09:14:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E27AA304039
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 07:14:30 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rXnC56a6RyC3jESq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 07:14:26 -0800 (PST)
Date: Thu, 11 Feb 2016 07:14:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: remove xfs_cancel_ioend
Message-ID: <20160211151425.GB13515@infradead.org>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-3-git-send-email-david@fromorbit.com>
	<20160210112800.GA15221@infradead.org>
	<20160211002137.GR14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211002137.GR14668@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 11, 2016 at 11:21:37AM +1100, Dave Chinner wrote:
> I'll propagate it through where it makes sense. If we alrady have an
> error, then we aren't going to call xfs_setfilesize_trans_alloc()
> anyway, so checking the return value only matters in the non-error
> cases.

Oh, I missed that we don't care about the failure case.  Maybe we
should just call xfs_setfilesize_trans_alloc instead, and just move
the conditionals to it so that it's a no-op if no transaction is needed?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
