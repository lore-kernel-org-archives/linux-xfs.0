Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 01:07:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5S87ZtL020709
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 01:07:36 -0700
Date: Thu, 28 Jun 2007 04:07:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
In-Reply-To: <46832E60.9000006@rabbit.us>
Message-ID: <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <46832E60.9000006@rabbit.us>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

mdadm --create \
       --verbose /dev/md3 \
       --level=5 \
       --raid-devices=10 \
       --chunk=1024 \
       --force \
       --run
       /dev/sd[cdefghijkl]1

Justin.


On Thu, 28 Jun 2007, Peter Rabbitson wrote:

> Justin Piszcz wrote:
>> The results speak for themselves:
>> 
>> http://home.comcast.net/~jpiszcz/chunk/index.html
>> 
>
>
> What is the array layout (-l ? -n ? -p ?)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
