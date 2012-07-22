Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6M6SZpw109829 for <xfs@oss.sgi.com>; Sun, 22 Jul 2012 01:28:36 -0500
Date: Sun, 22 Jul 2012 02:28:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] xfs: probe data buffer from page cache for unwritten
	extents
Message-ID: <20120722062830.GA23062@infradead.org>
References: <50091696.4000903@oracle.com> <5009A786.3080500@sgi.com>
	<500A4B24.40908@oracle.com> <20120722045703.GA17235@infradead.org>
	<500B8FAA.8030804@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <500B8FAA.8030804@oracle.com>
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
To: Jie Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Sun, Jul 22, 2012 at 01:29:14PM +0800, Jie Liu wrote:
> Should we keep 285 unchanged and introduce a new test 28? which is
> dedicated to ensuring the refinements works as expected?
> I have added some new test cases to Mark's test program yesterday,
> looks it will grow even bigger if I can think out some other
> corner cases(will send them to Mark).

I think a separate case is better, as 285 just tests a basic correct
implementation, while this one tests the refinements.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
