Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 08:02:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l54F2XWt028532
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 08:02:34 -0700
Date: Tue, 5 Jun 2007 01:02:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: state of the testsuite
Message-ID: <20070604150222.GL86004887@sgi.com>
References: <20070604144441.GA9672@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604144441.GA9672@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Jun 04, 2007 at 04:44:41PM +0200, Christoph Hellwig wrote:
> When running the testsuite on Debian -testing I constanyly get the
> 12 failing testcases (016 041 049 064 071 082 084 104 111 136 140 166).
> Is this expected or are other people seeing better results?

What kernel+platform and what version of the tests?

Prior to 2.6.22-rc2, 016 and 144 are the only ones i saw failing
regularly. 166 will fail until we get ->page_mkwrite
sorted out (but passes in my tree).

With 2.6.22-rc2, all the loopback based tests are failing
because someone broke the loopback device so lots of tests
fail because of that. The other tests I haven't seen fail
for some time...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
