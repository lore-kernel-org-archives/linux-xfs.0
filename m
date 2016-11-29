Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36553 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755028AbcK2MEb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 07:04:31 -0500
Date: Tue, 29 Nov 2016 04:04:05 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS on RBD deadlock
Message-ID: <20161129120405.GA11089@infradead.org>
References: <1480418228.2258.28.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480418228.2258.28.camel@pengutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <l.stach@pengutronix.de>
Cc: ceph-devel@vger.kernel.org, linux-xfs@vger.kernel.org, Michael Olbrich <m.olbrich@pengutronix.de>, =?iso-8859-1?Q?Bj=F6rn_L=E4ssig?= <b.laessig@pengutronix.de>

On Tue, Nov 29, 2016 at 12:17:08PM +0100, Lucas Stach wrote:
> 2. RBD worker is trying to handle the XFS block request, but the
> involved crypto code recurses into the XFS superblock shrinker, as it's
> trying to allocate memory with GFP_KERNEL in __crypto_alloc_tfm.

And that's where the issues start - crypto_alloc_skcipher and friends
are not intended to be called from the writeback path.
