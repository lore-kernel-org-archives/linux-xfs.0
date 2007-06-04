Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 10:21:44 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54HLdWt025752
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 10:21:41 -0700
Date: Mon, 4 Jun 2007 19:21:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: state of the testsuite
Message-ID: <20070604172138.GA16879@lst.de>
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
> With 2.6.22-rc2, all the loopback based tests are failing
> because someone broke the loopback device so lots of tests
> fail because of that. The other tests I haven't seen fail
> for some time...

Backing out the dynamic loop device allocations gets me 049 back
to pass.
