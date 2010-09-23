Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NE9AhI129367 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 09:09:10 -0500
Received: from phd-imap.ethz.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70189E52E81
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 07:22:37 -0700 (PDT)
Received: from phd-imap.ethz.ch (phd-imap.ethz.ch [129.132.80.51]) by
	cuda.sgi.com with ESMTP id u3uSior3hYAlTfMG for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 07:22:37 -0700 (PDT)
Subject: Re: XFS errors on large Infiniband fileserver setup
MIME-Version: 1.0
Date: Thu, 23 Sep 2010 16:10:02 +0200
From: Christian Herzog <horeizo@phys.ethz.ch>
In-Reply-To: <20100923135425.GA32476@infradead.org>
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
	<eb1b2cfa58cddc44c92c3a87a0e0a6c4@phys.ethz.ch>
	<20100923103802.GA16984@infradead.org>
	<5c4318884cb2c4d3983fd5231c2e4b17@phys.ethz.ch>
	<20100923135425.GA32476@infradead.org>
Message-ID: <77e6c761e37345ccf7bcd052096511c3@phys.ethz.ch>
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


> On Thu, Sep 23, 2010 at 01:52:46PM +0200, Christian Herzog wrote:
>> > Btw, what target do you use?  According to
>> > http://www.spinics.net/lists/linux-stgt/msg02038.html it seems like the
>> > stgt iser target has some issues that look quite similar to yours.
>> we're using tgt which might have a similar problem.
> 
> tgt and stgt is actually one and the same - the name is used a little
> bit inconsistently.
oh *blush*
well I guess this might be our issue then..

>> As even IB over TCP is several times faster than our disks, we will now
>> proceed w/o iSER to have the system running and then experiment with
>> iSER on a test system.
> 
> At least for NFS using RDMA natively mostly affects CPU usage and not
> throughput, so if you have some CPU cycles to spare it might not make
> much of a difference.
even in our hardcore torture tests the system load is pretty
reasonable, so I guess we're good.

thanks,
-Christian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
