Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25030 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754231AbdHYQ4R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 12:56:17 -0400
Date: Fri, 25 Aug 2017 19:56:12 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v6 3/5] mm: introduce mmap3 for safely defining new mmap
 flags
Message-ID: <20170825165612.xsv3akgjk6tajcpk@black.fi.intel.com>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165546.GA3121@infradead.org>
 <CAPcyv4iN0QpUSgOUvisnNQsiV1Pp=4dh7CwAV8FFj=_rFU=aug@mail.gmail.com>
 <20170825130011.GA30072@infradead.org>
 <20170825155803.4km7wttzadfqw2vb@node.shutemov.name>
 <20170825160236.GA2561@infradead.org>
 <20170825161607.6v6beg4zjktllt2z@node.shutemov.name>
 <4de21e8d-5e10-ec40-c731-0c079953cf48@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4de21e8d-5e10-ec40-c731-0c079953cf48@gmx.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Helge Deller <deller@gmx.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-parisc@vger.kernel.org

On Fri, Aug 25, 2017 at 04:19:19PM +0000, Helge Deller wrote:
> On 25.08.2017 18:16, Kirill A. Shutemov wrote:
> > On Fri, Aug 25, 2017 at 09:02:36AM -0700, Christoph Hellwig wrote:
> >> On Fri, Aug 25, 2017 at 06:58:03PM +0300, Kirill A. Shutemov wrote:
> >>> Not all archs are ready for this:
> >>>
> >>> arch/parisc/include/uapi/asm/mman.h:#define MAP_TYPE    0x03            /* Mask for type of mapping */
> >>> arch/parisc/include/uapi/asm/mman.h:#define MAP_FIXED   0x04            /* Interpret addr exactly */
> >>
> >> I'd be happy to say that we should not care about parisc for
> >> persistent memory.  We'll just have to find a way to exclude
> >> parisc without making life too ugly.
> > 
> > I don't think creapling mmap() interface for one arch is the right way to
> > go. I think the interface should be universal.
> > 
> > I may imagine MAP_DIRECT can be useful not only for persistent memory.
> > For tmpfs instead of mlock()?
> 
> On parisc we have
> #define MAP_SHARED      0x01            /* Share changes */
> #define MAP_PRIVATE     0x02            /* Changes are private */
> #define MAP_TYPE        0x03            /* Mask for type of mapping */
> #define MAP_FIXED       0x04            /* Interpret addr exactly */
> #define MAP_ANONYMOUS   0x10            /* don't use a file */
> 
> So, if you need a MAP_DIRECT, wouldn't e.g.
> #define MAP_DIRECT      0x08
> be possible (for parisc, and others 0x04).
> And if MAP_TYPE needs to include this flag on parisc:
> #define MAP_TYPE        (0x03 | 0x08)  /* Mask for type of mapping */

I guess it's better to re-define MAP_TYPE as 0x3 everywhere and make
MAP_DIRECT a normal flag. It's not new type of mapping anyway.

-- 
 Kirill A. Shutemov
