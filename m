Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751266AbdJWKoh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 06:44:37 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9NAiVIU077387
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 06:44:37 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dsayhj51k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 06:44:36 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <schwidefsky@de.ibm.com>;
        Mon, 23 Oct 2017 11:44:34 +0100
Date: Mon, 23 Oct 2017 12:44:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
In-Reply-To: <CAPcyv4hqiV6oHMgFik3MBTw5SJ6hcq4RzngPn2Xtp9kAv1E+Ow@mail.gmail.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
        <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
        <20171020075735.GA14378@lst.de>
        <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
        <20171020162933.GA26320@lst.de>
        <20171023071835.67ee5210@mschwideX1>
        <CAPcyv4hqiV6oHMgFik3MBTw5SJ6hcq4RzngPn2Xtp9kAv1E+Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Message-Id: <20171023124427.10d15ee3@mschwideX1>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>

On Mon, 23 Oct 2017 01:55:20 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 22, 2017 at 10:18 PM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> > On Fri, 20 Oct 2017 18:29:33 +0200
> > Christoph Hellwig <hch@lst.de> wrote:
> >  
> >> On Fri, Oct 20, 2017 at 08:23:02AM -0700, Dan Williams wrote:  
> >> > Yes, however it seems these drivers / platforms have been living with
> >> > the lack of struct page for a long time. So they either don't use DAX,
> >> > or they have a constrained use case that never triggers
> >> > get_user_pages(). If it is the latter then they could introduce a new
> >> > configuration option that bypasses the pfn_t_devmap() check in
> >> > bdev_dax_supported() and fix up the get_user_pages() paths to fail.
> >> > So, I'd like to understand how these drivers have been using DAX
> >> > support without struct page to see if we need a workaround or we can
> >> > go ahead delete this support. If the usage is limited to
> >> > execute-in-place perhaps we can do a constrained ->direct_access() for
> >> > just that case.  
> >>
> >> For axonram I doubt anyone is using it any more - it was a very for
> >> the IBM Cell blades, which were produceѕ in a rather limited number.
> >> And Cell basically seems to be dead as far as I can tell.
> >>
> >> For S/390 Martin might be able to help out what the status of xpram
> >> in general and DAX support in particular is.  
> >
> > The goes back to the time where DAX was called XIP. The initial design
> > point has been *not* to have struct pages for a large read-only memory
> > area. There is a block device driver for z/VM that maps a DCSS segment
> > somewhere in memore (no struct page!) with e.g. the complete /usr
> > filesystem. The xpram driver is a different beast and has nothing to
> > do with XIP/DAX.
> >
> > Now, if any there are very few users of the dcssblk driver out there.
> > The idea to save a few megabyte for /usr never really took of.
> >
> > We have to look at our get_user_pages() implementation to see how hard
> > it would be to make it fail if the target address is for an area without
> > struct pages.  
> 
> For read-only memory I think we can enable a subset of DAX, and
> explicitly turn off the paths that require get_user_pages(). However,
> I wonder if anyone has tested DAX with dcssblk because fork() requires
> get_user_pages()?
 
I did not test it recently, someone else might have. Gerald?

Looking at the code I see this in the s390 version of gup_pte_range:

        mask = (write ? _PAGE_PROTECT : 0) | _PAGE_INVALID | _PAGE_SPECIAL;
	...
                if ((pte_val(pte) & mask) != 0)
                        return 0;
	...

The XIP code used the pte_mkspecial mechanics to make it work. As far as
I can see the pfn_t_devmap returns true for the DAX mappins, yes?
Then I would say that dcssblk and DAX currently do not work together.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

