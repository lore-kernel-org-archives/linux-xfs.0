Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53243 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfHFFe2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Aug 2019 01:34:28 -0400
Date: Tue, 6 Aug 2019 07:34:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] xfs: use a struct iomap in xfs_writepage_ctx
Message-ID: <20190806053425.GG13409@lst.de>
References: <156444951713.2682520.8109813555788585092.stgit@magnolia> <156444952349.2682520.6180005494290997205.stgit@magnolia> <20190805123826.6bv7jhcnw5ecnol7@orion.maiolino.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805123826.6bv7jhcnw5ecnol7@orion.maiolino.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com, Christoph Hellwig <hch@lst.de>, agruenba@redhat.com

On Mon, Aug 05, 2019 at 02:38:26PM +0200, Carlos Maiolino wrote:
> > -	 * Attempt to allocate whatever delalloc extent currently backs
> > -	 * offset_fsb and put the result into wpc->imap.  Allocate in a loop
> > -	 * because it may take several attempts to allocate real blocks for a
> > -	 * contiguous delalloc extent if free space is sufficiently fragmented.
> > +	 * Attempt to allocate whatever delalloc extent currently backs offset
> > +	 * and put the result into wpc->imap.  Allocate in a loop because it may
> 				     ^^^^
> 			And put the result into wpc->iomap?

Yes.  Darrick, can you fix this up when applying?
