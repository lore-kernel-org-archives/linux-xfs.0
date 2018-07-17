Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51562 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731497AbeGQOdP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jul 2018 10:33:15 -0400
Date: Tue, 17 Jul 2018 16:02:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] iomap: add a page_done callback
Message-ID: <20180717140258.GA18365@lst.de>
References: <20180619164137.13720-1-hch@lst.de> <20180619164137.13720-6-hch@lst.de> <20180713025853.xugxx6zte3kvvqjy@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713025853.xugxx6zte3kvvqjy@merlin>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

On Thu, Jul 12, 2018 at 09:58:53PM -0500, Goldwyn Rodrigues wrote:
> Would it be better if we keep this function as a part of iomap_ops? I
> know gfs2 sets this conditionally, but we can always check the condition
> in the function assigned to page_done(). It would keep all the functions
> in one place.

It works at a very different level than the other iomap ops.  We had
extensive discussions on previous versions, it should all be on
the list.
