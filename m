Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 15:57:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6UMtjDW019996
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 15:55:56 -0700
Date: Mon, 31 Jul 2006 08:54:54 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
Message-ID: <20060731085454.A2280998@wobbly.melbourne.sgi.com>
References: <44CAE247.6020608@sandeen.net> <p73k65w41je.fsf@verdi.suse.de> <44CBDFC9.3040202@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44CBDFC9.3040202@sandeen.net>; from sandeen@sandeen.net on Sat, Jul 29, 2006 at 05:23:05PM -0500
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andi Kleen <ak@suse.de>, xfs@oss.sgi.com

On Sat, Jul 29, 2006 at 05:23:05PM -0500, Eric Sandeen wrote:
> Andi Kleen wrote:
> > Eric Sandeen <sandeen@sandeen.net> writes:
> > 
> >> This gets rid of some pointless macro defines... I had a version that
> >> lower-cased it all too but Nathan liked this better, and he's the man!
> >> :)
> > 
> > Shouted function names is not exactly Linux code style at least.
> > 
> > -Andi
> > 
> 
> well, *shrug* I have both versions, Nathan can take his pick :)
> 
> honestly, one-liner static inlines isn't exactly linux code style either, tho 
> the typechecking is nice.
> 
> I guess I shouldn't have said "Nathan liked this better" - I think he was being 
> pragmatic about the scope of the change.

Right, its more that we don't have a great track record at the moment
of not introducing regressions with these cleanups (including myself),
so I'm becoming more reluctant to do sweeping changes across the whole
codebase.  Smaller, specific, and obviously-correct things are less 
likely to introduce issues, so if we can achieve basically the same
thing while churning the code less, I'm all for it.

cheers.

-- 
Nathan
