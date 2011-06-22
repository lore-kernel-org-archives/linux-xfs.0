Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5M0Jg6k039169 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 19:19:42 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6617C22D3E
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 17:19:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tN0fO0jdCW0ftGRy for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2011 17:19:40 -0700 (PDT)
Date: Wed, 22 Jun 2011 10:19:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: improve sync behaviour in face of aggressive dirtying
Message-ID: <20110622001937.GR32466@dastard>
References: <20110617131401.GC2141@infradead.org>
	<20110620081802.GA27111@infradead.org>
	<20110621003343.GJ32466@dastard> <201106210921.48657@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201106210921.48657@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Wu Fengguang <fengguang.wu@intel.com>, xfs@oss.sgi.com

On Tue, Jun 21, 2011 at 09:21:46AM +0200, Michael Monnerie wrote:
> On Dienstag, 21. Juni 2011 Dave Chinner wrote:
> > > The minor one is that we always flush all work items and not just
> > > those on the filesystem to be flushed.  This might become an issue
> > > for lager systems, or when we apply a similar scheme to fsync,
> > > which has the same underlying issue.
> > 
> > For sync, I don't think it matters if we flush a few extra IO
> > completions on a busy system.
> 
> Couldn't that be bad on a system with mixed fast/slow storage (say 15k 
> SAS and 7.2k SATA), where on the busy fast SAS lots of syncs occur and 
> lead to extra I/O on the SATA disks? Especially if there are 16 SAS 
> disks in an array with RAID-0 against 4 SATA disks in RAID-6, to say the 
> worst. If the SATAs are already heavy used (say >=50%), those extra 
> writes could bring them to their knees.

We are not talking about issuing extra writes to disk, so you don't
have to worry about this. What we are talking about is how to
efficiently flush the XFS IO completion queues for writes that the
hardware has already completed. That's almost always just CPU
overhead and doesn't involve more IO.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
