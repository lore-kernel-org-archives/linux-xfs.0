Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58963 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbdDLFiv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 01:38:51 -0400
Date: Wed, 12 Apr 2017 07:38:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: remove xfs_bmap_remap_alloc
Message-ID: <20170412053839.GA19900@lst.de>
References: <20170411111011.9437-1-hch@lst.de> <20170411111011.9437-6-hch@lst.de> <20170411230246.GG8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411230246.GG8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Apr 11, 2017 at 04:02:46PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 11, 2017 at 01:10:10PM +0200, Christoph Hellwig wrote:
> > The main thing that xfs_bmap_remap_alloc does is fixing the AGFL, similar
> > to what we do in the space allocator.  But the reflink code doesn't touch
> > the allocation btree unlike the normal space allocator, so we couldn't
> > care less about the state of the AGFL.
> > 
> > So remove xfs_bmap_remap_alloc and just handle the di_nblocks update in
> > the caller.
> 
> Looks ok, will go test.  By the way, what release were you targeting
> with this patchset?

The patches are against for-next.  Given how late we are in 4.11 I didn't
dare to send them for 4.11, although I'd like to backport it to 4.11-stable
and 4.9-stable eventually.

> AFAICT the only behavioral change is that we no
> longer ensure the AGFL in the remap step prior to (if necessary)
> ensuring the AGFL again in the subsequent rmap step.

Yes.
