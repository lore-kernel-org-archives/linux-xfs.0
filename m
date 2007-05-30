Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 09:11:54 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4UGBmWt011524
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 09:11:49 -0700
Date: Wed, 30 May 2007 17:11:42 +0100 (BST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable
 problem
In-Reply-To: <200705281730.53343.dap@mail.index.hu>
Message-ID: <alpine.DEB.0.99.0705301710100.10702@sheep.housecafe.de>
References: <200705241318.30711.dap@mail.index.hu> <20070525000547.GH85884050@sgi.com>
 <200705281453.55618.dap@mail.index.hu>
 <200705281730.53343.dap@mail.index.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pallai Roland <dap@mail.index.hu>
Cc: xfs@oss.sgi.com

On Mon, 28 May 2007, Pallai Roland wrote:
> /dev/loop1: [0700]:180907 (/dev/md1) encryption=AES128 multi-key-v3
> hq:~# dd if=/dev/md1 bs=1k count=128 skip=128 >/dev/null
> dd: reading `/dev/md1': Input/output error
> 0+0 records in
> 0+0 records out
> hq:~# dd if=/dev/loop1 bs=1k count=128 skip=128 | md5sum
> 128+0 records in
> 128+0 records out
> 131072 bytes (131 kB) copied, 0.027775 seconds, 4.7 MB/s
> e2548a924a0e835bb45fb50058acba98  - (!!!)
> hq:~# dd if=/dev/loop1 bs=1k count=128 skip=128 | md5sum
> 128+0 records in
> 128+0 records out
> 131072 bytes (131 kB) copied, 0.030311 seconds, 4.3 MB/s
> c6a23412fb75eb5a7eb1d6a7813eb86b  - (!!!)

Hm, looks nasty. Maybe you should send this to 
linux-crypto@nl.linux.org, where many loop-aes folks are hanging around?

C.
-- 
BOFH excuse #197:

I'm sorry a pentium won't do, you need an SGI to connect with us.
