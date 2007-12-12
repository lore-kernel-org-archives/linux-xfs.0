Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 01:21:04 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBC9JXjI015357
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 01:19:35 -0800
Received: from astra.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1907470D7A
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 01:19:44 -0800 (PST)
Received: from astra.telenet-ops.be (astra.telenet-ops.be [195.130.132.58]) by cuda.sgi.com with ESMTP id ysjyJYdtdqZrBFAL for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 01:19:44 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by astra.telenet-ops.be (Postfix) with SMTP id 222F83810F
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 10:19:42 +0100 (CET)
Received: from [84.195.46.72] (d54C32E48.access.telenet.be [84.195.46.72])
	by astra.telenet-ops.be (Postfix) with ESMTP id 0E2AC3810B
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 10:19:41 +0100 (CET)
Message-ID: <475FA7B1.6070706@pandora.be>
Date: Wed, 12 Dec 2007 10:19:45 +0100
From: Denis Wegge <denis_wegge@pandora.be>
MIME-Version: 1.0
Subject: Re: XFS unable to mount, recover data
References: <475696D3.60007@pandora.be> <Pine.LNX.4.64.0712050745480.13960@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0712050745480.13960@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I tried putting it in the freezer, but that didn't help. Tests on
another computer also show that the hard drive cannot be accessed.

It seems like the data on the disk is definitely lost. The disk,
however, has a 3 year warranty, so I'm going to return it.

Thanks for your help.

Denis

Justin Piszcz wrote:
> 
> 
> On Wed, 5 Dec 2007, Denis Wegge wrote:
> 
>> Hello
>>
>> I am having trouble with the XFS filesystem on a 320GB Western Digital
>> SATA harddisk. For no obvious reason the partition can no longer be
>> mounted. The following error occurs:
>>
>> knoppix@Knoppix:~$ sudo mount /dev/sda1 /mnt/sda1
>> mount: /dev/sda1: can't read superblock
> 
> Looks like your disk is dying or dead from your logs.  You can try 
> putting it
> in a plastic airtight bag then put it in the freezer and try again but
> otherwise if that does not work, its time for the trash bin (after you try)
> a dd and overwrite the disk but with that many bad sectors it looks like
> it has really gone south.
> 
> Insert new disk, restore from backup.
> 
> Justin.
> 
> 
> 
