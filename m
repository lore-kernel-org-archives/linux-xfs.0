Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53GxthH167045 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 11:59:55 -0500
Subject: Re: [PATCH 00/17] pending patches
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100531160727.842750532@bombadil.infradead.org>
References: <20100531160727.842750532@bombadil.infradead.org>
Date: Thu, 03 Jun 2010 12:01:46 -0500
Message-ID: <1275584506.2468.57.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, 2010-05-31 at 12:07 -0400, Christoph Hellwig wrote:
> Here's my list of pending patches.  Ordering them is getting a bit
> difficult as various patches that have been out of a while haven't
> been commited yet.  Note that some patches require Dave's
> 
> 	[PATCH] xfs: fix race in inode cluster freeing failing to stale inodes
> 
> applies first.  That patch is a clear candidate for something that
> should go to Linus ASAP IHMO.

I agree it should go into 2.6.35.  Last I saw on that one, Dave
said he was going to update it, so I was waiting for that.  I
now see it's available on his kernel.org tree so I can grab
that and get it in the pipeline to send to Linus soon.


I mentioned to you privately a few weeks ago that I had some concerns
about removing DMAPI support, and had promised to send a note out to
the list to that effect, but regretfully I never did that.

I would like to have a chance to submit an alternative to simply
removing that code.  I recognize it sits in the first part of your
patch series, and I will gladly do the work to rearrange them to
put it at the end, in order to give me some time to develop my
proposed change.

Basically what I'd like to do is update the DMAPI support code
so that it is much better isolated.  I would like to replace
the big ugly hunks that lie in common code paths with small
function calls, so that their footprint is minimal and not
distracting (along the lines of tracing calls).

I got a start on doing this, and had hoped to send the result
pretty soon after your initial posting of the patch, but that
work unfortunately got preempted by other more pressing stuff.
I wanted to provide actual code to help make the discussion
of the merits of removal versus cleanup more concrete.  I
now think I'll be able to put something together within the
next week or so.

I'll wait to hear back from you and others.  In the mean time
I'll make my way through the rest of the patch series.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
