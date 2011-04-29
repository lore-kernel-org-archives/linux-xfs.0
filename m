Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3TKDTUr079946 for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 15:13:29 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFAEC156935F
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 13:17:03 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id wMSOKGkkpSx8T4nU for
	<xfs@oss.sgi.com>; Fri, 29 Apr 2011 13:17:03 -0700 (PDT)
Date: Fri, 29 Apr 2011 22:17:01 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110429201701.GA13166@x4.trippels.de>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 2011.04.29 at 12:58 -0700, Christian Kujau wrote:
> On Fri, 29 Apr 2011 at 09:37, Dave Chinner wrote:
> > Did you read the email that pointed to CONFIG_TINY_RCU as the
> > ptotential source of the problem? Can you change to CONFIG_TREE_RCU
> > and see if the problem goes away?
> 
> Tried with TREE_RCU, unfortunately the problem persists. However, the OOM 
> messages did not make it to the disk this time. Syslog continued to work 
> until 11:51 (local time), the slabinfo-8-TREE_RCU.txt file was written to 
> until 11:57, the machine was already unusable at that point. At 12:07 I 
> took a "screenshot" and then powercycled the machine:
> 
>   http://nerdbynature.de/bits/2.6.39-rc4/oom/
>   (The files marked with -8 are the current ones)
> 
> Btw, the xfs filesystem I'm du'ing over is still mounted with "noatime".
> 
> Any ideas? Patches to try?

I could be the hrtimer bug again. Would you try to reproduce the issue
with this patch applied?
http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
