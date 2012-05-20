Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4KGZ8Zn187645 for <xfs@oss.sgi.com>; Sun, 20 May 2012 11:35:08 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id LCFtMNKZG7BN2pj2 for
	<xfs@oss.sgi.com>; Sun, 20 May 2012 09:35:07 -0700 (PDT)
Date: Sun, 20 May 2012 17:35:06 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120520163506.GA7473@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com> <20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com> <20120504163237.GA6128@nsrc.org>
	<4FA4C321.2070105@hardwarefreak.com> <20120515140237.GA3630@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120515140237.GA3630@nsrc.org>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Another update:

I have been trying some various combinations to see under what circumstances
I can make things lock up.

The main discovery: using ext4 instead of xfs, I cannot get the server to
lock up - after 36 hours of continuous testing anyway. With xfs and
everything else identical, it typically locks up within 10 minutes.

This is not to say that xfs is at fault. It may be that xfs generates a
higher peak load of I/O ops or something, and that tickles the problem.  In
any case I see a mixture of unkillable processes: not only bonnie++ and
xfsaild but I have also seen kswapd, kworker, irqbalance, even postfix
processes (which should not even be touching the 24-disk array; there is a
separate system disk directly connected to the motherboard's own SATA
controller)

The test is running four concurrent bonnie++ sessions in separate screen
sessions.

Some of the tests performed:

- 24 SATA disks, LSI HBAs, md RAID0, XFS: rapid lockup

- 24 SATA disks, LSI HBAs, md RAID0, ext4: no lockup seen so far

- 2 SATA disks, LSI HBAs, md RAID0, XFS: no lockup

- 1 system SATA disk, motherboard SATA, no RAID, ext4: no lockup

I did also write a ruby script to do lots of concurrent dd reads (at random
offsets) directly from the array. I wasn't able to replicate the problem
with that.

This is with Seagate 7200rpm drives, and the total I/O bandwidth I can see
is quite a lot (see iostat below).  I can also replicate the problem in a
similar system with Hitachi "coolspin" (5940rpm?) drives, but it seems to
take somewhat longer, maybe an hour or two, so perhaps the peak I/O ops is
something to do with it?

(These systems do have only 8GB RAM, so I also wondered if it was something
to do with deadlocking when allocating buffer space if not enough was
available)

Regards,

Brian.


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.55    0.00   80.67   12.63    0.00    5.15

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               0.40         0.00         2.40          0         12
sdf             187.80     17817.60    109416.80      89088     547084
sde             182.60     17817.60    112051.20      89088     560256
sdd             183.00     17817.60    108800.00      89088     544000
sdc             167.00     17612.80    105840.80      88064     529204
sdg             162.80     17612.80    107735.20      88064     538676
sdh             180.00     18022.40    112230.40      90112     561152
sdp             168.20     17408.00    107929.60      87040     539648
sdj             179.60     17614.40    111346.40      88072     556732
sdq             174.20     17408.00    108544.00      87040     542720
sdk             201.60     17612.80    111206.40      88064     556032
sdb             189.20     17819.20    108800.00      89096     544000
sdl             195.60     17542.40    110387.20      87712     551936
sdo             196.00     17408.00    111206.40      87040     556032
sdm             200.00     17408.00    110796.80      87040     553984
sdn             189.00     17408.00    108544.00      87040     542720
sdi             168.60     18022.40    112025.60      90112     560128
sdr             192.60     17819.20    111858.40      89096     559292
sdu             193.80     17612.80    108953.60      88064     544768
sdv             202.60     17612.80    108851.20      88064     544256
sdw             178.20     17612.80    108953.60      88064     544768
sdy             191.60     17612.80    110796.80      88064     553984
sdx             196.00     17612.80    111616.00      88064     558080
sds             182.80     17612.80    109158.40      88064     545792
sdt             191.60     17203.20    111219.20      86016     556096
md127          7569.80    415064.00   2620999.20    2075320   13104996

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
