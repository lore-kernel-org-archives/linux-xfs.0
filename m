Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 212997CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 08:12:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 124AD8F8040
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 06:12:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id namETBY8Cq3RcjAy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Jan 2016 06:12:35 -0800 (PST)
Date: Fri, 29 Jan 2016 09:12:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160129141232.GA43184@bfoster.bfoster>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160128131656.GB14876@infradead.org>
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
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, darrick.wong@oracle.com

On Thu, Jan 28, 2016 at 05:16:56AM -0800, Christoph Hellwig wrote:
> Any chance to get a review for this?  It should really help
> with sorting out the buffered I/O COW code.
> 

I haven't taken a closer look at the patch yet. I was kind of waiting
for Dave to chime in because I'm a little confused over the back and
forth nature of dio/ioend completion lately.

My understanding is that the original requirement for ioends here was to
track the state necessary in order to defer (to wq) completions that had
to allocate transactions. Eventually, the deferred buffer state was
implemented and we no longer required an ioend for that, so we removed
the ioends here:

  2ba6623 xfs: don't allocate an ioend for direct I/O completions

Then just a couple months later, we merged the following to re-add the
ioend into the dio path:

  d5cc2e3f xfs: DIO needs an ioend for writes

I recall reviewing that one, but looking back afaict the ioend was used
simply to enable reuse of the ioend completion code. Now we have this
patch which presumably removes much of that code to eliminate the ioend
allocation overhead.

Neither this patch nor the previous has any technical reasoning for one
approach over the other in the commit logs, so afaics this appears to be
a matter of preference. Can we get some agreement (or discussion) on
what the right interface is to transfer information to dio completion?
E.g., is this allocation overhead noticeable? Is ioend usage problematic
for other reasons (such as copy-on-write)? Going back to the previous
patch, were there explicit reasons for using ioends aside from code
reuse? Note that the subsequent commit 6dfa1b67 ("xfs: handle DIO
overwrite EOF update completion correctly") does refer to some problems
not running dio completions in the right context... Dave?

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
