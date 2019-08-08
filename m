Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14417 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbfHHDqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 23:46:54 -0400
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
 <20190802142443.GB5597@bombadil.infradead.org>
 <20190802145227.GQ25064@quack2.suse.cz>
 <076e7826-67a5-4829-aae2-2b90f302cebd@nvidia.com>
 <20190807083726.GA14658@quack2.suse.cz>
 <20190807084649.GQ11812@dhcp22.suse.cz>
 <20190808023637.GA1508@iweiny-DESK2.sc.intel.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <e648a7f3-6a1b-c9ea-1121-7ab69b6b173d@nvidia.com>
Date: Wed, 7 Aug 2019 20:46:50 -0700
MIME-Version: 1.0
In-Reply-To: <20190808023637.GA1508@iweiny-DESK2.sc.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ira Weiny <ira.weiny@intel.com>, Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org

On 8/7/19 7:36 PM, Ira Weiny wrote:
> On Wed, Aug 07, 2019 at 10:46:49AM +0200, Michal Hocko wrote:
>> On Wed 07-08-19 10:37:26, Jan Kara wrote:
>>> On Fri 02-08-19 12:14:09, John Hubbard wrote:
>>>> On 8/2/19 7:52 AM, Jan Kara wrote:
>>>>> On Fri 02-08-19 07:24:43, Matthew Wilcox wrote:
>>>>>> On Fri, Aug 02, 2019 at 02:41:46PM +0200, Jan Kara wrote:
>>>>>>> On Fri 02-08-19 11:12:44, Michal Hocko wrote:
>>>>>>>> On Thu 01-08-19 19:19:31, john.hubbard@gmail.com wrote:
  [...]
> Before I go on, I would like to say that the "imbalance" of get_user_pages()
> and put_page() bothers me from a purist standpoint...  However, since this
> discussion cropped up I went ahead and ported my work to Linus' current master
> (5.3-rc3+) and in doing so I only had to steal a bit of Johns code...  Sorry
> John...  :-(
> 
> I don't have the commit messages all cleaned up and I know there may be some
> discussion on these new interfaces but I wanted to throw this series out there
> because I think it may be what Jan and Michal are driving at (or at least in
> that direction.
> 
> Right now only RDMA and DAX FS's are supported.  Other users of GUP will still
> fail on a DAX file and regular files will still be at risk.[2]
> 
> I've pushed this work (based 5.3-rc3+ (33920f1ec5bf)) here[3]:
> 
> https://github.com/weiny2/linux-kernel/tree/linus-rdmafsdax-b0-v3
> 
> I think the most relevant patch to this conversation is:
> 
> https://github.com/weiny2/linux-kernel/commit/5d377653ba5cf11c3b716f904b057bee6641aaf6
> 

ohhh...can you please avoid using the old __put_user_pages_dirty()
function? I thought I'd caught things early enough to get away with
the rename and deletion of that. You could either:

a) open code an implementation of vaddr_put_pages_dirty_lock() that
doesn't call any of the *put_user_pages_dirty*() variants, or

b) include my first patch ("") are part of your series, or

c) base this on Andrews's tree, which already has merged in my first patch.


thanks,
-- 
John Hubbard
NVIDIA
