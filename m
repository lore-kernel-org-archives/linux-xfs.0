Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHmHA1100002 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:48:17 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	G3Ypw58MZPimjN1A (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:48:15 -0800 (PST)
Date: Fri, 17 Feb 2012 12:48:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] xfs: use per-CPU data for the quota statistics
Message-ID: <20120217174814.GE21796@infradead.org>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.414783335@bombadil.infradead.org>
	<20120215235929.GP14132@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215235929.GP14132@dastard>
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

On Thu, Feb 16, 2012 at 10:59:29AM +1100, Dave Chinner wrote:
> Why not just make val a 64bit value so overflow is simply not an
> issue?

It's a 1:1 copy an paste from the normal XFS stats.

But thinking about this copy and paste is bad - I'll rework this to
add the quota stats that we keep into the normal XFS stats, and just
provide the two old quota stats files as legacy views into them.  That
way we'll have only a single copy of that code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
