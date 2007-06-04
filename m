Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 08:12:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l54FCFWt032306
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 08:12:17 -0700
Date: Tue, 5 Jun 2007 01:12:04 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: state of the testsuite
Message-ID: <20070604151204.GM86004887@sgi.com>
References: <20070604144441.GA9672@lst.de> <20070604150222.GL86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604150222.GL86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jun 05, 2007 at 01:02:22AM +1000, David Chinner wrote:
> On Mon, Jun 04, 2007 at 04:44:41PM +0200, Christoph Hellwig wrote:
> > When running the testsuite on Debian -testing I constanyly get the
> > 12 failing testcases (016 041 049 064 071 082 084 104 111 136 140 166).
> > Is this expected or are other people seeing better results?
> 
> What kernel+platform and what version of the tests?
> 
> Prior to 2.6.22-rc2, 016 and 144 are the only ones i saw failing
> regularly. 166 will fail until we get ->page_mkwrite
> sorted out (but passes in my tree).

looks like 082 and 088 have been failing for a while in the
automated QA as well but there's not a lot of other regular
failures....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
