Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 17:21:31 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6V0KnDW001849
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 17:20:59 -0700
Received: from omx2.sgi.com ([198.149.32.25])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6UNHmnx006498
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 18:17:48 -0500
Message-ID: <44CD3DF2.1010108@melbourne.sgi.com>
Date: Mon, 31 Jul 2006 09:17:06 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
References: <44CAE247.6020608@sandeen.net> <p73k65w41je.fsf@verdi.suse.de> <44CBDFC9.3040202@sandeen.net> <20060731085454.A2280998@wobbly.melbourne.sgi.com>
In-Reply-To: <20060731085454.A2280998@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Andi Kleen <ak@suse.de>, xfs@oss.sgi.com



Nathan Scott wrote:
> On Sat, Jul 29, 2006 at 05:23:05PM -0500, Eric Sandeen wrote:
>> Andi Kleen wrote:
>>> Eric Sandeen <sandeen@sandeen.net> writes:
>>>
>>>> This gets rid of some pointless macro defines... I had a version that
>>>> lower-cased it all too but Nathan liked this better, and he's the man!
>>>> :)
>>> Shouted function names is not exactly Linux code style at least.
>>>
>>> -Andi
>>>
>> well, *shrug* I have both versions, Nathan can take his pick :)
>>
>> honestly, one-liner static inlines isn't exactly linux code style either, tho 
>> the typechecking is nice.
>>
>> I guess I shouldn't have said "Nathan liked this better" - I think he was being 
>> pragmatic about the scope of the change.
> 
> Right, its more that we don't have a great track record at the moment
> of not introducing regressions with these cleanups (including myself),
> so I'm becoming more reluctant to do sweeping changes across the whole
> codebase.  Smaller, specific, and obviously-correct things are less 
> likely to introduce issues, so if we can achieve basically the same
> thing while churning the code less, I'm all for it.
> 

Sam on his previous project had to do significant cleanup/macro
changes and wrote some tools to help him do post-preprocessor
comparisons to really look at what had changed. I'm not sure how
generic these tools are, but worth considering.

David
