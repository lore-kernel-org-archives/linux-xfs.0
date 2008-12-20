Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBK5oFhd017679 for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 23:50:16 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4CA2396ED
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 21:50:14 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id GD6imG0K24FPBKFi for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2008 21:50:14 -0800 (PST)
Message-ID: <494C8793.5020901@sandeen.net>
Date: Fri, 19 Dec 2008 23:50:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests tests not in the auto group; do we know why?
References: <49473616.1020307@sandeen.net>	<20081219214411.GA18003@infradead.org>
	<20081220051015.GE17177@disturbed>
In-Reply-To: <20081220051015.GE17177@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:

> I'd say we should add another:
> 
> 	fast - tests that complete in only a few seconds
> 
> so that we can run a quicker set of sanity checks while developing
> stuff. The current auto run takes a couple of hours under UML, which
> means a qa cycle doesn't keep up with the rate at which I want to
> test new changes......

Since the tests keep track of how long they ran last time, maybe we can
make that sort of auto-tuning...?

Perhaps rather than "fast" - "slow" might be better because first, it'd
be fewer to mark, and also I think because of how we invoke & select things,

# ./check -g auto -x slow

would do what you want.

So is there agreement that "auto" by itself should include all tests
which are expected to pass (or not run due to dependencies) reliably?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
