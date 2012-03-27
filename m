Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R9vJ7Z261029 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 04:57:19 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0PyYYtcLtMuB0bU7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 02:57:17 -0700 (PDT)
Date: Tue, 27 Mar 2012 05:57:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] shutdown hang fix (was Re: [PATCH 2/2] xfs: avoid
	shutdown hang in xlog_wait())
Message-ID: <20120327095717.GA4502@infradead.org>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
	<1332467263-12985-3-git-send-email-david@fromorbit.com>
	<20120324170302.GB21708@infradead.org>
	<20120324224648.GF5091@dastard>
	<20120325112801.GA7157@infradead.org>
	<20120327094547.GZ5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327094547.GZ5091@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

This one looks a lot simpler to me, so it gets my vote.


Reviewed-by: Christoph Hellwig <hch@lst.de>

Alex, can we push this to Linus soonish?  I'll have to rebase the
AIL emptying changes on top of this one, so getting it in soon would
make my life a lot easier.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
