Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 01:28:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m328S4cb002118
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 01:28:05 -0700
Received: from smtp-out03.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 203748EB221
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2008 01:28:40 -0700 (PDT)
Received: from smtp-out03.alice-dsl.net (smtp-out03.alice-dsl.net [88.44.63.5]) by cuda.sgi.com with ESMTP id au9jcMNyrAm4sE0g for <xfs@oss.sgi.com>; Wed, 02 Apr 2008 01:28:40 -0700 (PDT)
Subject: Re: [Patch] Cacheline align xlog_t
References: <20080401231552.GV103491721@sgi.com> <47F3293C.6090708@sgi.com>
	<20080402054403.GF103491721@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Apr 2008 10:28:07 +0200
In-Reply-To: <20080402054403.GF103491721@sgi.com>
Message-ID: <87myocek4o.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner <dgc@sgi.com> writes:
> 
> This just means that the start of the structure is cacheline
> aligned.  I don't think the internal alignment commands force the
> entire structure to be cacheline aligned, merely pad the struture
> internally. In that case, even though the specific internal parts of
> the structure are on separate cache lines, there's no guarantee that
> all the related members are on the same cacheline. Hence I'm
> explicitly stating the exact alignment I want for the structure....

Isn't the structure dynamically allocated anyways? 
The full type alignment really only matters for statics/globals
where the linker can handle it.

For the dynamic allocation you would rather need to make sure it
starts at a cache line boundary explicitely because the allocator doesn't
know the alignment of the target type, otherwise your careful
padding might be useless.

-Andi
