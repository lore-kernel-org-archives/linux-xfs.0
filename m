Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeECWsM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 18:48:12 -0400
Date: Thu, 3 May 2018 15:48:11 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: Oops from linux-next 20180430
Message-ID: <20180503224811.GB30823@bombadil.infradead.org>
References: <20180503205703.GA27821@bombadil.infradead.org>
 <20180503223119.GF23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503223119.GF23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 04, 2018 at 08:31:20AM +1000, Dave Chinner wrote:
> On Thu, May 03, 2018 at 01:57:03PM -0700, Matthew Wilcox wrote:
> > I was running xfstests xfs/350 at the time.
> 
> It's a superblock fuzzing test. Described as:
> 
> tests/xfs/group:350 dangerous_fuzzers dangerous_scrub dangerous_repair
> 
> Are you trying to run xfstests as a regression test suite (i.e.
> check -g auto) , or as a fuzzer to find on-disk format parsing
> issues (check -g dangerous_fuzzers)?

I just invoked it as ./check.  I was looking to test the XArray code with
the config Ross gave me.  I didn't realise it would run 'dangerous' checks
by default.  I'll switch to -g auto.

