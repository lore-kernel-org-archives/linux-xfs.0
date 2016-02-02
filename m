Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F382B7CB9
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 09:31:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80768AC004
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 07:31:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EhJxqz5j7b75vaPK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 07:31:20 -0800 (PST)
Date: Tue, 2 Feb 2016 10:31:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160202153117.GB1853@bfoster.bfoster>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160129141232.GA43184@bfoster.bfoster>
	<20160202112046.GB28777@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160202112046.GB28777@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, darrick.wong@oracle.com, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 12:20:46PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 29, 2016 at 09:12:33AM -0500, Brian Foster wrote:
> > My understanding is that the original requirement for ioends here was to
> > track the state necessary in order to defer (to wq) completions that had
> > to allocate transactions. Eventually, the deferred buffer state was
> > implemented and we no longer required an ioend for that, so we removed
> > the ioends here:
> > 
> >   2ba6623 xfs: don't allocate an ioend for direct I/O completions
> > 
> > Then just a couple months later, we merged the following to re-add the
> > ioend into the dio path:
> > 
> >   d5cc2e3f xfs: DIO needs an ioend for writes
> 
> And I complained about that one!  I didn't have time to provide a full
> analysis and the patches around this one were criticial enough.  But this
> patch has the analysis on why ioends are not needed and bad which should
> have been the full review back then.  Note that this new version is
> better than the old ioend removal as it does not just use the private
> data as a boolean, but as a bitmask so that additional information
> such as the COW status can be communicated.
> 

FWIW, I don't see any such review comments against the three versions of
the "DIO needs an ioend for writes" patch I have in my mailbox, but I
easily could have missed something..? But if there wasn't time, then
fair enough.

I'm just looking for context. I don't have much of an opinion on which
approach is used here. If it simplifies COW, then that seems good enough
reason to me to take this approach. I'm pointing this out more because
this code seems to have been rewritten the last couple of times we
needed to fix something, which makes backports particularly annoying.
The two patches above were associated with a broader enhancement and a
bug fix (respectively) as a sort of justification, whereas this post had
a much more vague purpose from what I could tell, and therefore why I at
least hadn't taken the time to review it.

If COW is the primary motivator, perhaps we can bundle it with that
work?

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
