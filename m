Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQ4JOsG110601 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 22:19:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92D641A8326
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 20:21:03 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	nRA5XEv1APQm9fZe for <xfs@oss.sgi.com>;
	Thu, 25 Nov 2010 20:21:03 -0800 (PST)
Date: Fri, 26 Nov 2010 15:20:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101126042059.GG12187@dastard>
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
	<4CEEF275.7090800@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEEF275.7090800@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Fri, Nov 26, 2010 at 12:34:13AM +0100, Spelic wrote:
> On 11/23/2010 09:46 PM, Dave Chinner wrote:
> >...
> >I note that the load is
> >generating close to 10,000 iops on my test system, so it may very
> >well be triggering load related problems in your raid controller...
> 
> Dave thanks for all explanations on the BBWC,
> 
> I wanted to ask how can you measure that it's 10,000 IOPS with that
> workload. Is it by iostat -x ?

http://marc.info/?l=linux-fsdevel&m=129013629728687&w=2

> but only for a few shots of iostat, not for the whole run of the
> "benchmark". Do you mean you have 10000 averaged over the whole
> benchmark?

It peaked at over 10,000 iops, lowest rate was ~4000iops and the
average would have been around 7000iops.

> Also I'm curious, do you remember how much time does it take to
> complete one run (10 parallel tar unpacks) on your 12-disk raid0 +
> BBWC?

33 seconds, with it being limited by the decompression rate (i.e. CPU
bound).

> Probably a better test would excluding the unbzip2 part from the
> benchmark, like the following but it probably won't make more than
> 10sec difference:
> 
> /perftest/xfs# bzcat linux-2.6.37-rc2.tar.bz2 > linux-2.6.37-rc2.tar
> /perftest/xfs# mkdir dir{1,2,3,4,5,6,7,8,9,10}
> /perftest/xfs# for i in {1..10} ; do time tar -xf
> linux-2.6.37-rc2.tar -C dir$i & done ; echo waiting now ; time wait;
> echo syncing now ; time sync

I'm currently running qa test right now on my test machine, so I
don't have a direct comparison with the above number for you.

However, my workstation has a pair of 120GB sandforce 1200 SSDs in
RAID0 running 2.6.37-rc1 w/ delaylog and the results are 40s for the
compressed tarball and 16s for the uncompressed tarball.

The uncompressed tarball run had lower IOPS and much higher
bandwidth as much more merging in the IO elevators was being done
compared to the compressed tarball...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
