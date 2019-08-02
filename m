Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52950 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731067AbfHBOYt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 10:24:49 -0400
Date: Fri, 2 Aug 2019 07:24:43 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
Message-ID: <20190802142443.GB5597@bombadil.infradead.org>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802124146.GL25064@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>, john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>

On Fri, Aug 02, 2019 at 02:41:46PM +0200, Jan Kara wrote:
> On Fri 02-08-19 11:12:44, Michal Hocko wrote:
> > On Thu 01-08-19 19:19:31, john.hubbard@gmail.com wrote:
> > [...]
> > > 2) Convert all of the call sites for get_user_pages*(), to
> > > invoke put_user_page*(), instead of put_page(). This involves dozens of
> > > call sites, and will take some time.
> > 
> > How do we make sure this is the case and it will remain the case in the
> > future? There must be some automagic to enforce/check that. It is simply
> > not manageable to do it every now and then because then 3) will simply
> > be never safe.
> > 
> > Have you considered coccinele or some other scripted way to do the
> > transition? I have no idea how to deal with future changes that would
> > break the balance though.
> 
> Yeah, that's why I've been suggesting at LSF/MM that we may need to create
> a gup wrapper - say vaddr_pin_pages() - and track which sites dropping
> references got converted by using this wrapper instead of gup. The
> counterpart would then be more logically named as unpin_page() or whatever
> instead of put_user_page().  Sure this is not completely foolproof (you can
> create new callsite using vaddr_pin_pages() and then just drop refs using
> put_page()) but I suppose it would be a high enough barrier for missed
> conversions... Thoughts?

I think the API we really need is get_user_bvec() / put_user_bvec(),
and I know Christoph has been putting some work into that.  That avoids
doing refcount operations on hundreds of pages if the page in question is
a huge page.  Once people are switched over to that, they won't be tempted
to manually call put_page() on the individual constituent pages of a bvec.
