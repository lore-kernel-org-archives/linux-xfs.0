Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 04:47:01 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB5Ckt75013901
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 04:46:58 -0800
Date: Wed, 5 Dec 2007 07:47:05 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS unable to mount, recover data
In-Reply-To: <475696D3.60007@pandora.be>
Message-ID: <Pine.LNX.4.64.0712050745480.13960@p34.internal.lan>
References: <475696D3.60007@pandora.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denis Wegge <denis_wegge@pandora.be>
Cc: xfs@oss.sgi.com



On Wed, 5 Dec 2007, Denis Wegge wrote:

> Hello
>
> I am having trouble with the XFS filesystem on a 320GB Western Digital
> SATA harddisk. For no obvious reason the partition can no longer be
> mounted. The following error occurs:
>
> knoppix@Knoppix:~$ sudo mount /dev/sda1 /mnt/sda1
> mount: /dev/sda1: can't read superblock

Looks like your disk is dying or dead from your logs.  You can try putting it
in a plastic airtight bag then put it in the freezer and try again but
otherwise if that does not work, its time for the trash bin (after you try)
a dd and overwrite the disk but with that many bad sectors it looks like
it has really gone south.

Insert new disk, restore from backup.

Justin.
