Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 02:26:00 -0700 (PDT)
Received: from ds666.l4x.org (mail.trixing.net [87.230.125.58])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6N9PcDW012646
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 02:25:38 -0700
Message-ID: <44C33080.3060108@l4x.org>
Date: Sun, 23 Jul 2006 10:17:04 +0200
From: Jan Dittmer <jdi@l4x.org>
MIME-Version: 1.0
References: <44C0B0E4.7020403@l4x.org> <44C2EEC5.4020804@sandeen.net>
In-Reply-To: <44C2EEC5.4020804@sandeen.net>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Userspace cp and ls utility
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen schrieb:
> Jan Dittmer wrote:
> 
>> Are there utilities for xfs which are able to ls and
>> cp from an _unmounted_ xfs volume? I fear that by
>> mounting the volume - even ro - I would lose even more
>> data.
>> Or can I achieve such an effect with other xfs related
>> utilities?
> 
> 
> Mounting ro should be fine - if you also mount with "norecovery" then 
> truly no IO should happen.  If you're really paranoid, find a utility to 
> mark the block device itself as read-only, then you've taken it out of 
> the filesystem's hands completely.

Thanks for the suggestions. Meanwhile I found the norecovery option
myself and got most of my data back. Strangely enough I had one top
directory missing on one mount attempt (only ro option) and it appeared
again on the next attempt (ro + norecovery).

> You could also try xfs_copy, it makes a copy of the filesystem and works 
> on the underlying device, with the filesystem unmounted.  There's a man 
> page for it.

Is there any difference to using dd when the destination is no xfs
filesystem? And if I read the description correctly it does not allow
to copy individual files?

Thanks,

Jan
