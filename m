Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55819 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388736AbfBOG4i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Feb 2019 01:56:38 -0500
Date: Fri, 15 Feb 2019 07:56:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/10] xfs: move xfs_iomap_write_allocate to xfs_aops.c
Message-ID: <20190215065636.GA20146@lst.de>
References: <20190211125427.16577-1-hch@lst.de> <20190211125427.16577-9-hch@lst.de> <20190211152244.GG2804@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211152244.GG2804@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Feb 11, 2019 at 10:22:45AM -0500, Brian Foster wrote:
> It's an assert in xfs_bmapi_convert_delalloc() FWIW. That also doesn't
> account for the fact that this changes an explicit error into a debug
> mode notification. I'm not familiar with the history of this check and
> the whole xfs_alert_fsblock_zero() thing, but AFAICT it's the only thing
> that prevents an in-core record corruption from constructing a
> superblock overwrite in this path.

Ok, I'll change the earlier patch to return an error.

> Can we please fix this comment to explain what "what the caller expects"
> means? This could be as simple as appending "(i.e., the caller has
> already trimmed against overlapping COW fork blocks)" to the last
> sentence above.

Actually, I think the better idea is to just do the explicit trim
to cow_fsb in the caller, as that is a lot more obvious.

> > +	ASSERT(wpc->imap.br_startoff <= offset_fsb);
> > +	ASSERT(wpc->imap.br_startoff + wpc->imap.br_blockcount >= offset_fsb);
> 
> Looks like this one should be >.

Indeed.
