Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 03:31:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJBVJt1030333
	for <linux-xfs@oss.sgi.com>; Wed, 19 Dec 2007 03:31:25 -0800
Date: Wed, 19 Dec 2007 22:31:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
Message-ID: <20071219113112.GD4612@sgi.com>
References: <20071218112804.GA3069@localhost.localdomain> <20071218122445.GJ4396912@sgi.com> <877ijckrco.fsf@free.fr> <20071218151946.GQ4396912@sgi.com> <20071219104544.GC4612@sgi.com> <87r6hjaq7p.fsf@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6hjaq7p.fsf@free.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Damien Wyart <damien.wyart@free.fr>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Wed, Dec 19, 2007 at 12:17:30PM +0100, Damien Wyart wrote:
> * David Chinner <dgc@sgi.com> [071219 11:45]:
> > Can someone pass me a brown paper bag, please?
> 
> My first impression on this bug was not so wrong, after all ;-)
> 
> > That also explains why we haven't seen it - it requires the user buffer to
> > fill on the first entry of a backing buffer and so it is largely dependent
> > on the pattern of name lengths, page size and filesystem block size
> > aligning just right to trigger the problem.
> 
> I guess I was lucky to trigger it quite easily...
> 
> > Can you test this patch, Damien?
> 
> Works fine, all the bad symptoms have disappeared and strace output is
> normal.
> 
> So you can add:
> 
> Tested-by: Damien Wyart <damien.wyart@free.fr>

Thanks for reporting the bug and testing the fix so quickly, Damien.
I'll give it some more QA before I push it, though.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
