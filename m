Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1IFNwd9222658 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 09:23:59 -0600
Received: from homer.spinpro.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C96F1EB241D
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 07:26:39 -0800 (PST)
Received: from homer.spinpro.com (mail.spinpro.com [206.223.182.178]) by
	cuda.sgi.com with ESMTP id kNxdCg6crVJwMAmE for
	<xfs@oss.sgi.com>; Fri, 18 Feb 2011 07:26:39 -0800 (PST)
Message-ID: <4D5E8FAD.9080802@spinpro.com>
Date: Fri, 18 Feb 2011 10:26:37 -0500
From: Andrew Klaassen <ak@spinpro.com>
MIME-Version: 1.0
Subject: Re: External log size limitations
References: <4D5C1D77.1060000@spinpro.com> <20110217003233.GH13052@dastard>
In-Reply-To: <20110217003233.GH13052@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> The limit is just under 2GB now - that document is a couple of years
> out of date - so if you are running on anything more recent that a
> ~2.6.27 kernel 2GB logs should work fine.

Ah, good to know.

> Data write speed or metadata write speed? What sort of write
> patterns?

A couple of hundred nodes on a renderfarm doing mostly compositing with 
some 3D.  It's about 80/20 read/write.  On the current system that we're 
thinking of converting - an Exastore version 3 system - browsing the 
filesystem becomes ridiculously slow when write loads become moderate, 
which is why snappier metadata operations are attractive to us.

One thing I'm worried about, though, is moving from the Exastore's 64K 
block size to the 4K Linux blocksize limitation.  My quick calculation 
says that that's going to reduce our throughput under random load (which 
is what a renderfarm becomes with a couple of hundred nodes) from about 
200MB/s to about 13MB/s with our 56x7200rpm disks.  It's too bad those 
large blocksize patches from a couple of years back didn't go through to 
make this worry moot.

 > Also, don't forget that data is not logged so increasing
> the log size won't change the speed of data writeback.

Yes, of course... that momentarily slipped my mind.

> As it is, 2GB is still not enough for preventing metadata writeback
> for minutes if that is what you are trying to do.  Even if you use
> the new delaylog mount option - which reduces log traffic by an
> order of magnitude for most non-synchronous workloads - log write
> rates can be upwards of 30MB/s under concurrent metadata intensive
> workloads....

Is there a rule-of-thumb to convert number of files being written to log 
write rates?  We push a lot of data through, but most of the files are a 
few megabytes in size instead of a few kilobytes.

> If you want a log larger than 2GB, then there is a lot of code
> changes in both kernel an userspace as the log arithmetic is all
> done via 32 bit integers and a lot of it is byte based.

Good to know.

> As it is, there are significant scaling issues with logs of even 2GB
> in size - log replay can take tens of minutes when a log full of
> inode changes have to be replayed,

We've got decent a UPS, so unless we get kernel panics, those tens of 
minutes for an occasional unexpected hard shutdown should mean less lost 
production time than the drag of slower metadata operations all the time.

 > filling a 2GB log means you'll
> probably have ten of gigabytes of dirty metadata in memory, so
> response to memory shortages can cause IO storms and severe
> interactivity problems, etc.

I assume that if we packed the server with 128GB of RAM we wouldn't have 
to worry about that as much.  But... short of that, would you have a 
rule of thumb for log size to memory size?  Could I expect reasonable 
performance with a 2GB log and 32GB in the server?  With 12GB in the server?

I know you'd have to mostly guess to make up a rule of thumb, but your 
guesses would be a lot better than mine.  :-)

> In general, I'm finding that a log size of around 512MB w/ delaylog
> gives the best tradeoff between scalability, performance, memory
> usage and relatively sane recovery times...

I'm excited about the delaylog and other improvements I'm seeing 
entering the kernel, but I'm worried about stability.  There seem to 
have been a lot of bugfix patches and panic reports since 2.6.35 for XFS 
to go along with the performance improvements, which makes me tempted to 
stick to 2.6.34 until the dust settles and the kinks are worked out.  If 
I put the new XFS code on the server, will it stay up for a year or more 
without any panics or crashes?

Thanks for your great feedback.  This is one of the things that makes 
open source awesome.

Andrew


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
