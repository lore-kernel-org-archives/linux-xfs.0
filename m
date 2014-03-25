Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 572D97F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 13:13:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DD4E304070
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 11:13:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id RbErnrXfnS8nEvBc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 11:13:58 -0700 (PDT)
Date: Tue, 25 Mar 2014 11:13:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
Message-ID: <20140325181355.GA18707@infradead.org>
References: <532CFA12.4040104@redhat.com>
	<20140325125754.GA18691@bfoster.bfoster>
	<20140325131705.GB25392@infradead.org>
	<20140325180814.GF18572@destitution>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140325180814.GF18572@destitution>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 26, 2014 at 05:08:14AM +1100, Dave Chinner wrote:
> > I think this should unconditionally avoid the schedule, and while we're
> > at it we should kill _xfs_buf_ioend and opencode it here and at the
> > other callsite.
> 
> I thought we schduled here because we can issue IO from IO
> completion and so we need to requeue the IO completion rather than
> run it inline in the current IO completion that hasn't fully
> completed it's processing yet..

Actually we get a recursive callchain there from the I/O error handling.
I switched from always 0 to always 1 here in:

commit 08023d6dbe840dc4271805a9ea376fcbdee9f744
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Jul 2 06:00:04 2012 -0400

    xfs: prevent recursion in xfs_buf_iorequest

but I never got around fixing the root cause by cleaning up the way we
handle buffer I/O completions on a shut down filesystem.

So I guess Eric's fix is the best we can do for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
