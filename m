Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 04:04:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4SB4BOV019852
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 04:04:12 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECEA8BF95E3
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 04:05:03 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id Gbo0bUDjj61aLCx7 for <xfs@oss.sgi.com>; Wed, 28 May 2008 04:05:03 -0700 (PDT)
Date: Wed, 28 May 2008 07:05:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <483D39D3.4020906@rabbit.us>
Message-ID: <alpine.DEB.1.10.0805280703400.23383@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D39D3.4020906@rabbit.us>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Wed, 28 May 2008, Peter Rabbitson wrote:

> Justin Piszcz wrote:
>> Hardware:
>> 
>> 1. Utilized (6) 400 gigabyte sata hard drives.
>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>> 
>> Used the following 'optimizations' for all tests.
>> 
>> # Set read-ahead.
>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>> blockdev --setra 65536 /dev/md3
>
> That's actually 65k x 512byte blocks so 32MiB
Ah whoops, thanks!

> Results are meaningless without a crucial detail - what was the chunk size 
> used during array creation time? Otherwise interesting test :)
Indeed, the chunk size used was 256 KiB for all tests.

Justin.
