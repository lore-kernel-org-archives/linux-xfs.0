Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46969 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdJUDUS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 23:20:18 -0400
Date: Fri, 20 Oct 2017 20:20:08 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
Message-ID: <20171021032008.GA27694@bombadil.infradead.org>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
 <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
 <20171020162933.GA26320@lst.de>
 <CAPcyv4jP0ws7dcBrXafS7ON+0_J1BTp_LCB6XB3od4d6db071A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jP0ws7dcBrXafS7ON+0_J1BTp_LCB6XB3od4d6db071A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>

On Fri, Oct 20, 2017 at 03:29:57PM -0700, Dan Williams wrote:
> Ok, I'd also like to kill DAX support in the brd driver. It's a source
> of complexity and maintenance burden for zero benefit. It's the only
> ->direct_access() implementation that sleeps and it's the only
> implementation where there is a non-linear relationship between
> sectors and pfns. Having a 1:1 sector to pfn relationship will help
> with the dma-extent-busy management since we don't need to keep
> calling into the driver to map pfns back to sectors once we know the
> pfn[0] sector[0] relationship.

But these are important things that other block devices may / will want.

For example, I think it's entirely sensible to support ->direct_access
for RAID-0.  Dell are looking at various different options for having
one pmemX device per DIMM and using RAID to lash them together.
->direct_access makes no sense for RAID-5 or RAID-1, but RAID-0 makes
sense to me.

Last time we tried to take sleeping out, there were grumblings from people
with network block devices who thought they'd want to bring pages in
across the network.  I'm a bit less sympathetic to this because I don't
know anyone actively working on it, but the RAID-0 case is something I
think we should care about.
