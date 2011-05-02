Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42JuGPM246286 for <xfs@oss.sgi.com>; Mon, 2 May 2011 14:56:17 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FF3C1D62186
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 12:59:52 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id JrJ7wSan3HHeTk90 for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 12:59:52 -0700 (PDT)
Date: Mon, 2 May 2011 12:59:50 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110502121958.GA2978@dastard>
Message-ID: <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
References: <20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Mon, 2 May 2011 at 22:19, Dave Chinner wrote:
> Yes. Try 2 orders of magnitude as a start. i.e change it to 10000...

I've run the -12 test with vfs_cache_pressure=200 and now the -13 test 
with vfs_cache_pressure=10000. The OOM killer still kicks in, but the 
machine seems to be more usable afterwards and does not get totally stuck:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  - messages-12.txt.gz & slabinfo-12.txt.bz2
    * oom-debug.sh invoked oom-killer at 01:27:11
    * sysrq-w works until 01:27:08, but got killed by oom

  - messages-13.txt.gz & slabinfo-13.txt.bz2 
    * find invoked oom-killer at 08:44:07
    * sysrq-w works until 08:45:48 (listing jbd2/hda6-8), then
      my debug script got killed

Thanks,
Christian.
-- 
BOFH excuse #224:

Jan  9 16:41:27 huber su: 'su root' succeeded for .... on /dev/pts/1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
