Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56011 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfHGHU7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Aug 2019 03:20:59 -0400
Date: Wed, 7 Aug 2019 10:20:07 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v3 11/41] media/v4l2-core/mm: convert put_page() to
 put_user_page*()
Message-ID: <20190807072007.GG21370@paasikivi.fi.intel.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
 <20190807013340.9706-12-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807013340.9706-12-jhubbard@nvidia.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: john.hubbard@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Kees Cook <keescook@chromium.org>, Hans Verkuil <hans.verkuil@cisco.com>, Robin Murphy <robin.murphy@arm.com>, Souptick Joarder <jrdr.linux@gmail.com>

On Tue, Aug 06, 2019 at 06:33:10PM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
