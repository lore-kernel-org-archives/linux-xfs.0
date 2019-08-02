Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11805 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387890AbfHBJTf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Aug 2019 05:19:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
In-Reply-To: <20190802022005.5117-7-jhubbard@nvidia.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-7-jhubbard@nvidia.com>
Message-ID: <156473756254.19842.12384378926183716632@jlahtine-desk.ger.corp.intel.com>
Subject: Re: [PATCH 06/34] drm/i915: convert put_page() to put_user_page*()
Date: Fri, 02 Aug 2019 12:19:22 +0300
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, john.hubbard@gmail.com
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>

Quoting john.hubbard@gmail.com (2019-08-02 05:19:37)
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Note that this effectively changes the code's behavior in
> i915_gem_userptr_put_pages(): it now calls set_page_dirty_lock(),
> instead of set_page_dirty(). This is probably more accurate.

We've already fixed this in drm-tip where the current code uses
set_page_dirty_lock().

This would conflict with our tree. Rodrigo is handling
drm-intel-next for 5.4, so you guys want to coordinate how
to merge.

Regards, Joonas
