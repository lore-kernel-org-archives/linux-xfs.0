Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E0mLT3054413 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 18:48:23 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	G1VDyj63U5cSsQ3R (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 16:48:19 -0800 (PST)
Date: Mon, 13 Feb 2012 19:48:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs_io: fix fiemap loop continuation
Message-ID: <20120214004818.GA6766@infradead.org>
References: <1328163674-9420-1-git-send-email-david@fromorbit.com>
	<20120213190903.GA12477@infradead.org>
	<20120214004532.GJ7479@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120214004532.GJ7479@dastard>
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

On Tue, Feb 14, 2012 at 11:45:32AM +1100, Dave Chinner wrote:
> On Mon, Feb 13, 2012 at 02:09:03PM -0500, Christoph Hellwig wrote:
> > This actually seems to break 252 and 255 for me.
> 
> Ok, there was some code that expected last_logical to be in FSB
> units, not bytes that I failed to convert.
> 
> Fixed version below.

Can you sent a relative patch to the previous one? I've already
commited it a while ago.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
