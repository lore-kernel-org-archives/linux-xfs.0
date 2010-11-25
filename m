Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAPNVoAS083675 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 17:31:50 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AC9713EE124
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 15:33:27 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id VQTSIUAUZTpB1vfD for
	<xfs@oss.sgi.com>; Thu, 25 Nov 2010 15:33:27 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUOYG6S0GGLS4J9Q@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Fri, 26 Nov 2010 00:32:52 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUOYG5H5N4LKOS58@mx.isti.cnr.it> for xfs@oss.sgi.com; Fri,
	26 Nov 2010 00:32:08 +0100 (MET)
Received: from [164.132.81.212] by mx.isti.cnr.it (PMDF V6.5 #31826)
	with ESMTPSA id <01NUOYG1O4W8LOEK2Z@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Fri, 26 Nov 2010 00:32:05 +0100 (MET)
Date: Fri, 26 Nov 2010 00:34:13 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <20101123204609.GW22876@dastard>
Message-id: <4CEEF275.7090800@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
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
To: xfs@oss.sgi.com

On 11/23/2010 09:46 PM, Dave Chinner wrote:
> ...
> I note that the load is
> generating close to 10,000 iops on my test system, so it may very
> well be triggering load related problems in your raid controller...
>    

Dave thanks for all explanations on the BBWC,

I wanted to ask how can you measure that it's 10,000 IOPS with that 
workload. Is it by iostat -x ?

If yes, what cell do you exactly look at and what is the period you use 
for averaging values? I also can sometimes see values up to around 10000 
in the cell "w/s" that corresponds to my MD RAID array (currently a 16 
disk raid-5 with XFS delaylog), if I use

iostat -x 10      (this averages write IOPS on 10 seconds I think)

but only for a few shots of iostat, not for the whole run of the 
"benchmark". Do you mean you have 10000 averaged over the whole benchmark?

Also I'm curious, do you remember how much time does it take to complete 
one run (10 parallel tar unpacks) on your 12-disk raid0 + BBWC?

Probably a better test would excluding the unbzip2 part from the 
benchmark, like the following but it probably won't make more than 10sec 
difference:

/perftest/xfs# bzcat linux-2.6.37-rc2.tar.bz2 > linux-2.6.37-rc2.tar
/perftest/xfs# mkdir dir{1,2,3,4,5,6,7,8,9,10}
/perftest/xfs# for i in {1..10} ; do time tar -xf linux-2.6.37-rc2.tar 
-C dir$i & done ; echo waiting now ; time wait; echo syncing now ; time 
sync

Thanks for all explanations

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
