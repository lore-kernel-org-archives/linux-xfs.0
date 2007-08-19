Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 12:13:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JJDbbm008518
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 12:13:38 -0700
Message-ID: <46C89670.6050101@sandeen.net>
Date: Sun, 19 Aug 2007 14:13:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] make xfs stats Kconfigurable
References: <46C750C9.8040604@sandeen.net> <46C87C05.5040905@sandeen.net> <20070819191010.GC2929@infradead.org>
In-Reply-To: <20070819191010.GC2929@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sun, Aug 19, 2007 at 12:21:09PM -0500, Eric Sandeen wrote:
>> Oops, typo in Makefile (CONFIG_XFS_STAT vs _STATS).
>>
>> ----
>>
>>
>> xfs stats are already optional based on CONFIG_PROC_FS, and there
>> is already a (never-set) macro XFS_STATS_OFF which can turn them
>> off.  Making it a configurable option, if I turn them off I can
>> get a little stack savings on x86, gcc 4.1:
> 
> Why would we want to disable the statistics?

To save a little stack space.  :)  *shrug*

This one's not so critical.  FWIW, JFS has configurable stats, and I
think an upcoming jbd patch adds (config-optional) stats.

OTOH when are stats really used outside of sgi?  Though I suppose
occasionally they'd be useful in field debugging.

*shrug* this one may not be worth it; I won't be heartbroken if it
doesn't go in... it helps a tiny bit on the stack side.

-Eric

>> +	config XFS_STATS
> 
> Everywhere else the config statement is not indented, so it probably
> shouldn't be here either.
> 
