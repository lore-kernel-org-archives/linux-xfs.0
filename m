Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfHDX3u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 19:29:50 -0400
Subject: Re: [PATCH 31/34] nfs: convert put_page() to put_user_page*()
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-32-jhubbard@nvidia.com>
 <1738cb1e-15d8-0bbe-5362-341664f6efc8@oracle.com>
 <db136399-ed87-56ea-bd6e-e5d29b145eda@nvidia.com>
From: Calum Mackay <calum.mackay@oracle.com>
Message-ID: <03a81556-98a7-7edb-5989-b799ec99a072@oracle.com>
Date: Mon, 5 Aug 2019 00:28:01 +0100
MIME-Version: 1.0
In-Reply-To: <db136399-ed87-56ea-bd6e-e5d29b145eda@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: John Hubbard <jhubbard@nvidia.com>, john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: calum.mackay@oracle.com, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>

On 03/08/2019 2:41 am, John Hubbard wrote:
> On 8/2/19 6:27 PM, Calum Mackay wrote:
>> On 02/08/2019 3:20 am, john.hubbard@gmail.com wrote:
> ...
>> Since it's static, and only called twice, might it be better to change its two callers [nfs_direct_{read,write}_schedule_iovec()] to call put_user_pages() directly, and remove nfs_direct_release_pages() entirely?
>>
>> thanks,
>> calum.
>>
>>
>>>      void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
>>>
>   
> Hi Calum,
> 
> Absolutely! Is it OK to add your reviewed-by, with the following incremental
> patch made to this one?

Thanks John; looks good.

Reviewed-by: Calum Mackay <calum.mackay@oracle.com>

> 
> diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> index b00b89dda3c5..c0c1b9f2c069 100644
> --- a/fs/nfs/direct.c
> +++ b/fs/nfs/direct.c
> @@ -276,11 +276,6 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>          return nfs_file_direct_write(iocb, iter);
>   }
>   
> -static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
> -{
> -       put_user_pages(pages, npages);
> -}
> -
>   void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
>                                struct nfs_direct_req *dreq)
>   {
> @@ -510,7 +505,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
>                          pos += req_len;
>                          dreq->bytes_left -= req_len;
>                  }
> -               nfs_direct_release_pages(pagevec, npages);
> +               put_user_pages(pagevec, npages);
>                  kvfree(pagevec);
>                  if (result < 0)
>                          break;
> @@ -933,7 +928,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
>                          pos += req_len;
>                          dreq->bytes_left -= req_len;
>                  }
> -               nfs_direct_release_pages(pagevec, npages);
> +               put_user_pages(pagevec, npages);
>                  kvfree(pagevec);
>                  if (result < 0)
>                          break;
> 
> 
> 
> thanks,
> 
