Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 08:39:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4SFdgcK019747
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 08:39:42 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1EBBBFB6F1
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 08:40:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id EEKZSd7EkuS4BdvA for <xfs@oss.sgi.com>; Wed, 28 May 2008 08:40:34 -0700 (PDT)
Message-ID: <483D7CE8.4000600@redhat.com>
Date: Wed, 28 May 2008 11:40:24 -0400
From: Chris Snook <csnook@redhat.com>
MIME-Version: 1.0
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> Hardware:
> 
> 1. Utilized (6) 400 gigabyte sata hard drives.
> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
> 
> Used the following 'optimizations' for all tests.
> 
> # Set read-ahead.
> echo "Setting read-ahead to 64 MiB for /dev/md3"
> blockdev --setra 65536 /dev/md3
> 
> # Set stripe-cache_size for RAID5.
> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
> 
> # Disable NCQ on all disks.
> echo "Disabling NCQ on all disks..."
> for i in $DISKS
> do
>   echo "Disabling NCQ on $i"
>   echo 1 > /sys/block/"$i"/device/queue_depth
> done

Given that one of the greatest benefits of NCQ/TCQ is with parity RAID, 
I'd be fascinated to see how enabling NCQ changes your results.  Of 
course, you'd want to use a single SATA controller with a known good NCQ 
implementation, and hard drives known to not do stupid things like 
disable readahead when NCQ is enabled.

-- Chris
