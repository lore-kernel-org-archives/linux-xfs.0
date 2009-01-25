Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PFlH0c138075 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 09:47:18 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A2821BAB8BA
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 07:46:33 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id P7C6ubWIjZFxJyU5 for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 07:46:33 -0800 (PST)
Message-ID: <497C8937.8080102@sandeen.net>
Date: Sun, 25 Jan 2009 09:45:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
	<alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com

Justin Piszcz wrote:

> One final question, without udev, how does one determine the UUID of a non-XFS
> partition, e.g., swap?
> 
> $ ls -l
> total 0
> lrwxrwxrwx 1 root root  9 2009-01-25 01:54 203fcd30-4e56-40e9-a8e5-93ddc8eb536a -> ../../md0
> lrwxrwxrwx 1 root root 10 2009-01-25 01:54 2ef862e1-cf78-4065-a205-d1784716d633 -> ../../sdd1
> lrwxrwxrwx 1 root root 10 2009-01-25 01:54 77ae4251-631f-4656-a365-c5723f5c5da8 -> ../../sdd2
> 
> p254:~# find /proc/|grep -i uuid
> /proc/sys/kernel/random/uuid
> p254:~# find /sys/|grep -i uuid 
> p254:~#

blkid:

[root@mythbox ~]# blkid /dev/sda?
/dev/sda1: LABEL="/movies" UUID="38da660b-3600-4508-a608-2e1a20041ecb"
TYPE="xfs"
/dev/sda2: LABEL="/video" UUID="7b5583ae-cd42-4db1-9868-d96a5ccd3fea"
TYPE="xfs"
/dev/sda3: LABEL="/boot" UUID="379dbe60-1988-47b9-9891-17038abcc1f0"
TYPE="ext3" SEC_TYPE="ext2"
/dev/sda5: LABEL="/" UUID="c7bd2307-e067-4185-a7a0-d8d54057f3b9" TYPE="xfs"
/dev/sda6: TYPE="swap" LABEL="SWAP-sda6"
UUID="ea3f5dae-2509-4764-a93e-b777e72fdfbd"

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
