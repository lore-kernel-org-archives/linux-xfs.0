Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Feb 2008 16:02:09 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2101mkY004001
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 16:01:50 -0800
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60713634D38
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 16:02:16 -0800 (PST)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id lD91phA008s8r9rU for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 16:02:16 -0800 (PST)
Date: Fri, 29 Feb 2008 19:02:11 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
Message-ID: <20080301000211.GI3520@josefsipek.net>
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net> <47C89303.7070902@thebarn.com> <47C8997A.9030804@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C8997A.9030804@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, nscott@aconex.com, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Mar 01, 2008 at 10:47:06AM +1100, Mark Goodwin wrote:
> Russell Cattelan wrote:
>> Eric Sandeen wrote:
>>> Russell Cattelan wrote:
>>>>> Hmm, that still seems pretty soon to me.  I'd have thought you'd at
>>>>> least want to wait until most of the distributions (esp. SUSE for you
>>>>> guys) have released versions that have kernels sufficiently recent
>>>>> that the default mkfs will work.  Otherwise this will be a recurring
>>>>> problem.
>>>>>
>>>> I don't suppose there is an easy way to query xfs and find out if it
>>>> can support
>>>> the lazy SB option?
>>>
>>> I thought about that; xfs *could* stick someting in /proc/fs/xfs with
>>> supported features or somesuch.
>
> how about /proc/fs/xfs/features
> .. any format suggestions?

I'd say strings like:

lazy-count
attr2

Something that'd match the mkfs option strings closely.

This would make iterating over the features supported easy in a shell
script...

cat /proc/fs/xfs/features | while read feat ; do something $feat ; done

I get the feeling that this might be useful even if mkfs doesn't check it.

>>> But, the kernel you mkfs under isn't necessarily the one you're going to
>>> need to fall back to tomorrow, though...
>
> nor the one you just installed but haven't rebooted into yet

Right, if you know what you are doing, you can specify whatever options you
want by hand...this is about the default values.

Another issue is with portable media - I use XFS on external disks, and
until recently I couldn't redo them with lazy-count if I wanted to use it on
my laptop.

Josef 'Jeff' Sipek.

-- 
A CRAY is the only computer that runs an endless loop in just 4 hours...
