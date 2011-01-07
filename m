Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07Awpq9036094 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 04:58:51 -0600
Received: from zns001-0m9003.yokogawa.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1009240289
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 03:00:59 -0800 (PST)
Received: from zns001-0m9003.yokogawa.co.jp (zns001-0m9003.yokogawa.co.jp
	[203.174.79.161]) by cuda.sgi.com with ESMTP id
	B7RZFlNC5digPW3a for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 03:00:59 -0800 (PST)
From: <yuji_touya@yokogawa-digital.com>
Date: Fri, 7 Jan 2011 20:00:38 +0900
Subject: RE: 2.6.27.30 fc10, some processes stuck in D state
Message-ID: <8529A87D856C184491994079B5F87B68C1A828A388@EXMAIL03.jp.ykgw.net>
References: <8529A87D856C184491994079B5F87B68C1A8289FCC@EXMAIL03.jp.ykgw.net>
	<20110106050057.GF8322@dastard>
In-Reply-To: <20110106050057.GF8322@dastard>
Content-Language: ja-JP
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Dave,

Thank you for your replying.

> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com] 
> Sent: Thursday, January 06, 2011 2:01 PM

> Everything is waiting for log space to be freed. Typically a sign
> that metadata has not been flushed or that IO completion has not occurred
> so the tail is not moving forward.

Nice to know it! It will help us.

> What did you change 3 months ago? Or did this always happen?

This always happens.

> So doing new read IOs starts stuff moving again? That sounds like an IO
> completion has not arrived from the lower layers until a new IO is
> issued and completes. Perhaps the hardware RAID is not issuing an
> interrupt when it should?

Yes, new read IOs seem to wake up them.
Are there any tools/ways to examine whether expected interrupt occurred or not?

> What type of RAID controller/storage hardware are you using? Is it
> all running the latest firmware, appropriate drivers, etc?

PCI Express adapter and an external RAID system, connected with fiber channel each other.
The BIOS, PCI Express adapter and RAID system's firmware are not up to date.
We will try to update these softwares and check if the same problem occur.
It would be nice to reproduce this problem as easy as posible.
If there is suitable application(benchmark or test program etc), please let me know.

Thanks.
Yuji

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
