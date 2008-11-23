Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mANLnbC2023393 for <xfs@oss.sgi.com>; Sun, 23 Nov 2008 15:49:37 -0600
Received: from buick.jordet.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4DA515CECBF
	for <xfs@oss.sgi.com>; Sun, 23 Nov 2008 13:49:35 -0800 (PST)
Received: from buick.jordet.net (buick.jordet.net [193.91.240.190]) by
	cuda.sgi.com with ESMTP id 1ABmIJit4JvBneGP for
	<xfs@oss.sgi.com>; Sun, 23 Nov 2008 13:49:35 -0800 (PST)
Subject: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
From: Stian Jordet <liste@jordet.net>
In-Reply-To: <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
References: <1226760254.5089.11.camel@chevrolet>
	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
Date: Sun, 23 Nov 2008 22:48:28 +0100
Message-Id: <1227476908.32357.5.camel@chevrolet>
Mime-Version: 1.0
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
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

ti., 18.11.2008 kl. 11.51 -0200, skrev Sergio Luis: 
> please post your config and dmesg output. It might help people try to
> identify something wrong.

(see http://marc.info/?l=linux-kernel&m=122676220019858&w=2 for the
start of this thread)

Hmm. I have now converted my root and /home filesystems to ext3, and
that actually fixed it (!). I have no idea why xfs is performing so
extremely poorly on this machine, i'm running xfs on every filesystem on
eight other computers (one heavy loaded server, as well).

Anyway, I'm now unpacking the 2.6.27.6 kernel in 15 seconds, with xfs on
the same array it used between five and six minutes.

I still have a xfs array, and when I copy files to or from that array,
the gnome session practically freezes, and the load average easily goes
beyond 10.

How should I debug this? I'm not very eager about reformatting my 1,5TB
xfs array... Besides, xfs have never let me down earlier.

Thanks.

Please cc me on any replies.

Regards,
Stian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
