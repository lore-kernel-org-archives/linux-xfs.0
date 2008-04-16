Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Apr 2008 00:29:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3G7SoD2015282
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 00:28:51 -0700
Received: from smtp-out03.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 519FF826E9
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 00:29:28 -0700 (PDT)
Received: from smtp-out03.alice-dsl.net (smtp-out03.alice-dsl.net [88.44.63.5]) by cuda.sgi.com with ESMTP id aR3FtU3Eo13AsdzD for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 00:29:28 -0700 (PDT)
Subject: Re: [PATCH] split xfs_ioc_xattr
From: Andi Kleen <andi@firstfloor.org>
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com>
	<20080414032940.GA10579@lst.de> <ncclk3ejwam.fsf@sgi.com>
	<20080416063712.GN108924158@sgi.com> <4805A589.7080906@sgi.com>
Date: Wed, 16 Apr 2008 09:29:27 +0200
In-Reply-To: <4805A589.7080906@sgi.com> (Timothy Shimmin's message of "Wed, 16 Apr 2008 17:06:49 +1000")
Message-ID: <87ve2i5kbs.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Timothy Shimmin <tes@sgi.com> writes:
>
> I'm still wondering if likely() and unlikely() should ever be used or not?

It's more than just branch predictors. unlikely also moves unlikely
code out of line and keeps it out of the icache (the obvious
drawback is that it makes the asm code much harder to read
during debugging though -- that is why it used to be turned off 
on x86-64) 

Then CPUs have two types of branch predictors: dynamic ones with
history and static ones. Dynamic branch predictors tend to only work
when the code has been recently executed several times and is still
cached in their history buffers

Now the nature of the kernel is that it is a library serving much more
code running in user space. This leads to often the user space
clearing out the history buffers and caches so kernel code has to often
deal with running cache cold and also branch predictor cold.

Then there are the static branch predictors in the CPU and unlikely()
actually rearranges code to make them predict correctly.

Personally I would say the cache effects (moving code out of line) 
are more important than the branch prediction because cache misses
are more costly than branch misprediction.

That all said it might make sense in some really performance critical code,
especially if it's a in a loop and the gcc static branch predictors
(gcc has a large range of builtin heuristics that say e.g. (x < 0) or
(x == NULL) is unlikely). Most code is probably not performance critical
enough to justify the ugliness of the code annotations. And again
for many situations the builtin predictors of gcc (and the CPU) do
fine without help anyways.

Also if you add them you should at some point run with the unlikely
profiler patch from mm just to make sure that your guesses about
which paths are likely are actually correct. Humans are unfortunately
often wrong on such guesses.

Ideally (but that might ask for too much for normal code writing) you
would only add them to code where you have oprofile data for branch
mispredictions or icache misses.

-Andi
 
