Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46657 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbcI0SuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 14:50:22 -0400
Date: Tue, 27 Sep 2016 11:50:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 58/71] xfs: garbage collect old cowextsz reservations
Message-ID: <20160927185021.GA8623@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216829394.867.16281333542262043955.stgit@birch.djwong.org>
 <20160924194234.GA1878@infradead.org>
 <20160926215209.GE14092@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160926215209.GE14092@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 26, 2016 at 02:52:09PM -0700, Darrick J. Wong wrote:
> The two functions /could/ be merged but I'm hesitant to combine them
> because they run as different workqueue items.
> 
> Setting speculative_cow_prealloc_lifetime to a (much) higher value than
> speculative_prealloc_lifetime has been useful for combatting CoW
> fragmentation on VM hosts where the VMs experience bursty write
> behaviors and we can keep the utilization ratios low enough that we
> don't start to run out of space.  IOWs, it benefits us to keep the CoW
> fork reservations around for as long as we can unless we run out of
> blocks or hit inode reclaim.

Ok, so there is a good use case for it.  It just felt to me like
there was a little bit too much duplication, that's why I asked.
