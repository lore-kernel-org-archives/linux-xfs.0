Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p064wuRY016102 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 22:59:02 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8218B4F4832
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 21:01:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Lq4JLgD2v2FRLXvo for <xfs@oss.sgi.com>;
	Wed, 05 Jan 2011 21:01:04 -0800 (PST)
Date: Thu, 6 Jan 2011 16:00:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27.30 fc10, some processes stuck in D state
Message-ID: <20110106050057.GF8322@dastard>
References: <8529A87D856C184491994079B5F87B68C1A8289FCC@EXMAIL03.jp.ykgw.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8529A87D856C184491994079B5F87B68C1A8289FCC@EXMAIL03.jp.ykgw.net>
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
To: yuji_touya@yokogawa-digital.com
Cc: xfs@oss.sgi.com

On Thu, Jan 06, 2011 at 01:18:27PM +0900, yuji_touya@yokogawa-digital.com wrote:
> Hello folks,
> 
> We need to save a bunch of transport-stream(TS) data(4MB/sec, 300GB/day), and
> are using xfs formatted hardware RAID system to save TS data.
> Some processes (pdflush, kswapd, our own services etc) stuck in D-state and
> our system stops saving and down-converting TS data.

Everything is waiting for log space to be freed. Typically a sign
that metadata has not been flushed or that IO completion has not occurred
so the tail is not moving forward.

> It rarely happens (3 times in recent 3 months), but it's quite serious for us.
> How can we avoid this?

What did you change 3 months ago? Or did this always happen?

> One more thing, in that situation when I run "ls /mnt/raid/foo" command, 
> all stuck processes suddenly wake up and continue running. Very strange...
> (/mnt/raid is where we mount xfs)

So doing new read IOs starts stuff moving again? That sounds like an IO
completion has not arrived from the lower layers until a new IO is
issued and completes. Perhaps the hardware RAID is not issuing an
interrupt when it should?

What type of RAID controller/storage hardware are you using? Is it
all running the latest firmware, appropriate drivers, etc?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
