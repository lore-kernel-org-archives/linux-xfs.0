Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 14:53:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TLrj0O026510
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:53:45 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB74CB0AE30
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:53:45 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 0727v4XfD455pYhm for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:53:45 -0700 (PDT)
Date: Thu, 30 Oct 2008 08:53:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029215342.GL17077@disturbed>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029032601.GF4985@disturbed> <20081029091326.GB32545@infradead.org> <20081029214202.GH17077@disturbed> <20081029214503.GA8895@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029214503.GA8895@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 05:45:03PM -0400, Christoph Hellwig wrote:
> On Thu, Oct 30, 2008 at 08:42:02AM +1100, Dave Chinner wrote:
> > I'll do that as a separate patch - it's not really part of a "fix
> > error value inversion" bug fix....
> 
> Well it is kindof.  Because we'd call Linux library functions directly
> from the method we skip to places that need sign conversion and could
> possibly go wrong.  But if you want a separate patch that's fine with
> me too.

Well, the patch I posted to fix the sign problems covered the
xfs_flush_pages() and xfs_flushinval_pages() functions that we
returning negative errors to core code, and none of the core code
inverted that before returning it to functions that inverted it.
That's a general problem that affected truncate, direct I/O,
getbmap, etc, as well as fsync...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
