Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUNewIB009747 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:40:58 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5366253CED
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:40:57 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	frcNrlX0IKjauqU7 for <xfs@oss.sgi.com>;
	Tue, 30 Dec 2008 15:40:57 -0800 (PST)
Date: Wed, 31 Dec 2008 10:35:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsaild wakeups
Message-ID: <20081230233522.GB10725@disturbed>
References: <20081229232915.GA6724@memak.tu-darmstadt.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081229232915.GA6724@memak.tu-darmstadt.de>
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
To: Elrond <elrond+xfs.oss.sgi.com@samba-tng.org>, xfs@oss.sgi.com

On Tue, Dec 30, 2008 at 12:29:15AM +0100, Elrond wrote:
> 
> Hi,
> 
> The major issue of xfsaild wakeups was analyzed in
> February. (see
> http://oss.sgi.com/archives/xfs/2008-02/msg00169.html ).
> 
> A small issue persists. We're now at 1 wakeup per second
> and mounted filesystem. I have three xfs on my box and the
> number wants to grow. xfsaild is on place two of my
> powertop wakeup list. Sometimes place one.
> 
> Is anyone working on reducing this to zero for an idle fs?

It's on the list of things to do given that 2.6.29 will have
the fix for the bug that the periodic wakeup is catching.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
