Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o813JKNP099980 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 22:19:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A05B91798C4E
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 20:19:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	LSse624NfxZTty01 for <xfs@oss.sgi.com>;
	Tue, 31 Aug 2010 20:19:57 -0700 (PDT)
Date: Wed, 1 Sep 2010 13:19:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Message-ID: <20100901031954.GP705@dastard>
References: <201009010130.41500@zmi.at> <20100901000631.GO705@dastard>
	<201009010222.57350@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009010222.57350@zmi.at>
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
Cc: xfs@oss.sgi.com

On Wed, Sep 01, 2010 at 02:22:31AM +0200, Michael Monnerie wrote:
> On Mittwoch, 1. September 2010 Dave Chinner wrote:
> > You're probably getting RMW cycles on inode writeback. I've been
> > noticing this lately with my benchmarking - the VM is being _very
> > aggressive_ reclaiming page cache pages vs inode caches and as a
> > result the inode buffers used for IO are being reclaimed between the
> > time it takes to create the inodes and when they are written back.
> > Hence you get lots of reads occurring during inode writeback.
> > 
> > By issuing a sync, you clear out all the inode writeback and all the
> > RMW cycles go away. As a result, there is more disk throughput
> > availble for the unlink processes.  There is a good chance this is
> > the case as the number of reads after the sync drop by an order of
> > magnitude...
> 
> Nice explanation.
>  
> > > Now it can be that the sync just causes more writes and stalls
> > > reads so overall it's slower, but I'm wondering why none of the
> > > devices says "100% util", which should be the case on deletes? Or
> > > is this again the "mistake" of the utilization calculation that
> > > writes do not really show up there?
> > 
> > You're probably CPU bound, not IO bound.
> 
> This is a hexa-core AMD Phenom(tm) II X6 1090T Processor with up to 
> 3.2GHz per core, so that shouldn't be

I'm getting a 8core/16thread server being CPU bound with multithreaded
unlink workloads using delaylog, so it's entirely possible that all
CPU cores are fully utilised on your machine.

> - or is there only one core used? 
> I think I read somewhere that each AG should get a core or so...

If all the files are in one AG, then it will serialise on the AGI
header and won't use much more than one CPU.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
