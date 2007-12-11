Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 17:06:57 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBB16qoT003988
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 17:06:53 -0800
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B55D4B26DFD
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 17:07:02 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com with SMTP id sjBUCivXJi2OK1Ne for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 17:07:02 -0800 (PST)
From: "Chris" <hsvchris@gmx.de>
References: <002a01c83b74$52060330$f6120990$@de> <475DC056.3000502@sandeen.net> 
In-Reply-To: 
Subject: Re: Unexpected XFS SB number 0x00000000
Date: Tue, 11 Dec 2007 02:06:43 +0100
Message-ID: <000301c83b92$191f6110$4b5e2330$@de>
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

> > Did your new partition table start in exactly the same place?
> >
>
> I assumed it would be in the same place...
> I guess there is no way to find out what the old one looked like?
>
> > Can you find the string "XFSB" anywhere near where your old partition
> > started?
> >
>
> I can try to do so...how? :)
> When I look into the partition with cfdisk, I can see what
cylinders/heads/sectors it uses. But I'm > sure there are other tools?
>
> Interestingly, after a reboot cfdisk shows me a 801575.31 MB partition and
2199023.26 MB free space, > although I wrote a single partition of
3000598.57 MB into the table before rebooting.

I just tested some more and using parted found out the following:

(parted) print
Warning: /dev/sdb contains GPT signatures, indicating that is has a GPT
table. However, it does not have a valid fake msdos partition table, as it
should. Perhaps it was corrupted --  possibly by a program that doesn't
understand GPT  partition tables. Or perhaps you deleted the GPT table, and
are now using an msdos partition table. Is this a GPT partition table?
Yes/No? y

Disk /dev/sdb: 3001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number	Start		End		Size		File system	Name
Flags
1		17.4kB 	22250GB 	22250GB 	xfs


So it seems that parted can still "see" the old table. But it doesn't have
support for resizing xfs partitions...
