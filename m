Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11756 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfHBCjE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 22:39:04 -0400
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
References: <20190802021653.4882-1-jhubbard@nvidia.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <ec87b662-0fc2-0951-1337-a91b4888201b@nvidia.com>
Date: Thu, 1 Aug 2019 19:39:00 -0700
MIME-Version: 1.0
In-Reply-To: <20190802021653.4882-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org

On 8/1/19 7:16 PM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> Hi,
> 
> These are best characterized as miscellaneous conversions: many (not all)
> call sites that don't involve biovec or iov_iter, nor mm/. It also leaves
> out a few call sites that require some more work. These are mostly pretty
> simple ones.
> 
> It's probably best to send all of these via Andrew's -mm tree, assuming
> that there are no significant merge conflicts with ongoing work in other
> trees (which I doubt, given that these are small changes).
> 

In case anyone is wondering, this truncated series is due to a script failure:
git-send-email chokes when it hits email addresses whose names have a
comma in them, as happened here with patch 0003.  

Please disregard this set and reply to the other thread.

thanks,
-- 
John Hubbard
NVIDIA
