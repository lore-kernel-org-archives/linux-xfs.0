Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 02:59:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2B9xNPl018547
	for <linux-xfs@oss.sgi.com>; Tue, 11 Mar 2008 02:59:25 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34DB4F60284
	for <linux-xfs@oss.sgi.com>; Tue, 11 Mar 2008 02:59:53 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id 036j3u51AyA9OyHO for <linux-xfs@oss.sgi.com>; Tue, 11 Mar 2008 02:59:53 -0700 (PDT)
Received: from nb27steigerwald.qs.de (unknown [212.204.70.254])
	by mail.lichtvoll.de (Postfix) with ESMTP id E0FDC5ADD6
	for <linux-xfs@oss.sgi.com>; Tue, 11 Mar 2008 10:59:50 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: disappearing xfs partition
Date: Tue, 11 Mar 2008 10:59:50 +0100
References: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com> <e03b90ae0803031407n6693d1b3k268d8858504a9ce9@mail.gmail.com> <e03b90ae0803031856s42ddf82dudb7fa9d84a637498@mail.gmail.com> (sfid-20080304_090400_023531_C318561D)
In-Reply-To: <e03b90ae0803031856s42ddf82dudb7fa9d84a637498@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200803111059.50596.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 04 März 2008 schrieb Jeff Breidenbach:
> Following up and close out the topic, I got this comment from Eric.
>
> >So parted has this bad habit of making partition tables that cannot
> >actually be read from the disk, and poking the supposedly values
> >directly into the kernel.  Then things work fine until reboot, at
> > which time the partition table cannot be properly read.   Usually
> > this turns into a truncated size due to an overflow....
>
> I'd been using cfdisk and not parted, but that's apparently what
> happened. Rewriting the partition table with cfdisk fixed everything
> and allowed the partition to mount. At least for this boot.

Hi Jan,

Its always a good idea to check whether the kernel reread the partition 
table after partitioning with

cat  /proc/partitions

If it doesn't have you can tell the kernel to do it manually:

blockdev --rereadpt /dev/sde

If that tells you something about device is busy or so you'd need to 
unmount partitions on it or reboot.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
