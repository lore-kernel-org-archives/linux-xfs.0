Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 05:37:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7MCbCSr024139
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 05:37:13 -0700
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7B0F1A2F112
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 05:38:32 -0700 (PDT)
Received: from mail.ukfsn.org (mail.ukfsn.org [77.75.108.10]) by cuda.sgi.com with ESMTP id 002HP3cxoyzNaOw5 for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 05:38:32 -0700 (PDT)
Message-ID: <48AEB347.2000200@dgreaves.com>
Date: Fri, 22 Aug 2008 13:38:31 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
References: <48AD3921.5090709@dgreaves.com> <200808212026.17590.rjw@sisk.pl>
In-Reply-To: <200808212026.17590.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>

Rafael J. Wysocki wrote:
> [Adding CCs]
> 
> [The issue is probably present in 2.6.26 too]
> 
> On Thursday, 21 of August 2008, David Greaves wrote:
>> I have a desktop system that has started having problems booting up in the morning.
>>
>> It appears to just happen on more recent kernels.
>> I was having unrelated CDROM problems with a driver in an old kernel and decided
>> to test 2.6.27-rcX
>> The CDROM problem is fine now.
>>
>> However I started having problems on -rc1. I found that the machine was hanging
>> soon after booting and needed a reboot. After a reboot it would work fine for
>> the rest of the day.
>> When -rc3 came out I tried that and the problem still appears to be there.
>>
>> The normal process is now to boot to single-user, ctrl-alt-sysreq-SUB and then
>> reboot to multi-user. This isn't ideal.
>>
>>
>> If I cold boot 2.6.25.3 the problem doesn't occur.
>> I will try different versions over the next few days.

As promised, I tried 2.6.26.3 this morning and didn't have the problem. I will
try again a few times to confirm.
Nb Although the log had an XFS failure, I think the real issue is the segfaults;
I think XFS is a casuality, not a cause. Th problem almost always results in an
XFS crash at some point - but usually preceded by many segfaults in random binaries.

David
