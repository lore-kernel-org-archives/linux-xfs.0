Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6CDAgi011804 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 06:13:11 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECF301B949B9
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 04:13:09 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id uaapH0ME9MBWr4Oz for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 04:13:09 -0800 (PST)
Date: Sat, 6 Dec 2008 07:12:38 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: kernel 2.6.27.7 problem
In-Reply-To: <20081206091022.GA24158@bob.dscon.sk>
Message-ID: <alpine.DEB.1.10.0812060712160.8516@p34.internal.lan>
References: <20081206023608.GA22135@bob.dscon.sk>
	<4939F104.9060201@sandeen.net>
	<20081206091022.GA24158@bob.dscon.sk>
MIME-Version: 1.0
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
To: DS <xfs@bob.dscon.sk>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On Sat, 6 Dec 2008, DS wrote:

> No other messages before. No iSCSI/network messages...nothing.
> Only this few lines and FS is down. After remount it works ....while and
> hangs again.
> Few hours it runs back on 2.6.24.3 and everything is OK.
>
> It's production system, but I test it again in late night.
> What can I do to identify problem?
>
> Dusan

Run:
smartctl -a /dev/sde

Post output.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
