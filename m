Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51971 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdEBHu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 03:50:27 -0400
Date: Tue, 2 May 2017 00:50:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: handle large CoW remapping requests
Message-ID: <20170502075021.GA7916@infradead.org>
References: <20170427212754.GB19158@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170427212754.GB19158@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, Apr 27, 2017 at 02:27:54PM -0700, Darrick J. Wong wrote:
> XFS transactions are constrained both by space and block reservation
> limits and the fact that we have to avoid doing 64-bit divisions.  This
> means that we can't remap more than 2^32 blocks at a time.  However,
> file logical blocks are 64-bit in size, so if we encounter a huge remap
> request we have to break it up into smaller pieces.

But where would we get that huge remap request from?  We already did the
BUILD_BUG_ON for the max read/write size at least.  Also the remaps
would now not be atomic, which would be a problem for my O_ATOMIC
implementation at least.
