Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35432 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbeEPQT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:19:58 -0400
Received: by mail-pf0-f193.google.com with SMTP id x9-v6so610263pfm.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 09:19:58 -0700 (PDT)
Date: Wed, 16 May 2018 09:19:55 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] iomap: don't allow holes in swapfiles
Message-ID: <20180516161955.GA14174@vader>
References: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
 <20180516155000.GC23858@magnolia>
 <20180516155146.GA8294@infradead.org>
 <20180516155638.GD23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516155638.GD23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Aleksei Besogonov <cyberax@amazon.com>

On Wed, May 16, 2018 at 08:56:38AM -0700, Darrick J. Wong wrote:
> On Wed, May 16, 2018 at 08:51:46AM -0700, Christoph Hellwig wrote:
> > On Wed, May 16, 2018 at 08:50:00AM -0700, Darrick J. Wong wrote:
> > > > Hey, Darrick, I noticed this while writing up a generic xfstest to test
> > > > that the Btrfs swap support patches don't allow a swapfile with holes.
> > > > It'd be nice if we were all consistent :) This is based on
> > > > xfs-linux/for-next. Feel free to fold it in to your patch or apply it
> > > > separately as you see fit. Thanks!
> > > 
> > > I sent a testcase of my own ("generic: test swapfile creation,
> > > activation, and deactivation") a while back; would you mind sending out
> > > yours so we can combine them into a single testcase?

Sure thing, I have a small pile of tests. I'm still working on some
Btrfs-specific ones, but I can send out the generic ones and we can
figure out how to merge them.

> > Wasn't the desire to support holes the rationale for the Aleksei
> > version of the iomap swapfile patch?
> 
> Ah, so it was.  FWIW I'm not sure why you'd /want/ a holey swapfile?

>From reading the old thread, it looks like Aleksei just wanted
fallocated swap files to work: "I've traced the problem to bmap(), used
in generic_swapfile_activate call, which returns 0 for blocks inside
holes created by fallocate". Are holes in that sense are different from
actual holes in the iomap sense?
