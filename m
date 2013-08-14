Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B27FA7F62
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 13:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A473E8F8068
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 11:13:31 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id yAV4QIQtKBAbUKUO for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 11:13:30 -0700 (PDT)
Message-ID: <520BC8B1.9060106@allmail.net>
Date: Wed, 14 Aug 2013 20:13:05 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <520B1B4F.9070800@hardwarefreak.com>
	<520B9CCF.1040908@allmail.net> <520BBEFB.9030002@hardwarefreak.com>
In-Reply-To: <520BBEFB.9030002@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Stan Hoeppner wrote:
> If you keep growing until you consume the disk, you'll have ~100
> allocation groups.  Typically you'd want to have no more than 4 AGs per
> spindle.  You already have 42 (or 45) which will tend to seek the disk
> to death with many workloads, driving latency through the roof and
> decreasing throughput substantially.  Do you notice any performance
> problems yet?

What are expected rates for copying e.g. a 10GB file? It's a Seagate
Barracuda 3000GB Model ST3000DM001 SATA connected to SATA 6 Gb/s chip.
The source and the destination FS is LUKS crypted. About 3 GB usable RAM
(cache), AMD FX-8350 processor @ max. 3800MHz.

It's getting slower as more as the free space on the fs is reduced
(beginning at about the last GB). Resizing it makes the problem
disappear again.

> Or is this XFS strictly being used as a WORM like backup
> silo?

yes


Thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
