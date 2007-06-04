Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 08:13:57 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54FDqWt000912
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 08:13:54 -0700
Date: Mon, 4 Jun 2007 17:13:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: state of the testsuite
Message-ID: <20070604151351.GA11536@lst.de>
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

Current mainline on i386 (running in qemu)

> With 2.6.22-rc2, all the loopback based tests are failing
> because someone broke the loopback device so lots of tests
> fail because of that. The other tests I haven't seen fail
> for some time...

Ok, that should account for the loop stuff.  I already suspected
Ken's unlimited number of loop devices patch breaks something.
