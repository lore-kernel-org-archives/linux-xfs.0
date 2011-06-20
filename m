Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K0sIcd095823 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 19:54:18 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCA96172B55D
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 17:54:17 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id mtBauPsOaB2tEGcB for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 17:54:17 -0700 (PDT)
Date: Mon, 20 Jun 2011 02:54:15 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110620005415.GA1730@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110619222447.GI561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110619222447.GI561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2011.06.20 at 08:24 +1000, Dave Chinner wrote:
> On Sat, Jun 18, 2011 at 04:19:50PM +0200, Markus Trippelsdorf wrote:
> > Running the latest git kernel (3.0-rc3) my machine hangs for long
> > periods (1-2 sec) whenever I delete a large directory recursively on my
> > xfs partition. During the hang I cannot move the mouse pointer or use
> > the keyboard (but the music keeps playing without stuttering). A quick
> > way to reproduce is to "rm -fr" a kernel tree. 
> 
> So what is the system doing when it "hangs"? Is it CPU bound (e.g.
> cpu scheduler issue)? Is the system running out of memory and
> stalling everything in memory reclaim? What IO is occurring?

It's totally idle otherwise; just a desktop with a single xterm. The
machine has four cores (and also runs with "CONFIG_PREEMPT=y"), so I
don't think it is CPU bound at all. It has 8GB of memory (and the
"hangs" even occur after reboot when most of it is free). No other IO
activity is occurring.

> > This happens on a 4kb SATA hard drive:
> 
> How does this appear to the OS? as a 512/512, 512/4k or 4k/4k
> logical/physical sector size drive?

It unfortunately appears as 512/512, but because I know it's a 4KB
drive, I formated it with "-s size=4096".

> > xfs_info /var
> > meta-data=/dev/sda1              isize=256    agcount=4, agsize=12800000 blks
> >          =                       sectsz=4096  attr=2
> > data     =                       bsize=4096   blocks=51200000, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=25000, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > /dev/sda1 on /var type xfs (rw,noatime,attr2,delaylog,logbsize=256k,noquota)
> 
> Is your partition correctly sector aligned for however your drive
> maps it's 4k sectors?

Yes, it's a GPT partition that is aligned to 1MB.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
