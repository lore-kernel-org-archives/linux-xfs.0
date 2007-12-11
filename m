Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 16:41:24 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lBB0fHWR001623
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 16:41:19 -0800
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 009CBB26F1F
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 16:41:24 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com with SMTP id 4x1upPEhdFTqWUUK for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 16:41:24 -0800 (PST)
From: "Chris" <hsvchris@gmx.de>
References: <002a01c83b74$52060330$f6120990$@de> <475DC056.3000502@sandeen.net>
In-Reply-To: <475DC056.3000502@sandeen.net>
Subject: AW: Unexpected XFS SB number 0x00000000
Date: Tue, 11 Dec 2007 01:41:07 +0100
Message-ID: <003401c83b8e$84c1d730$8e458590$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: de
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Eric Sandeen' <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

> Did your new partition table start in exactly the same place?
> 

I assumed it would be in the same place...
I guess there is no way to find out what the old one looked like?

> Can you find the string "XFSB" anywhere near where your old partition
> started?
> 

I can try to do so...how? :)
When I look into the partition with cfdisk, I can see what
cylinders/heads/sectors it uses. But I'm sure there are other tools?

Interestingly, after a reboot cfdisk shows me a 801575.31 MB partition and
2199023.26 MB free space, although I wrote a single partition of 3000598.57
MB into the table before rebooting.
