Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 17:01:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0O11UeB019097
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 17:01:35 -0800
Date: Thu, 24 Jan 2008 12:02:09 +1100
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local> <op.t5c3ubfg3jf8g2@pc-bnaujok.melbourne.sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F02535973@pvn-3001.purevideo.local>
Message-ID: <op.t5es5vi83jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F02535973@pvn-3001.purevideo.local>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: xfs@oss.sgi.com

On Thu, 24 Jan 2008 04:24:17 +1100, Mark Magpayo <mmagpayo@purevideo.com>  
wrote:

>>
>> Was it stuck on Phase 6 all that time? With only 1GB of RAM (from your
>> meminfo output) and 18TB filesystem, Phases 3 and 4 will take a very
>> long time due to swapping.
>
> It's been stuck on Phase 6 since I came back to check on it on Monday.
>
>
>>
>> Phase 6 in your scenario should be relatively quick and light on
>> memory usage (500MB as reported in your other email).
>>
>> It is feasible it is deadlocked by trying to double-access a buffer,
>> or access a buffer that wasn't released. This is an unlikely scenario,
>> but it is possible.
>
> Could I break out of the process here?  Seems like most of the repair
> work has been done...  Then again, I imagine traversing the filesystem
> is a pretty important step.

Breaking repair is fine.

> Are there any more phases after this by the way?

Checking nlink counts in Phase 7 is the last.

I would run xfs_check to see if there are any errors remaining.

The other thing I can suggest is to run an older repair from the
2.8.x series (2.8.21) with the options "-M -o bhash=512". This
should finish.

Regards,
Barry.
