Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DD327F86
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 19:30:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B3CD30404E
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 17:30:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dcNdmgp5MwjtXAca for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 17:30:14 -0700 (PDT)
Date: Fri, 18 Jul 2014 10:29:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] logprint: Fix printing of AGF buffers
Message-ID: <20140718002931.GI4453@dastard>
References: <1405349100-19734-1-git-send-email-jack@suse.cz>
	<20140715101931.GC30363@infradead.org>
	<20140715140938.GA1733@quack.suse.cz>
	<20140715153922.GB5369@infradead.org>
	<20140716003851.GO22339@dastard>
	<20140716081105.GB29924@infradead.org>
	<20140716231725.GF4453@dastard>
	<20140717083905.GB1649@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140717083905.GB1649@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jul 17, 2014 at 10:39:05AM +0200, Jan Kara wrote:
> On Thu 17-07-14 09:17:25, Dave Chinner wrote:
> > IOWs, we've played whack-a-mole on this again while ignoring the
> > fundamental issues ithat still remain:
> > 
> > 	- that logprint has a lot of assumptions that simply aren't
> > 	  true; and
> > 	- that logprint simply does not handle split region
> > 	  continuations like the kernel recovery code does.
> > 
> > Both of these things lead to having to handle these strange "out of
> > space" cases in multiple places, and simply not handling them in
> > places that actually need to.
> > 
> > These are just more reasons why logprint - as it says itself in a
> > couple of comments - needs a complete rewrite.
>   Yeah, I've noticed that logprint definitely doesn't handle all possible
> cases and the code is ... well, organic :).

That's a very polite way of putting it ;)

> OTOH it worked for me (except
> for this bug) when I needed so for a debug tool like that it seemed good
> enough. I don't feel like rewriting it from scratch (at least in near
> future) but if someone can find time for that, it would be surely welcome.

Right, that's effectively been the state of play for some time. It's
a useful tool that could do with some work to make it better, but
nobody has had the time to do that work because most of the time it
works fine...

If only there were some minions around looking to learn about XFS
log recovery....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
