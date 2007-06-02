Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 15:55:48 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l52MtiWt001689
	for <xfs@oss.sgi.com>; Sat, 2 Jun 2007 15:55:45 -0700
Date: Sat, 2 Jun 2007 18:55:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <4661F511.4070207@goop.org>
Message-ID: <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan>
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
 <4661F511.4070207@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sat, 2 Jun 2007, Jeremy Fitzhardinge wrote:

> Justin Piszcz wrote:
>> Wondering as their were a lot of XFS related issues early on in
>> development..? The 2.6.22-rc3 kernel has the core 2 duo coretemp patch
>> by ruik which I want be running as long as 2.6.22-rc3 does not have
>> any severe XFS issues?
>
> XFS currently has a data-corrupting bug, where files which were appended
> by small amounts may lose their updates on umount - I see this
> corrupting hg repos. There's a patch which works for me, and is in
> 2.6.22-rc3-mm1, but it hasn't been merged upstream yet.
>
> J
>
>

Ah that's it- and USB appears to be broken as well, I'll stick with 
2.6.21.3 for now.

Thanks!

Justin.
