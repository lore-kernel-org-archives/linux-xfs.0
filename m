Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 07:00:20 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l57E0CWt025620
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 07:00:15 -0700
Message-ID: <46680F69.60105@dgreaves.com>
Date: Thu, 07 Jun 2007 15:00:09 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <46608E3F.4060201@dgreaves.com> <46609FAD.7010203@dgreaves.com>	 <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com>	 <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>	 <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>	 <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com>	 <4667DE2D.6050903@dgreaves.com> <e9e943910706070645p29519138i7e76b3a9649d387@mail.gmail.com>
In-Reply-To: <e9e943910706070645p29519138i7e76b3a9649d387@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Duane Griffin <duaneg@dghda.com>
Cc: Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Duane Griffin wrote:
> On 07/06/07, David Greaves <david@dgreaves.com> wrote:
>> > How hard does the machine freeze?  Can you use sysrq?  If so, please
>> > dump sysrq-t.
>> I suspect there is a problem writing to the consoles...
>>
>> I recompiled (rc4+patch) with sysrq support, suspended, resumed and tried
>> sysrq-t but got no output.
>>
>> I *can* change VTs and see the various login prompts, bitmap messages 
>> and the
>> console messages. Caps/Num lock lights work.
>>
>> Fearing incompetence I tried sysrq-s sysrq-u sysrq-b and got a reboot 
>> so sysrq
>> is OK.
> 
> Try sysrq-9 before the sysrq-t. Probably the messages are not being
> printed to console with your default output level.

Good idea :)
Didn't work :(

Cheers

David
