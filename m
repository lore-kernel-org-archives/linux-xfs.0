Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 10:53:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GHrFcM032260
	for <linux-xfs@oss.sgi.com>; Thu, 16 Oct 2008 10:53:15 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 414791418993
	for <linux-xfs@oss.sgi.com>; Thu, 16 Oct 2008 10:54:57 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id ELD9g8mDvULPe0cU for <linux-xfs@oss.sgi.com>; Thu, 16 Oct 2008 10:54:57 -0700 (PDT)
Received: from shambhala.lichtvoll.local (DSL01.212.114.229.215.ip-pool.NEFkom.net [212.114.229.215])
	by mail.lichtvoll.de (Postfix) with ESMTP id 1177642DFC
	for <linux-xfs@oss.sgi.com>; Thu, 16 Oct 2008 19:54:54 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: How can I recover data?
Date: Thu, 16 Oct 2008 19:54:51 +0200
References: <19996090.post@talk.nabble.com> <op.ui3qn3lk3jf8g2@pc-bnaujok.melbourne.sgi.com> <20013835.post@talk.nabble.com> (sfid-20081016_171232_462611_BD799205)
In-Reply-To: <20013835.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810161954.52216.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 16 Oktober 2008 schrieb ibulescu:
> Tried that too... but no luck.
>
> The only thing I've modified was
> "write core.mode 040755" and after some time of "printing inodes" I've
> runned xfs_repair in modify mode but nothing good happened. Almost all
> inodes have "next_unlinked" set to null and the time in 1 Jan 1970. The
> All folder has the time in 2008 but even after xfs_repair moved the
> folder in lost+found it's still empty and named 186.
>
> The conclusion is: all data lost? If so what is the best way to
> reformat the volume to not have the same problems again? The "no space
> left on the device" and "lose all data" problems?
> I have an UPS on that server, so the bad shutdown corruption will not
> happen.
>
> I know all the files and folders are still there because no write
> opperations occured but I don't have a way to read them because the
> filesystem can't find the "connections"...

If you have no backup and the data is important enough for you, you can 
try to use photorec from the testdisk package, foremost or magicrescue. 
photorec seems to have the most formats supported out of the box, 
foremost and magicrescue can be extended via recipes. Don't expect to be 
able to recover file and directory names tough.

With photorec I was able to recover photos from a smartmedia card that 
showed as empty in Linux while the camera showed the photos on it.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
