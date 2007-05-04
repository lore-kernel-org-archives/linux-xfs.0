Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 06:25:53 -0700 (PDT)
Received: from smtp-ft5.fr.colt.net (smtp-ft5.fr.colt.net [213.41.78.197])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l44DPlfB025077
	for <xfs@oss.sgi.com>; Fri, 4 May 2007 06:25:49 -0700
Date: Fri, 4 May 2007 15:25:46 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070504152546.614374ac@harpe.intellique.com>
In-Reply-To: <20070504073344.GL32602149@melbourne.sgi.com>
References: <20070503164521.16efe075@harpe.intellique.com>
	<20070504005922.GC32602149@melbourne.sgi.com>
	<20070504090613.7c0f97d3@galadriel.home>
	<20070504073344.GL32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Le Fri, 4 May 2007 17:33:44 +1000
David Chinner <dgc@sgi.com> écrivait:

> Well, there's your problem. Stack overflows.  IMO, if you use a
> filesystem, you shouldn't use 4k stacks. ;)
> 
> If you remake you kernel with 8k stacks then your problems will
> most likely go away.

Well, I've double-checked the asm-i386/module.h, and it actually looks
like 4K stacks is NOT the default, so I must be using 8K, isn't it?

I've ran the same test on the same machine but WITHOUT software raid-0
(so write barriers are in use), and all went well, more than 3TB
written without a glitch. I still think there's something related to
the write barriers here. I'll try with another RAID controller, Adaptec
for instance, to get sure the 3ware driver isn't involved. I'll also try
again with an amd64 kernel.

I'd really like to sort this out...

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
