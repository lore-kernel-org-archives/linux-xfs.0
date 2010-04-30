Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U1Mrmj117140 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:22:59 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05CBD154FB07
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 18:24:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	a8BDQsTmyvfIby01 for <xfs@oss.sgi.com>;
	Thu, 29 Apr 2010 18:24:57 -0700 (PDT)
Date: Fri, 30 Apr 2010 11:11:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS write speed down
Message-ID: <20100430011106.GA32515@dastard>
References: <alpine.LSU.2.01.1004292322530.23248@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1004292322530.23248@obet.zrqbmnf.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

On Thu, Apr 29, 2010 at 11:46:33PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> Running 2.6.33.2, I am observing this 
> 
> used-xfs$ time ( tar -xf /dev/shm/linux-2.6.33.3.tar ; sync )
> real    12m29.272s
> user    0m0.196s
> sys     0m3.028s

What was the last kernel you ran that didn't have this slowdown?
I see the same test on 2.6.32 to my 2.6TB RAID6 volume take
about 35s.

Can you post the output of "echo w > /proc/sysrq-trigger" while
your test is running?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
