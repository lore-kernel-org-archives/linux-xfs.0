Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 21:08:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2I48eY8020879
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 21:08:43 -0700
Date: Tue, 18 Mar 2008 15:09:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC][PATCH 1/1] XFS: annotate all on-disk structures with __ondisk
Message-ID: <20080318040903.GU155407@sgi.com>
References: <20080317202853.GC16500@josefsipek.net> <1205800745-9217-1-git-send-email-jeffpc@josefsipek.net> <47DF3861.6020308@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DF3861.6020308@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com, tes@sgi.com, dgc@sgi.com

On Mon, Mar 17, 2008 at 10:34:57PM -0500, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> > Currently, the annotation just forces the structures to be packed, and
> > 4-byte aligned.
> 
> Semantic nitpick: in my definition of "annotation" this is more than
> just an annotation.
> 
> An "__ondisk" annotation, to me, would allow something like sparse to
> verify properly laid out on-disk structures, but would not affect the
> actual runtime code - I think that would be quite useful.  However, this
>  change actually impacts the bytecode; it is a functional change.

Yup - this isn't "annotation"....

> So I really do understand what you're trying to do, despite my
> protestations.  If there is some magical instruction to gcc which:
> 
> a) leaves all current "non-broken" ABIs and gcc implementations'
> bytecode untouched (or at the very least, minimally/trivially modified), and
> 
> b) fixes all possible future ABIs so they will always have things
> perfectly and properly aligned, again w/o undue molestation of the
> resulting bytecode
> 
> then I could probably be convinced.  :)  But this seems like a tall
> order, and would require much scrutiny.
> 
> I'm just very shy of a sweeping change like this, which has a material
> impact on the most common architectures, and does not actually provide,
> as far as I can see, any benefit to them - only risk.
> 
> And for now I'll shut up and let the sgi guys chime in eventually.  :)

I think you iterated my concerns quite well, Eric.

The thing I want to see for any sort of change like this is output
off all the structures and their alignment before the change and their alignment
after the change. On all supported arches. 'pahole' is the tool you used
for that, wasn't it, Eric?

The only arch I would expect to see a change in the structures is on ARM; if
there's anything other than that there there's something wrong. This is going
to require a lot of validation to ensure that it is correct.....

Not to mention performance testing on ia64 given the added overhead in
critical paths.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
