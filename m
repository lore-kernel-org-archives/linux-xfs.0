Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Mar 2008 06:09:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2GD8vdC027209
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2008 06:09:01 -0700
Received: from mail.g-house.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2FA012546CE
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2008 06:09:29 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75]) by cuda.sgi.com with ESMTP id SEY8I4rmt6iNvQmq for <xfs@oss.sgi.com>; Sun, 16 Mar 2008 06:09:29 -0700 (PDT)
Date: Sun, 16 Mar 2008 14:08:41 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120
 seconds
In-Reply-To: <200803152234.53199.chunkeey@web.de>
Message-ID: <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de> <200803152234.53199.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chr <chunkeey@web.de>
Cc: Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, dm-crypt@saout.de

On Sat, 15 Mar 2008, Chr wrote:
> On Saturday 15 March 2008 14:32:10 Chr wrote:
>> reverted:
>>
>> commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
>> dm crypt: use async crypto
>>
>> dm-crypt: Use crypto ablkcipher interface
>> Move encrypt/decrypt core to async crypto call.
>>
>
> well.... it's much better now, without the async interface.
> Christian Kajau, can you confirm it too?

I reverted the commit above from today's -git and booted....I could not 
notice any hangs more. But when I tried to reproduce these hangs by 
generating disk I/O (mostly reads) ~10 minutes later the box panicked, but
still not netconsole messages :-(

thanks,
C.
-- 
BOFH excuse #233:

TCP/IP UDP alarm threshold is set too low.
