Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 07:21:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6NELkDW012442
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 07:21:46 -0700
Message-ID: <44C385DE.100@sandeen.net>
Date: Sun, 23 Jul 2006 09:21:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Userspace cp and ls utility
References: <44C0B0E4.7020403@l4x.org> <44C2EEC5.4020804@sandeen.net> <44C33080.3060108@l4x.org>
In-Reply-To: <44C33080.3060108@l4x.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Dittmer <jdi@l4x.org>
Cc: xfs@oss.sgi.com

Jan Dittmer wrote:
>> You could also try xfs_copy, it makes a copy of the filesystem and 
>> works on the underlying device, with the filesystem unmounted.  
>> There's a man page for it.
> 
> Is there any difference to using dd when the destination is no xfs
> filesystem? And if I read the description correctly it does not allow
> to copy individual files?

xfs_copy knows about the xfs format, so it only copies what it needs to.  dd 
will copy every bit on the source disk.  So, xfs_copy is more efficient.  There 
is no option to copy individual files.

Depending on the problem with your original filesystem, perhaps xfs_copy might 
not be the best choice.

-Eric
