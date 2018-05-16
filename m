Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbeEPPvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 11:51:51 -0400
Date: Wed, 16 May 2018 08:51:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iomap: don't allow holes in swapfiles
Message-ID: <20180516155146.GA8294@infradead.org>
References: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
 <20180516155000.GC23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516155000.GC23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Aleksei Besogonov <cyberax@amazon.com>

On Wed, May 16, 2018 at 08:50:00AM -0700, Darrick J. Wong wrote:
> > Hey, Darrick, I noticed this while writing up a generic xfstest to test
> > that the Btrfs swap support patches don't allow a swapfile with holes.
> > It'd be nice if we were all consistent :) This is based on
> > xfs-linux/for-next. Feel free to fold it in to your patch or apply it
> > separately as you see fit. Thanks!
> 
> I sent a testcase of my own ("generic: test swapfile creation,
> activation, and deactivation") a while back; would you mind sending out
> yours so we can combine them into a single testcase?

Wasn't the desire to support holes the rationale for the Aleksei
version of the iomap swapfile patch?
