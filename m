Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Apr 2008 00:07:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3I76ZYe005166
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 00:06:37 -0700
Message-ID: <4808488A.7010204@sgi.com>
Date: Fri, 18 Apr 2008 17:06:50 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: likely and unlikely was: Re: [PATCH] split xfs_ioc_xattr
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com>	<20080414032940.GA10579@lst.de> <ncclk3ejwam.fsf@sgi.com>	<20080416063712.GN108924158@sgi.com> <4805A589.7080906@sgi.com> <87ve2i5kbs.fsf@basil.nowhere.org>
In-Reply-To: <87ve2i5kbs.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Hi,

Thanks for the explanation, Andi.
So I guess the upshot is, that it can make a difference but
in many cases (where the perf difference isn't an issue)
it is probably not worth the ugliness.
And in performance cases, it would be best to test the hypothesis
with the unlikely profiler patch
=> it will be _unlikely_ we will bother ;-)
So I don't think I'll be bothering with them then unless
an issue comes up :)

--Tim

Andi Kleen wrote:
> Timothy Shimmin <tes@sgi.com> writes:
>> I'm still wondering if likely() and unlikely() should ever be used or not?
> 
> It's more than just branch predictors. unlikely also moves unlikely
> code out of line and keeps it out of the icache (the obvious
> drawback is that it makes the asm code much harder to read
> during debugging though -- that is why it used to be turned off 
> on x86-64) 
> 
> Then CPUs have two types of branch predictors: dynamic ones with
> history and static ones. Dynamic branch predictors tend to only work
> when the code has been recently executed several times and is still
> cached in their history buffers
> 
> Now the nature of the kernel is that it is a library serving much more
> code running in user space. This leads to often the user space
> clearing out the history buffers and caches so kernel code has to often
> deal with running cache cold and also branch predictor cold.
> 
> Then there are the static branch predictors in the CPU and unlikely()
> actually rearranges code to make them predict correctly.
> 
> Personally I would say the cache effects (moving code out of line) 
> are more important than the branch prediction because cache misses
> are more costly than branch misprediction.
> 
> That all said it might make sense in some really performance critical code,
> especially if it's a in a loop and the gcc static branch predictors
> (gcc has a large range of builtin heuristics that say e.g. (x < 0) or
> (x == NULL) is unlikely). Most code is probably not performance critical
> enough to justify the ugliness of the code annotations. And again
> for many situations the builtin predictors of gcc (and the CPU) do
> fine without help anyways.
> 
> Also if you add them you should at some point run with the unlikely
> profiler patch from mm just to make sure that your guesses about
> which paths are likely are actually correct. Humans are unfortunately
> often wrong on such guesses.
> 
> Ideally (but that might ask for too much for normal code writing) you
> would only add them to code where you have oprofile data for branch
> mispredictions or icache misses.
> 
> -Andi
>  
