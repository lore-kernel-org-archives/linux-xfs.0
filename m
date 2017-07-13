Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36730 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbdGMHQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 03:16:51 -0400
Date: Thu, 13 Jul 2017 00:16:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests failures with current kernel/xfsprogs/xfstests
Message-ID: <20170713071650.GA2433@infradead.org>
References: <20170712114433.GA2231@infradead.org>
 <20170712122900.l7ieyfmks5j74esg@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712122900.l7ieyfmks5j74esg@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Wed, Jul 12, 2017 at 02:29:00PM +0200, Carlos Maiolino wrote:
> On Wed, Jul 12, 2017 at 04:44:33AM -0700, Christoph Hellwig wrote:
> > I see a few failures with a (hopefully) uptodate setup.  I'm pretty
> > sure some of them have been around for a while, but I'd like to
> > figure out how to get to a clean slate.
> > 
> > This is a 4k fs on x86-64, with reflink enabled for the test and
> > scratch dev.
> 
> Have you by any chance noticed test 81 locking up? Every time I run a complete
> xfstests, it always get stuck on test 81.

Which test 81?  generic/081, xfs/081?  How does it lock up?

The generic one had some issues due to lvm doing stupid things in the
past, but I think we managed to paper over that.
