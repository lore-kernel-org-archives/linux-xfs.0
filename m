Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E461A29DF7
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 12:25:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE1DF304059
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 10:25:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id x2olVhoxL8YLlsEF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 10:25:12 -0700 (PDT)
Date: Tue, 25 Mar 2014 10:25:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
Message-ID: <20140325172508.GA4446@infradead.org>
References: <532CFA12.4040104@redhat.com>
	<20140325125754.GA18691@bfoster.bfoster>
	<20140325131705.GB25392@infradead.org>
	<5331A930.9030402@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5331A930.9030402@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 25, 2014 at 09:05:04AM -0700, Eric Sandeen wrote:
> >> Out of curiosity, is there any major reason we don't use 0 here
> >> unconditionally? Are we worried about I/O completing before we have a
> >> chance to decrement the reference?
> > 
> > I think this should unconditionally avoid the schedule, and while we're
> > at it we should kill _xfs_buf_ioend and opencode it here and at the
> > other callsite.
> 
> And then remove the flag from xfs_buf_ioend which is always 0 at that
> point ...

Is it?  xfs_buf_bio_end_io should stil be passing 1, the bio end_io
handler is the place we really need the workqueue for anyway.

> Yeah I have a patch to do that as well; I wanted to separate the
> bugfix from the more invasive cleanup, though - and I wanted to
> get the fix out for review sooner.

Sure, feel free to leave all the cleanups to another patch.

> But yeah, I was unsure about whether or not to schedule at all here.
> We come here from a lot of callsites and I'm honestly not sure what
> the implications are yet.

I think the the delayed completion is always wrong from the submission
path.  The error path is just a special case of a completion happening
before _xfs_buf_ioapply returns.  The combination of incredibly fast
hardware and bad preemption could cause the same bug you observed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
