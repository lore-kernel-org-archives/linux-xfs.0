Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHLe8P6015230 for <xfs@OSS.SGI.com>; Wed, 17 Dec 2008 15:40:09 -0600
Received: from partygirl.tmr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57E142DDE1
	for <xfs@OSS.SGI.com>; Wed, 17 Dec 2008 13:40:06 -0800 (PST)
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246]) by
	cuda.sgi.com with ESMTP id pWH1rADYM7J1JIZo for
	<xfs@OSS.SGI.com>; Wed, 17 Dec 2008 13:40:06 -0800 (PST)
Message-ID: <494971B2.1000103@tmr.com>
Date: Wed, 17 Dec 2008 16:40:02 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>	<1229225480.16555.152.camel@localhost>	<18757.4606.966139.10342@tree.ty.sabi.co.uk>	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
In-Reply-To: <18757.33373.744917.457587@tree.ty.sabi.co.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>

Peter Grandi wrote:
> Unfortunately that seems the case.
>
> The purpose of barriers is to guarantee that relevant data is
> known to be on persistent storage (kind of hardware 'fsync').
>
> In effect write barrier means "tell me when relevant data is on
> persistent storage", or less precisely "flush/sync writes now
> and tell me when it is done". Properties as to ordering are just
> a side effect.
>   

I don't get that sense from the barriers stuff in Documentation, in fact 
I think it's essentially a pure ordering thing, I don't even see that it 
has an effect of forcing the data to be written to the device, other 
than by preventing other writes until the drive writes everything. So we 
read the intended use differently.

What really bothers me is that there's no obvious need for barriers at 
the device level if the file system is just a bit smarter and does it's 
own async io (like aio_*), because you can track writes outstanding on a 
per-fd basis, so instead of stopping the flow of data to the drive, you 
can just block a file descriptor and wait for the count of outstanding 
i/o to drop to zero. That provides the order semantics of barriers as 
far as I can see, having tirelessly thought about it for ten minutes or 
so. Oh, and did something very similar decades ago in a long-gone 
mainframe OS.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
