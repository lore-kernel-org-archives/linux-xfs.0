Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4930 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfHLVUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 17:20:20 -0400
Subject: Re: [RFC PATCH v2 15/19] mm/gup: Introduce vaddr_pin_pages()
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-16-ira.weiny@intel.com>
 <6ed26a08-4371-9dc1-09eb-7b8a4689d93b@nvidia.com>
 <20190812210013.GC20634@iweiny-DESK2.sc.intel.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <b4e15390-701d-c6e9-564c-04e6a3effd50@nvidia.com>
Date: Mon, 12 Aug 2019 14:20:14 -0700
MIME-Version: 1.0
In-Reply-To: <20190812210013.GC20634@iweiny-DESK2.sc.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org

On 8/12/19 2:00 PM, Ira Weiny wrote:
> On Fri, Aug 09, 2019 at 05:09:54PM -0700, John Hubbard wrote:
>> On 8/9/19 3:58 PM, ira.weiny@intel.com wrote:
>>> From: Ira Weiny <ira.weiny@intel.com>
...
> 
> At one point I wanted to (and had in my tree) a new flag but I went away from
> it.  Prior to the discussion on mlock last week I did not think we needed it.
> But I'm ok to add it back in.
> 
> I was not ignoring the idea for this RFC I just wanted to get this out there
> for people to see.  I see that you threw out a couple of patches which add this
> flag in.
> 
> FWIW, I think it would be good to differentiate between an indefinite pinned
> page vs a referenced "gotten" page.
> 
> What you and I have been working on is the former.  So it would be easy to
> change your refcounting patches to simply key off of FOLL_PIN.
> 
> Would you like me to add in your FOLL_PIN patches to this series?

Sure, that would be perfect. They don't make any sense on their own, and
it's all part of the same design idea.

thanks,
-- 
John Hubbard
NVIDIA
