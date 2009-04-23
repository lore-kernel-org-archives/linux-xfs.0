Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHS3nE017299 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:28:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C14E1CE20B4
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:28:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0hn4j7pD0bCu7s9h for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:28:00 -0700 (PDT)
Date: Thu, 23 Apr 2009 13:27:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add aio-dio-regress tests
Message-ID: <20090423172755.GA27780@infradead.org>
References: <49EFB75B.5030700@sandeen.net>
	<20090423171937.GE11391@infradead.org>
	<49F0A485.8060408@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49F0A485.8060408@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 23, 2009 at 12:25:25PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Wed, Apr 22, 2009 at 07:33:31PM -0500, Eric Sandeen wrote:
> >> Think it's worth pulling this in?
> >> Also not sure where to put it, under the top dir or under src ...
> >>
> >> Takes about 250s to run them all.  Could break out the longer
> >> one into a separate test so the rest could be in quick.
> > 
> > I would prefer to have a separate test for each of the programs.
> 
> Fine by me.  Any thoughts on if this should live under src/ or not?  I'm
> not sure why ltp/ doesn't, but I was just following that.

I don't think it matters too much.  The external dmapi tests are also
under src.  In doubt I would put it under src/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
