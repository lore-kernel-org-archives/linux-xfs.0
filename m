Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F98D7FC5
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 03:39:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F35B5AC003
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 01:39:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Yabyodz2qwy2mSKq (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 01:39:07 -0700 (PDT)
Date: Thu, 17 Jul 2014 10:39:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] logprint: Fix printing of AGF buffers
Message-ID: <20140717083905.GB1649@quack.suse.cz>
References: <1405349100-19734-1-git-send-email-jack@suse.cz>
	<20140715101931.GC30363@infradead.org>
	<20140715140938.GA1733@quack.suse.cz>
	<20140715153922.GB5369@infradead.org>
	<20140716003851.GO22339@dastard>
	<20140716081105.GB29924@infradead.org>
	<20140716231725.GF4453@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140716231725.GF4453@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 17-07-14 09:17:25, Dave Chinner wrote:
> On Wed, Jul 16, 2014 at 01:11:05AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 16, 2014 at 10:38:51AM +1000, Dave Chinner wrote:
> > > I added this:
> > > 
> > > 	/*
> > > 	 * The addition of spare space and the non-logged CRC format
> > > 	 * fields to the AGF mean that the size that is logged is almost
> > > 	 * always going to be smaller than the structure itself. Hence
> > > 	 * we need to make sure that the buffer contains all the data we
> > > 	 * want to print rather than just check against the structure
> > > 	 * size.
> > > 	 */
> > > 
> > > Cheers,
> > 
> > I'd prefer to mention v4 filesystems as well:
> > 
> > 	/*
> > 	 * v4 filesystems only contain the fields before the uuid, and
> > 	 * even v5 filesystems don't usually log any field beneath it.
> > 	 */
> 
> It actually has nothing to do with v4 or v5 filesystems - it's to do
> with the fact that we do partial buffer logging but logprint is
> assuming the structure is always logging as a whole.  There's
> mistakes like this all through logprint - we whack them like this
> with a big stick (i.e. refuse to parse the structure) when they are
> found.
> 
> Did you notice the way that log_print_all.c handled these issues?
> For the AGI, it simply looks at the length of the region and sizes
> the output accordingly. And for the AGF, it just ignores the size of
> the region and assumes that it captured everything that is to be
> printed.
> 
> IOWs, we've played whack-a-mole on this again while ignoring the
> fundamental issues ithat still remain:
> 
> 	- that logprint has a lot of assumptions that simply aren't
> 	  true; and
> 	- that logprint simply does not handle split region
> 	  continuations like the kernel recovery code does.
> 
> Both of these things lead to having to handle these strange "out of
> space" cases in multiple places, and simply not handling them in
> places that actually need to.
> 
> These are just more reasons why logprint - as it says itself in a
> couple of comments - needs a complete rewrite.
  Yeah, I've noticed that logprint definitely doesn't handle all possible
cases and the code is ... well, organic :). OTOH it worked for me (except
for this bug) when I needed so for a debug tool like that it seemed good
enough. I don't feel like rewriting it from scratch (at least in near
future) but if someone can find time for that, it would be surely welcome.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
