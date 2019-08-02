Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16559 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391984AbfHBTPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 15:15:50 -0400
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
 <20190802142443.GB5597@bombadil.infradead.org>
 <20190802145227.GQ25064@quack2.suse.cz>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <076e7826-67a5-4829-aae2-2b90f302cebd@nvidia.com>
Date: Fri, 2 Aug 2019 12:14:09 -0700
MIME-Version: 1.0
In-Reply-To: <20190802145227.GQ25064@quack2.suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>, john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org

On 8/2/19 7:52 AM, Jan Kara wrote:
> On Fri 02-08-19 07:24:43, Matthew Wilcox wrote:
>> On Fri, Aug 02, 2019 at 02:41:46PM +0200, Jan Kara wrote:
>>> On Fri 02-08-19 11:12:44, Michal Hocko wrote:
>>>> On Thu 01-08-19 19:19:31, john.hubbard@gmail.com wrote:
>>>> [...]
>>>>> 2) Convert all of the call sites for get_user_pages*(), to
>>>>> invoke put_user_page*(), instead of put_page(). This involves dozens of
>>>>> call sites, and will take some time.
>>>>
>>>> How do we make sure this is the case and it will remain the case in the
>>>> future? There must be some automagic to enforce/check that. It is simply
>>>> not manageable to do it every now and then because then 3) will simply
>>>> be never safe.
>>>>
>>>> Have you considered coccinele or some other scripted way to do the
>>>> transition? I have no idea how to deal with future changes that would
>>>> break the balance though.

Hi Michal,

Yes, I've thought about it, and coccinelle falls a bit short (it's not smart
enough to know which put_page()'s to convert). However, there is a debug
option planned: a yet-to-be-posted commit [1] uses struct page extensions
(obviously protected by CONFIG_DEBUG_GET_USER_PAGES_REFERENCES) to add
a redundant counter. That allows:

void __put_page(struct page *page)
{
	...
	/* Someone called put_page() instead of put_user_page() */
	WARN_ON_ONCE(atomic_read(&page_ext->pin_count) > 0);

>>>
>>> Yeah, that's why I've been suggesting at LSF/MM that we may need to create
>>> a gup wrapper - say vaddr_pin_pages() - and track which sites dropping
>>> references got converted by using this wrapper instead of gup. The
>>> counterpart would then be more logically named as unpin_page() or whatever
>>> instead of put_user_page().  Sure this is not completely foolproof (you can
>>> create new callsite using vaddr_pin_pages() and then just drop refs using
>>> put_page()) but I suppose it would be a high enough barrier for missed
>>> conversions... Thoughts?

The debug option above is still a bit simplistic in its implementation (and maybe
not taking full advantage of the data it has), but I think it's preferable,
because it monitors the "core" and WARNs.

Instead of the wrapper, I'm thinking: documentation and the passage of time,
plus the debug option (perhaps enhanced--probably once I post it someone will
notice opportunities), yes?

>>
>> I think the API we really need is get_user_bvec() / put_user_bvec(),
>> and I know Christoph has been putting some work into that.  That avoids
>> doing refcount operations on hundreds of pages if the page in question is
>> a huge page.  Once people are switched over to that, they won't be tempted
>> to manually call put_page() on the individual constituent pages of a bvec.
> 
> Well, get_user_bvec() is certainly a good API for one class of users but
> just looking at the above series, you'll see there are *many* places that
> just don't work with bvecs at all and you need something for those.
> 

Yes, there are quite a few places that don't involve _bvec, as we can see
right here. So we need something. Andrew asked for a debug option some time
ago, and several people (Dave Hansen, Dan Williams, Jerome) had the idea
of vmap-ing gup pages separately, so you can definitely tell where each
page came from. I'm hoping not to have to go to that level of complexity
though.


[1] "mm/gup: debug tracking of get_user_pages() references" :
https://github.com/johnhubbard/linux/commit/21ff7d6161ec2a14d3f9d17c98abb00cc969d4d6

thanks,
-- 
John Hubbard
NVIDIA
