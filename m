Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14532 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387864AbfHCBll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 21:41:41 -0400
Subject: Re: [PATCH 31/34] nfs: convert put_page() to put_user_page*()
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-32-jhubbard@nvidia.com>
 <1738cb1e-15d8-0bbe-5362-341664f6efc8@oracle.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <db136399-ed87-56ea-bd6e-e5d29b145eda@nvidia.com>
Date: Fri, 2 Aug 2019 18:41:38 -0700
MIME-Version: 1.0
In-Reply-To: <1738cb1e-15d8-0bbe-5362-341664f6efc8@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Calum Mackay <calum.mackay@oracle.com>, john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>

On 8/2/19 6:27 PM, Calum Mackay wrote:
> On 02/08/2019 3:20 am, john.hubbard@gmail.com wrote:
...=20
> Since it's static, and only called twice, might it be better to change it=
s two callers [nfs_direct_{read,write}_schedule_iovec()] to call put_user_p=
ages() directly, and remove nfs_direct_release_pages() entirely?
>=20
> thanks,
> calum.
>=20
>=20
>> =C2=A0 =C2=A0 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinf=
o,
>>
=20
Hi Calum,

Absolutely! Is it OK to add your reviewed-by, with the following incrementa=
l
patch made to this one?

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index b00b89dda3c5..c0c1b9f2c069 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -276,11 +276,6 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_i=
ter *iter)
        return nfs_file_direct_write(iocb, iter);
 }
=20
-static void nfs_direct_release_pages(struct page **pages, unsigned int npa=
ges)
-{
-       put_user_pages(pages, npages);
-}
-
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
                              struct nfs_direct_req *dreq)
 {
@@ -510,7 +505,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nf=
s_direct_req *dreq,
                        pos +=3D req_len;
                        dreq->bytes_left -=3D req_len;
                }
-               nfs_direct_release_pages(pagevec, npages);
+               put_user_pages(pagevec, npages);
                kvfree(pagevec);
                if (result < 0)
                        break;
@@ -933,7 +928,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct n=
fs_direct_req *dreq,
                        pos +=3D req_len;
                        dreq->bytes_left -=3D req_len;
                }
-               nfs_direct_release_pages(pagevec, npages);
+               put_user_pages(pagevec, npages);
                kvfree(pagevec);
                if (result < 0)
                        break;



thanks,
--=20
John Hubbard
NVIDIA
