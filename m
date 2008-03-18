Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 20:34:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2I3YT9W016715
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 20:34:32 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10E2E6B3855
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 20:34:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id GmYGdH3LBZT1jxuO for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 20:34:59 -0700 (PDT)
Message-ID: <47DF3861.6020308@sandeen.net>
Date: Mon, 17 Mar 2008 22:34:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [RFC][PATCH 1/1] XFS: annotate all on-disk structures with __ondisk
References: <20080317202853.GC16500@josefsipek.net> <1205800745-9217-1-git-send-email-jeffpc@josefsipek.net>
In-Reply-To: <1205800745-9217-1-git-send-email-jeffpc@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, tes@sgi.com, dgc@sgi.com

Josef 'Jeff' Sipek wrote:
> Currently, the annotation just forces the structures to be packed, and
> 4-byte aligned.

Semantic nitpick: in my definition of "annotation" this is more than
just an annotation.

An "__ondisk" annotation, to me, would allow something like sparse to
verify properly laid out on-disk structures, but would not affect the
actual runtime code - I think that would be quite useful.  However, this
 change actually impacts the bytecode; it is a functional change.

So I really do understand what you're trying to do, despite my
protestations.  If there is some magical instruction to gcc which:

a) leaves all current "non-broken" ABIs and gcc implementations'
bytecode untouched (or at the very least, minimally/trivially modified), and

b) fixes all possible future ABIs so they will always have things
perfectly and properly aligned, again w/o undue molestation of the
resulting bytecode

then I could probably be convinced.  :)  But this seems like a tall
order, and would require much scrutiny.

I'm just very shy of a sweeping change like this, which has a material
impact on the most common architectures, and does not actually provide,
as far as I can see, any benefit to them - only risk.

And for now I'll shut up and let the sgi guys chime in eventually.  :)

-Eric

> Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> 
> ---
> This is just an RFC, and the alignment needs to be verified against the
> offsets within the pages read from disk, and more xfsqa runs on various
> architectures are needed. (I don't want to be responsible for something like
> the bitops regression on ppc!)
> 
> The .text segment shrinks on x86 and s390x, but grows in ia64 (3776 bytes ==
> 0.3%).
> 
>    text    data     bss     dec     hex filename
>  542054    3171    3084  548309   85dd5 xfs-x86-original.ko
>  542026    3171    3084  548281   85db9 xfs-x86-packed-aligned4.ko
> 1244057   70858    2480 1317395  141a13 xfs-ia64-original.ko
> 1247833   70858    2480 1321171  1428d3 xfs-ia64-packed-aligned4.ko
>  679901   19374    3112  702387   ab7b3 xfs-s390x-original.ko
>  679781   19374    3112  702267   ab73b xfs-s390x-packed-aligned4.ko
> 
> The approximate number of instructions effectively stays the same on x86
> (goes up by 2), s390x gets smaller (by 12 instructions), but ia64 bloats by
> 708 instructions (0.34%).
> 
> $ for x in *.ko; do objdump -d $x > `basename $x .ko`.dis ; done
> $ wc -l *.dis
>   141494 xfs-x86-original.dis
>   141496 xfs-x86-packed-aligned4.dis
>   208514 xfs-ia64-original.dis
>   209222 xfs-ia64-packed-aligned4.dis
>   121544 xfs-s390x-original.dis
>   121532 xfs-s390x-packed-aligned4.dis
> 
> I could try to compile things on a sparc64, mips, and x86_64, but that's for
> another day - and depending on where this thread will lead.
> 
> The patch keeps xfsqa happy on x86 - well, it dies in the 100-range, but I
> haven't had the time to check if that happens without this patch. Someone
> (not it!) should nurse xfsqa back to health :)
> 
> Jeff.
