Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:48:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NKmNCw022358
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:48:24 -0700
Date: Wed, 23 Jul 2008 16:49:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080723204927.GB8421@infradead.org>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488692FB.1010101@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 12:10:03PM +1000, Mark Goodwin wrote:
> [getting off-topic for this thread, but anyway ..]
> This is already a big issue, obviously, and has been for some time.
>
> Internally, we're attempting to refine our patch acceptance processes,
> (e.g. gitify our internal dev tree and mirror it on oss so it's much
> easier to push back out to oss). But the QA overhead remains a stubborn
> problem. I think we're going to have to ask for QA tests (both regression
> and performance) to be written as part of the patch acceptance policy -
> under this policy, merely passing existing QA will not be sufficient.
> Comments?

For most patches that just clean things up or change internal
implementations adding new testcases doesn't make much sense.  The only
case is when you suspect/know the testcase don't cover this area enough.

What would be nice is if we'd add more testcases for user reported
regressions.

Btw, does anyone have recent gcov data for XFS?
