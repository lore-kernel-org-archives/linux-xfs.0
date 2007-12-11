Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 18:13:26 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBB2DJuF008176
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 18:13:22 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 331204687CD
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 18:13:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id TPazJcRCm8a9fV3E for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 18:13:29 -0800 (PST)
Message-ID: <475DF228.80306@sandeen.net>
Date: Mon, 10 Dec 2007 20:12:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Unexpected XFS SB number 0x00000000
References: <002a01c83b74$52060330$f6120990$@de> <475DC056.3000502@sandeen.net> <000301c83b92$191f6110$4b5e2330$@de>
In-Reply-To: <000301c83b92$191f6110$4b5e2330$@de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris <hsvchris@gmx.de>
Cc: linux-xfs@oss.sgi.com

Chris wrote:

> I just tested some more and using parted found out the following:
> 
> (parted) print
> Warning: /dev/sdb contains GPT signatures, indicating that is has a GPT
> table. However, it does not have a valid fake msdos partition table, as it
> should. Perhaps it was corrupted --  possibly by a program that doesn't
> understand GPT  partition tables. Or perhaps you deleted the GPT table, and
> are now using an msdos partition table. Is this a GPT partition table?
> Yes/No? y
> 
> Disk /dev/sdb: 3001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number	Start		End		Size		File system	Name
> Flags
> 1		17.4kB 	22250GB 	22250GB 	xfs
> 
> 
> So it seems that parted can still "see" the old table. But it doesn't have
> support for resizing xfs partitions...

So, did you originally have a gpt or an msdos partition table?
