Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54358 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732445AbeGKRYF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jul 2018 13:24:05 -0400
Date: Wed, 11 Jul 2018 19:20:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
        the fork didn't change
Message-ID: <20180711172032.GA3738@lst.de>
References: <20180710060528.4071-1-hch@lst.de> <20180710060528.4071-7-hch@lst.de> <20180711171551.GE32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180711171551.GE32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jul 11, 2018 at 10:15:51AM -0700, Darrick J. Wong wrote:
> Hmm, this troubles me slightly -- a short time ago you removed the "trim
> this data fork mapping to the first overlap with a cow fork mapping"
> (i.e. xfs_reflink_trim_irec_to_next_cow) behavior on the grounds that
> _writepage_map calls _map_blocks for every block in the page and so it
> was unnecessary.  But this seems to put that back.  Why is that?

Because back then map_blocks did a lookup in the COW fork everytime
(unless we are already on a COW mapping), and this patch wants to
only look it up when the COW fork actually changed, so the trim is
required now.
