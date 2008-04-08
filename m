Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 21:47:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m384kqJg004947
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 21:46:56 -0700
Date: Tue, 8 Apr 2008 14:47:27 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] xfsqa 185 - remove uninitialised variables in golden output.
Message-ID: <20080408044727.GV108924158@sgi.com>
References: <20080408014023.GO108924158@sgi.com> <nccr6dhhs7w.fsf@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nccr6dhhs7w.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 08, 2008 at 02:43:15PM +1000, Niv Sardi wrote:
> David Chinner <dgc@sgi.com> writes:
> 
> > Kill the output of uninitialised values when punching a hole.
> > This prevents the test from passing on just about everything.
> >
> > Signed-off-by: Dave Chinner <dgc@sgi.com>
> 
> Thanks dave, I've been meaning to do that for a long time, we might want
> to kill the sid output too when it's not specified on command line (can
> that change ? I've always seen it as 0).

no idea. You can remove it as a separate patch if it is a problem. I'm
going to check this one in now ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
