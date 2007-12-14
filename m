Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Dec 2007 22:26:10 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBE6Q1ZI003375
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 22:26:08 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4941D1142820
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 22:26:13 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183]) by cuda.sgi.com with ESMTP id m6P67k5DtPHCAkhQ for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 22:26:13 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so1679582waf.18
        for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 22:26:12 -0800 (PST)
Message-ID: <f0e429340712132219i7ccff209h7b098dc7f694bcb2@mail.gmail.com>
Date: Fri, 14 Dec 2007 07:19:58 +0100
From: "KE Liew" <ke.liew@gmail.com>
Subject: Re: mount: Function not implemented
In-Reply-To: <f0e429340712132137j27b92e3ew8cadffef0208edd5@mail.gmail.com>
MIME-Version: 1.0
References: <f0e429340712130746i9b24c15j8dd8f53a9da2c4c4@mail.gmail.com>
	 <20071213224749.GJ4396912@sgi.com> <47620148.2060401@sandeen.net>
	 <20071214052833.GM4396912@sgi.com>
	 <f0e429340712132137j27b92e3ew8cadffef0208edd5@mail.gmail.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Just for document purposes...

sandeen mentioned to do,

dd if=/dev/hdb bs=512 count=128  | hexdump -C | grep XFSB

00000000  58 46 53 42 00 01 00 00  00 00 00 00 00 3a 38 b0  |XFSB.........:8.|
00007e00  58 46 53 42 00 00 10 00  00 00 00 00 03 a3 88 a0  |XFSB............|
128+0 records in
128+0 records out
65536 bytes (66 kB) copied, 0.0283236 seconds, 2.3 MB/s


So recreating the partition should work. First we backup the sectors.

dd if=/dev/hdb bs=512 count=256 of=backup_sectors

Then the partition is recreated using fdisk /dev/hdb, option n -> p (primary
-> 1 for partition 1 -> default first cylinder 1 -> default last cylinder
30401 -> (w)rite table to disk and exit. :)

Running xfs_check /dev/hdb1 returns no errors, which was hoped. Mounting the
partition shows ALL files present! So everything is working back to normal.

Thanks to XFS team and sandeen! :)


KwangErn


[[HTML alternate version deleted]]
