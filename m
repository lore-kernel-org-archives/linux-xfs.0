Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8Ekej1006222
	for <linux-xfs@oss.sgi.com>; Mon, 8 Dec 2008 08:46:40 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A011E41
	for <linux-xfs@oss.sgi.com>; Mon,  8 Dec 2008 06:46:38 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id kAZDnXXe9tFpEXOh for <linux-xfs@oss.sgi.com>;
	Mon, 08 Dec 2008 06:46:38 -0800 (PST)
Message-ID: <493D334C.5010006@sandeen.net>
Date: Mon, 08 Dec 2008 08:46:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS over SSD
References: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
In-Reply-To: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
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
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

Raz wrote:
> I am thinking of using XFS over a SSD disk.
> 1. Can I separate xfs meta data ( not just the logging) from the SSD ?
> can I put the meta on a different disk ?

Are you talking about just the log (see the mkfs man page for external
logs, as Justin suggested) or all metadata?  For the latter, using the
realtime subvolume does accomplish this (data on one volume, metadata on
the other) but that's not used very often.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
