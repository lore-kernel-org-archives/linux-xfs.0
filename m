Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 15:59:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m22NweNf022066
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 15:58:44 -0800
Date: Mon, 03 Mar 2008 10:59:43 +1100
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net> <47C89303.7070902@thebarn.com> <47C8997A.9030804@sgi.com> <47C89B94.4060002@sandeen.net> <47C89F17.7040307@sandeen.net>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t7ex9td03jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47C89F17.7040307@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, markgw@sgi.com
Cc: Russell Cattelan <cattelan@thebarn.com>, nscott@aconex.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, 01 Mar 2008 11:11:03 +1100, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Eric Sandeen wrote:
>
>> maybe just 2 values, with the actual supported features (& features2)
>> values anded together?  Easy enough to parse in the code.
>>
>> i.e.
>>
>> # cat /proc/fs/xfs/features
>> 0xffffffff
>> 0x00000001
>
> hm, but of course mkfs should never be checking for anything in the
> first features slot; yesterday's kernels support all those flags but
> don't export anything.

Bzzzzt!

IRIX/ASCII case-insensitive mode (or OLDCI or "V1 CI" as I'm  calling it  
:) )
is in the first features slot - 0x4000

> wow, this is starting to feel as complex as ext4's flags ;)
>
> -Eric
>
>
