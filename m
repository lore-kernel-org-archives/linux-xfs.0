Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46896 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbeI1BAc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Sep 2018 21:00:32 -0400
Date: Thu, 27 Sep 2018 20:40:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/10] xfs: simplify the IOMAP_ZERO check in
 xfs_file_iomap_begin a bit
Message-ID: <20180927184055.GB14584@lst.de>
References: <20180917205354.15401-1-hch@lst.de> <20180917205354.15401-5-hch@lst.de> <20180926151711.GA899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926151711.GA899@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 11:17:12AM -0400, Brian Foster wrote:
> With this change, it looks like that scenario plays out the same until
> we get to imap_needs_alloc(), which returns true and brings us to do an
> allocation... I guess this changes a bit in the follow on patches, but
> the IOMAP_ZERO check that remains still makes the logic look funny.
> Should we ever get here with IOMAP_ZERO after the final patch to switch
> to separate ops?

Good point.  I thought we wouldn't ever get here, but until the next
patch that isn't actually true.  I'll reorder and add asserts.
