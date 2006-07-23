Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 08:35:02 -0700 (PDT)
Received: from ds666.l4x.org (mail.trixing.net [87.230.125.58])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6NFYoDW025595
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 08:34:51 -0700
Message-ID: <44C396FB.7050308@l4x.org>
Date: Sun, 23 Jul 2006 17:34:19 +0200
From: Jan Dittmer <jdi@l4x.org>
MIME-Version: 1.0
References: <44C0B0E4.7020403@l4x.org> <44C2EEC5.4020804@sandeen.net> <44C33080.3060108@l4x.org> <44C385DE.100@sandeen.net>
In-Reply-To: <44C385DE.100@sandeen.net>
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
>>> You could also try xfs_copy, it makes a copy of the filesystem and 
>>> works on the underlying device, with the filesystem unmounted.  
>>> There's a man page for it.
>>
>>
>> Is there any difference to using dd when the destination is no xfs
>> filesystem? And if I read the description correctly it does not allow
>> to copy individual files?
> 
> 
> xfs_copy knows about the xfs format, so it only copies what it needs 
> to.  dd will copy every bit on the source disk.  So, xfs_copy is more 
> efficient.  There is no option to copy individual files.
> 
> Depending on the problem with your original filesystem, perhaps xfs_copy 
> might not be the best choice.

Well I suffered from the 2.6.17 endian bug and had fun with dis- and re-
appearing folders upon xfs_repair and mount runs.
After all the 'only' thing I lost from my 600+gb volume are one or two
mailing list folders and most of my inbox (for which I've backups).
Seems to only affect folders which were open at the wrong moment.

Now I reformated the whole volume and restore the data from other
disks.

Jan
