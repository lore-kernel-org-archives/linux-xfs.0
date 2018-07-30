Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbeG3Jsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 05:48:46 -0400
Date: Mon, 30 Jul 2018 01:14:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] xfs: fix cow_seq locking behavior
Message-ID: <20180730081456.GA25004@infradead.org>
References: <20180730055539.GT30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730055539.GT30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sun, Jul 29, 2018 at 10:55:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In Christoph Hellwig's patch "xfs: avoid COW fork extent lookups in
> writeback if the fork didn't change" (which has not yet graduated to
> for-next), we sample the COW fork sequence number without taking the
> ilock.  This is a little strange, since in general we always take it
> before accessing anything in a block mapping.  I think we get lucky in
> that the unlocking during actual cow fork changes will erect the
> necessary memory barriers (on x86 anyway) but let's not play fast and
> loose with breaking everyone else's model of how locking works.

What exaxtly do you want to protect here?  It's not like we have any
multiple fields we need to synchronize access to to.

And it's not like this is superficials - in addition to not providing
any actual synchronization this also means we have to take the ilock
for every page, which reduces a large part of the improvements in the
series.
