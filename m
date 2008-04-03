Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 23:42:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m336gAd3021249
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 23:42:10 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DDF28FADE9
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2008 23:42:46 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id ECsE6LeqMFolmMKb for <xfs@oss.sgi.com>; Wed, 02 Apr 2008 23:42:46 -0700 (PDT)
Date: Thu, 3 Apr 2008 08:46:08 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Patch] Cacheline align xlog_t
Message-ID: <20080403064608.GS29105@one.firstfloor.org>
References: <20080401231552.GV103491721@sgi.com> <47F3293C.6090708@sgi.com> <20080402054403.GF103491721@sgi.com> <87myocek4o.fsf@basil.nowhere.org> <20080402222347.GK103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402222347.GK103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 03, 2008 at 08:23:47AM +1000, David Chinner wrote:
> > For the dynamic allocation you would rather need to make sure it
> > starts at a cache line boundary explicitely because the allocator doesn't
> > know the alignment of the target type, otherwise your careful
> > padding might be useless.
> 
> Yup. Is there an allocator function gives us cacheline aligned
> allocation 

__get_free_pages() @) [ok not serious]

> (apart from a slab initialised with SLAB_HWCACHE_ALIGN)?

That too yes.

> There isn't one, right?

You can always align yourself with kmalloc (or any other arbitary 
size allocator) with the standard technique:
get L1_CACHE_BYTES-1 or possibly better cache_line_size() - 1 bytes
more and then align the pointer manually with ALIGN. Only tricky part
is that you have to undo the alignment before freeing.

-Andi
