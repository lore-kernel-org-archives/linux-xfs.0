Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Jan 2008 13:26:49 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0JLQeX5020758
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 13:26:45 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E388A53B154
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 13:26:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Z7Asb8iBErxigyvL for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 13:26:59 -0800 (PST)
Message-ID: <47926B02.709@sandeen.net>
Date: Sat, 19 Jan 2008 15:26:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Volume too big
References: <Pine.LNX.4.64.0801191650260.4780@fbirervta.pbzchgretzou.qr> <4792223E.7080805@sandeen.net> <Pine.LNX.4.64.0801191808100.4780@fbirervta.pbzchgretzou.qr> <47926087.3020600@sandeen.net> <Pine.LNX.4.64.0801192200390.4780@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801192200390.4780@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: xfs@oss.sgi.com

Jan Engelhardt wrote:
> On Jan 19 2008 14:41, Eric Sandeen wrote:

>> It's possible that btrfs can cope with this somehow - but also quite
>> possible that it's just missing the right checks :)
>>
> I am not sure why Linux would be limited to 16 TB. If LBD is on,
> things are 64 bit, so I would expect to have at least access to
> 2 exabyte.

64-bit sector addressing, but there is a 32-bit index into the (4k)
pagecache.

2^32 * 4096 is 16T

So an address space has a 16T limit.

Even mkfs, if it needs to write past 16T (and I think mkfs.btrfs doesn't
need that...) will have trouble, if the device is > 16T - unless mkfs
uses direct IO.

-Eric
