Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 15:54:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1ONsCMJ002564
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 15:54:16 -0800
Date: Mon, 25 Feb 2008 10:55:11 +1100
Subject: Re: [REVIEW] Add lazy-counter conversion to xfs_repair
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t6wyesz53jf8g2@pc-bnaujok.melbourne.sgi.com> <47BF0859.6020707@sandeen.net>
Message-ID: <op.t61zd9f03jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47BF0859.6020707@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, 23 Feb 2008 04:37:29 +1100, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Barry Naujok wrote:
>> In response to the thread "Differences in mkfs.xfs and xfs_info  
>> output.",
>> xfs_repair has been improved to allow version changes/conversion of
>> filesystems.
>>
>> So, this patch introduces the first in an ongoing series of in-place
>> filesystem version changes with xfs_repair and the "-c" (convert)  
>> option.
>>
>> To turn on/off the lazy-superblock feature, run the following xfs_repair
>> commmand on your filesystem:
>>
>> # xfs_repair -c lazycount=[0|1] <device>
>
> How about adding this to xfs_admin as well, since some flag changes are
> already in there?

Yep, I can do that, it would be:

  -c for disabling and +c for enabling lazy counters.

> i.e. xfs_admin -<something... l and L are taken> could invoke xfs_repair
> -c lazycount ...?
>
> It just strikes me as a tad confusing that to change v2 logs or
> unwritten extent support, you use xfs_admin, and to change lazy sb
> counters, you must run repair...
>
> (I understand that repair must be run post-change, but a common tool to
> invoke all feature changes seems good to me)
>
> -Eric
