Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17795 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391971AbfHBTew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 15:34:52 -0400
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
References: <20190802021653.4882-1-jhubbard@nvidia.com>
 <20190802080554.GD2332@hirez.programming.kicks-ass.net>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <8968c928-5712-03a9-68df-051f5b58fdbc@nvidia.com>
Date: Fri, 2 Aug 2019 12:33:13 -0700
MIME-Version: 1.0
In-Reply-To: <20190802080554.GD2332@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>, john.hubbard@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org

On 8/2/19 1:05 AM, Peter Zijlstra wrote:
> On Thu, Aug 01, 2019 at 07:16:19PM -0700, john.hubbard@gmail.com wrote:
> 
>> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
>> ("mm: introduce put_user_page*(), placeholder versions"). That commit
>> has an extensive description of the problem and the planned steps to
>> solve it, but the highlites are:
> 
> That is one horridly mangled Changelog there :-/ It looks like it's
> partially duplicated.

Yeah. It took so long to merge that I think I was no longer able to
actually see the commit description, after N readings. sigh

> 
> Anyway; no objections to any of that, but I just wanted to mention that
> there are other problems with long term pinning that haven't been
> mentioned, notably they inhibit compaction.
> 
> A long time ago I proposed an interface to mark pages as pinned, such
> that we could run compaction before we actually did the pinning.
> 

This is all heading toward marking pages as pinned, so we should finally
get there.  I'll post the RFC for tracking pinned pages shortly.


thanks,
-- 
John Hubbard
NVIDIA
