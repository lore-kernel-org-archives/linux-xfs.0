Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 07:55:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l44EtXfB019895
	for <xfs@oss.sgi.com>; Fri, 4 May 2007 07:55:35 -0700
Message-ID: <463B4962.70904@sandeen.net>
Date: Fri, 04 May 2007 09:55:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS crash on linux raid
References: <20070503164521.16efe075@harpe.intellique.com>	<20070504005922.GC32602149@melbourne.sgi.com>	<20070504090613.7c0f97d3@galadriel.home>	<20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com>
In-Reply-To: <20070504152546.614374ac@harpe.intellique.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Emmanuel Florac wrote:
> Le Fri, 4 May 2007 17:33:44 +1000
> David Chinner <dgc@sgi.com> écrivait:
> 
>> Well, there's your problem. Stack overflows.  IMO, if you use a
>> filesystem, you shouldn't use 4k stacks. ;)
>>
>> If you remake you kernel with 8k stacks then your problems will
>> most likely go away.
> 
> Well, I've double-checked the asm-i386/module.h, and it actually looks
> like 4K stacks is NOT the default, so I must be using 8K, isn't it?

Depends on how you config'd it, just look at the .config you built with, 
and search for CONFIG_4KSTACKS

On Fedora at least (and I can't remember - I don't think this is a 
fedora-ism...) you can do "modinfo" on some module, and see:

vermagic:       2.6.21 SMP mod_unload 686 4KSTACKS

-Eric
