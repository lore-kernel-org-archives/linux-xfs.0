Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 16:24:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9GNNmaG011100
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 16:23:50 -0700
Date: Tue, 17 Oct 2006 09:22:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <20061016232250.GM11034@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net> <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local> <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4533FAEA.2080500@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Mon, Oct 16, 2006 at 04:34:34PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Timothy Shimmin wrote:
> >> Okay, started looking :-)
> 
> One other thing, based on the bug on osdl today, some of these larger
> newly-static functions should probably be marked noinline to keep gcc
> from doing things we don't want it to...

<grumble>

This is not an obvious compiler hint (compared to, say, likely()) as
the functions gcc automatically inlines changes according to
compiler version, optimisation level and platform. Hence adding
noinline notation will be like playing whack-a-mole and I doubt it
will be consistently used or maintained moving forward. It's the
wrong solution, IMO.

I think we should change the definition of STATIC so we don't have
to poison the code to work around some stupid compiler behaviour.
That is, unless we specifically say "inline" for static functions,
we really mean "noinline".

This will also make debugging easier because we won't get stack
traces that are apparently missing functions and all the associated
pain that this can cause.

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
