Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n741kPKU132990 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 20:46:30 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5397DADF523
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 18:56:34 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id odxPhFsPIFZ0Azss for
	<xfs@oss.sgi.com>; Mon, 03 Aug 2009 18:56:34 -0700 (PDT)
Date: Mon, 3 Aug 2009 18:47:11 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: kernel BUG at lib/radix-tree.c:464
In-Reply-To: <20090803210358.GA15109@infradead.org>
Message-ID: <alpine.DEB.2.01.0908031837400.5831@bogon.housecafe.de>
References: <alpine.DEB.2.01.0908022321060.5831@bogon.housecafe.de>
	<20090803122440.GA11033@infradead.org>
	<alpine.DEB.2.01.0908031340300.5831@bogon.housecafe.de>
	<20090803210358.GA15109@infradead.org>
MIME-Version: 1.0
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

On Mon, 3 Aug 2009 at 17:03, Christoph Hellwig wrote:
> The latest patch is for 2.6.30, then one before is for the current
> git tree.

OK, got it. Applied and compiled OK now. But I was trying to reproduce 
this one first without the patch and creating a similar or even bigger 
workload on the box: well, the "box" is a netbook (1 GB RAM, 1.6GHz Atom) 
and right now there are running 4 instances of bonnie++, 1 tar, 1 
tiobench, 1 rsync all reading and writing from/to the same XFS partition 
as in my initial report, where only 1 rsync operation was in progress - 
which usually creates quite a lot I/O by itself, but I though I should 
hammer on the box a bit more to trigger this. Load is now at 13, far 
higher than it was yesterday, but no BUG or any sign of instability. (Hm, 
this is usually a good thing, right?)

So, yes - I could now boot again with the fix applied, but I'm not sure 
what to report then, as it's not visible that something would be "fixed".


Thanks,
Christian.
-- 
BOFH excuse #288:

Hard drive sleeping. Let it wake up on it's own...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
