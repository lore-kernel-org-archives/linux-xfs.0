Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3714F29DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 13:14:16 -0500 (CDT)
Date: Mon, 17 Jun 2013 13:14:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 18/27] xfs: split out xfs inode operations into
	separate file
Message-ID: <20130617181411.GE20932@sgi.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-19-git-send-email-david@fromorbit.com>
	<20130612140519.GB28988@infradead.org>
	<20130613011414.GB29338@dastard> <20130613080009.GL29338@dastard>
	<20130617155644.GA26043@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130617155644.GA26043@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey Christoph,

On Mon, Jun 17, 2013 at 08:56:44AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 13, 2013 at 06:00:09PM +1000, Dave Chinner wrote:
> > So what I really think needs to happen here first is similar to the
> > dir2 header file re-org. That is, a header file to define the
> > format, and a header file to define the in-kernel structures and
> > APIs....
> 
> Yes, I think we need to do this rather sooner than later.  In fact
> I'd feeling we need to tackle the whole header mess first before
> splitting the .c files.  Making sure the on-disk format is in one
> or just a few headers is the most important bit of that.
> 
> These days I'm actually of the opinion that we probably should be
> even more drastic about cutting the number of headers.  For the
> on disk format a xfs_format.h for all the regular on disk format and
> maybe and xfs_log_format.h should be more than enough.

I like the idea of having the entire on-disk format in just a few files.  It
would be a nice clean up.  I don't know if splitting the .c files needs to wait
on it though.

> But back to the _ops.c naming.  I really hate it and the best counter
> proposals I can come up with is to add a _common postfix to every file
> intended to be shared with userspace.

I don't understand what you don't like about the _ops.c naming... 

> Using a directly also would make
> sense, but for some reason Kbuild always had problems with modules built
> from multiple directories and I'm more than glad that we finally managed
> to get rid of the subdirectories.

but I really like the libxfs subdirectory idea.  Any idea if the Kbuild issues
are sorted out?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
