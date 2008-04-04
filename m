Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 18:01:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3411eQE013308
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 18:01:43 -0700
Message-ID: <47F57E0E.7010700@sgi.com>
Date: Fri, 04 Apr 2008 12:02:06 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [Patch] Cacheline align xlog_t
References: <20080401231552.GV103491721@sgi.com> <47F3293C.6090708@sgi.com> <20080402054403.GF103491721@sgi.com> <87myocek4o.fsf@basil.nowhere.org> <20080402222347.GK103491721@sgi.com> <20080403064608.GS29105@one.firstfloor.org>
In-Reply-To: <20080403064608.GS29105@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Andi Kleen wrote:
> On Thu, Apr 03, 2008 at 08:23:47AM +1000, David Chinner wrote:
>>> For the dynamic allocation you would rather need to make sure it
>>> starts at a cache line boundary explicitely because the allocator doesn't
>>> know the alignment of the target type, otherwise your careful
>>> padding might be useless.
> 
>> There isn't one, right?
> 
> You can always align yourself with kmalloc (or any other arbitary 
> size allocator) with the standard technique:
> get L1_CACHE_BYTES-1 or possibly better cache_line_size() - 1 bytes
> more and then align the pointer manually with ALIGN. Only tricky part
> is that you have to undo the alignment before freeing.
> 
Yeah, how do you know how much was offset for the alignment
to go back for the freeing. I guess you could also keep the original pointer
or the offset handy (a pain). Or can the allocator help out?

--Tim
