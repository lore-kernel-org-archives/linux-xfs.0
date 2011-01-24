Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ON15Zx131408 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 17:01:06 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 428D51054265
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 15:03:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XDLqIAybp6MVCOB8 for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 15:03:26 -0800 (PST)
Date: Tue, 25 Jan 2011 10:03:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Optimize RAID0 for max IOPS?
Message-ID: <20110124230314.GA11040@dastard>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
	<20110124215713.82D75B187@gemini.denx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110124215713.82D75B187@gemini.denx.de>
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
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Mon, Jan 24, 2011 at 10:57:13PM +0100, Wolfgang Denk wrote:
> Dear Justin,
> 
> In message <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan> you wrote:
> > 
> > Some info on XFS benchmark with delaylog here:
> > http://comments.gmane.org/gmane.comp.file-systems.xfs.general/34379
> 
> For the record: I tested both the "delaylog" and "logbsize=262144" on
> two systems running Fedora 14 x86_64 (kernel version
> 2.6.35.10-74.fc14.x86_64).
> 
> 
> Test No.	Mount options
> 1		rw,noatime
> 2		rw,noatime,delaylog
> 3		rw,noatime,delaylog,logbsize=262144
> 
> 
> System A: Gigabyte EP35C-DS3R Mainbord, Core 2 Quad CPU Q9550 @ 2.83GHz, 4 GB RAM
> --------- software RAID 5 using 4 x old Maxtor 7Y250M0 S-ATA I disks
> 	  (chunk size 16 kB, using S-ATA ports on main board), XFS
> 
> Test 1:
> 
> Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> A1               8G   844  96 153107  19 56427  11  2006  98 127174  15 369.4   6
> Latency             13686us    1480ms    1128ms   14986us     136ms   74911us
> Version  1.96       ------Sequential Create------ --------Random Create--------
> A1                  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16   104   0 +++++ +++   115   0    89   0 +++++ +++   111   0

Only 16 files? You need to test something that takes more than 5
milliseconds to run. Given that XFS can run at >20,000 creates/s for
a single threaded sequential create like this, perhaps you should
start at 100,000 files (maybe a million) so you get an idea of
sustained performance.

.....

> I do not see any significant improvement in any of the parameters -
> especially when compared to the serious performance degradation (down
> to 44% for block write, 42% for block read) on system A.

delaylog does not affect the block IO path in any way, so something
else is going on there. You need to sort that out before drawing any
conclusions.

Similarly, you need to test something relevant to your workload, not
use a canned benchmarks in the expectation the results are in any
way meaningful to your real workload. Also, if you do use a stupid
canned benchmark, make sure you configure it to test something
relevant to what you are trying to compare...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
