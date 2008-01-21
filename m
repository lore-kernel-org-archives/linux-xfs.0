Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 17:23:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L1N7U2024095
	for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 17:23:12 -0800
Date: Mon, 21 Jan 2008 12:23:50 +1100
Subject: Re: [REVIEW 0/2] Case insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com> <200801181905.05263.Martin@lichtvoll.de> <1200868214.9463.274.camel@edge.scott.net.au> <op.t489bqii3jf8g2@pc-bnaujok.melbourne.sgi.com> <1200877941.9463.292.camel@edge.scott.net.au>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t48950on3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <1200877941.9463.292.camel@edge.scott.net.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com

On Mon, 21 Jan 2008 12:12:21 +1100, Nathan Scott <nscott@aconex.com> wrote:

> On Mon, 2008-01-21 at 12:05 +1100, Barry Naujok wrote:
>>
>>
>>
>>
>> On Mon, 21 Jan 2008 09:30:14 +1100, Nathan Scott <nscott@aconex.com>
>> wrote:
>>
>> > On Fri, 2008-01-18 at 19:05 +0100, Martin Steigerwald wrote:
>> >
>> >> can switch between enable / disable case-insensitivity via a mount
>> >> option.
>> >
>> > No.
>>
>> Umm, that's a yes :)
>
> Ahem, you snipped the context precending that question!
> Surely you can't switch, unless the case-insensitive mkfs option was
> used initially...?  (unlike, say attr2, which can be enabled on-the-fly
> with a mount option, on existing attr1 filesystems).

You mkfs with unicode/utf8, ci is indeed a mount option which can be turned
on and off on the fly. True, you can't just do it on any existing
filesystem (except the undocumented/unrecommended xfs_db/xfs_repair  
method).

Barry.
