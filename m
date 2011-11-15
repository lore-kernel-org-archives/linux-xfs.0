Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFK2tkE066850 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 14:02:56 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 921F11268CD2
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:02:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aOXunNfgXKN8gU62 for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 12:02:49 -0800 (PST)
Date: Wed, 16 Nov 2011 07:02:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_getbmap assert
Message-ID: <20111115200246.GT5534@dastard>
References: <20111107103037.GA16213@infradead.org>
	<20111107201505.GE5534@dastard>
	<20111114200554.GA21487@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111114200554.GA21487@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 14, 2011 at 03:05:54PM -0500, Christoph Hellwig wrote:
> On Tue, Nov 08, 2011 at 07:15:05AM +1100, Dave Chinner wrote:
> > Can you see if that is the case that is being triggered?
> 
> I've tried to reproduce the issue with additional debugging for almost
> a week now, but I haven't been able to hit the assert again yet.  Which
> is strange given how often I managed to hit it just before.

Sounds exactly like the problems I've had trying to track this down
- as soon as you go looking for it, it disappears... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
