Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 13:54:06 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1CLs2Dq030840
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2008 13:54:04 -0800
Message-ID: <47B2158F.2080305@sandeen.net>
Date: Tue, 12 Feb 2008 15:54:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs [_fsr] probs in 2.6.24.0
References: <47B0F00D.3060802@tlinx.org> <20080212085802.GA155407@sgi.com> <47B2094D.50406@tlinx.org> <47B20E84.6020707@sandeen.net> <47B21327.3080502@tlinx.org>
In-Reply-To: <47B21327.3080502@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <xfs@tlinx.org>
Cc: David Chinner <dgc@sgi.com>, Linux-Xfs <linux-xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>

Linda Walsh wrote:
> 
> Eric Sandeen wrote:
>> Linda Walsh wrote:
>>> David Chinner wrote:
>>>> Filesystem bugs rarely hang systems hard like that - more likely is
>>>> a hardware or driver problem. And neither of the lockdep reports
>>>> below are likely to be responsible for a system wide, no-response
>>>> hang.
>>> ---
>>> 	"Ish", the 32-bitter, has been the only hard-hanger.
>> 4k stacks?
> ----
> 	But but but...almost from the day they were introduced.  And
> these are more recent probs. Has stack usage increased for some reason,
> :-(.  I do have the option to detect stack-overflow turned on as well
> -- guess it doesn't work so well?

Resource requirements grow over time, film at 11? :)

the checker is a random thing, it checks only on interrupts; it won't
always hit.  you could try CONFIG_DEBUG_STACK_USAGE too, each thread
prints max stack used when it exits, to see if you're getting close on
normal usage.

Or just use 8k.

-Eric
