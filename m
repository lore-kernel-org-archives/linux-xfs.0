Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59492 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdF1Qjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2017 12:39:36 -0400
Date: Wed, 28 Jun 2017 09:39:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 3b22408
Message-ID: <20170628163936.GA11468@infradead.org>
References: <20170628035019.GC4492@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170628035019.GC4492@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>

On Tue, Jun 27, 2017 at 08:50:19PM -0700, Darrick J. Wong wrote:
> I am well aware that Brian, Christoph, and Andreas have some fixes for
> log wrapping problems and a rewrite of SEEK_HOLE/DATA to use iomap and
> will spend the next day or two reviewing those patch sets; this is
> merely an interim rollup of everything else that I've collected for 4.13
> so far.

No problem.  Btw, the seek stuff could use some more reviews, and
after that we should probably pull the core and xfs bits into the
xfs tree.  IF/when ext4 gets a review we can decide how to feed
that, same for the gfs2 bits.
