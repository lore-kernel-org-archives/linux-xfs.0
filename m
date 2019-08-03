Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfHCHGv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Aug 2019 03:06:51 -0400
Date: Sat, 3 Aug 2019 09:06:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/34] staging/vc04_services: convert put_page() to
 put_user_page*()
Message-ID: <20190803070621.GA2508@kroah.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-16-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802022005.5117-16-jhubbard@nvidia.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: john.hubbard@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org, Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, sparclinux@vger.kernel.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, Suniel Mahesh <sunil.m@techveda.org>, x86@kernel.org, amd-gfx@lists.freedesktop.org, Christoph Hellwig <hch@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Mihaela Muraru <mihaela.muraru21@gmail.com>, xen-devel@lists.xenproject.org, devel@lists.orangefs.org, linux-media@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>, John Hubbard <jhubbard@nvidia.com>, intel-gfx@lists.freedesktop.org, Kishore KP <kishore.p@techveda.org>, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-rpi-kernel@lists.infradead.org, Dan Williams <dan.j.williams@intel.com>, Sidong Yang <realwakka@gmail.com>, linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org, Eric Anholt <eric@anholt.net>, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Thu, Aug 01, 2019 at 07:19:46PM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Eric Anholt <eric@anholt.net>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mihaela Muraru <mihaela.muraru21@gmail.com>
> Cc: Suniel Mahesh <sunil.m@techveda.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Sidong Yang <realwakka@gmail.com>
> Cc: Kishore KP <kishore.p@techveda.org>
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  .../vc04_services/interface/vchiq_arm/vchiq_2835_arm.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
