Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BA4E7q153179
	for <linux-xfs@oss.sgi.com>; Wed, 11 Jan 2012 04:04:14 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jViJOorAajQSRn0N for <linux-xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 02:04:13 -0800 (PST)
Date: Wed, 11 Jan 2012 05:04:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Why does xfsdump encounter "WARNING: could not get list of
	non-root attributes for nondir ino nnnn: Cannot allocate memory (12)"?
Message-ID: <20120111100412.GA1538@infradead.org>
References: <jdo01m$62j$1@dough.gmane.org> <20120102213706.GQ23662@dastard>
	<20120111095513.GA26958@infradead.org>
	<20120111100316.GH24410@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120111100316.GH24410@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com, Michael Lueck <mlueck@lueckdatasystems.com>

On Wed, Jan 11, 2012 at 09:03:16PM +1100, Dave Chinner wrote:
> Sounds like a generic kvmalloc()/kvfree() call pair is the answer
> then. i.e. if kmalloc fails, then use vmalloc()...

If my memory serves me right that's been discussed and rejected a few
times before.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
