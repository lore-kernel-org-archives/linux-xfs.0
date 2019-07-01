Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:46114 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfGAKOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 06:14:02 -0400
MIME-Version: 1.0
References: <20190629073020.22759-1-yuchao0@huawei.com> <afda5702-1d88-7634-d943-0c413ae3b28f@huawei.com>
 <a27e3502-db75-22fa-4545-e588abbbfbf2@huawei.com> <58511d64-aa7a-8ac2-0255-affe0e8d49de@huawei.com>
 <CAHpGcMK4ihE1nv7ME0yKKUdBj+Rdr9nBMnxAtQfFFOmK9aEY_A@mail.gmail.com> <aa64b0cf-94e8-aa23-9271-66c7b506abc2@huawei.com>
In-Reply-To: <aa64b0cf-94e8-aa23-9271-66c7b506abc2@huawei.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Mon, 1 Jul 2019 12:13:50 +0200
Message-ID: <CAHpGcMJHYkHN65jLG_CxWf1Ei6MxdUORu61jZ3_ERPmxsu6A0Q@mail.gmail.com>
Subject: Re: [PATCH RFC] iomap: introduce IOMAP_TAIL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chao Yu <yuchao0@huawei.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, chao@kernel.org

Am Mo., 1. Juli 2019 um 12:09 Uhr schrieb Chao Yu <yuchao0@huawei.com>:
> On 2019/7/1 17:49, Andreas Gr=C3=BCnbacher wrote:
> > Am Mo., 1. Juli 2019 um 10:04 Uhr schrieb Gao Xiang <gaoxiang25@huawei.=
com>:
> >> On 2019/7/1 14:40, Chao Yu wrote:
> >>> Hi Xiang,
> >>>
> >>> On 2019/6/29 17:34, Gao Xiang wrote:
> >>>> Hi Chao,
> >>>>
> >>>> On 2019/6/29 15:30, Chao Yu wrote:
> >>>>> Some filesystems like erofs/reiserfs have the ability to pack tail
> >>>>> data into metadata, however iomap framework can only support mappin=
g
> >>>>> inline data with IOMAP_INLINE type, it restricts that:
> >>>>> - inline data should be locating at page #0.
> >>>>> - inline size should equal to .i_size
> >>>>> So we can not use IOMAP_INLINE to handle tail-packing case.
> >>>>>
> >>>>> This patch introduces new mapping type IOMAP_TAIL to map tail-packe=
d
> >>>>> data for further use of erofs.
> >>>>>
> >>>>> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> >>>>> ---
> >>>>>  fs/iomap.c            | 22 ++++++++++++++++++++++
> >>>>>  include/linux/iomap.h |  1 +
> >>>>>  2 files changed, 23 insertions(+)
> >>>>>
> >>>>> diff --git a/fs/iomap.c b/fs/iomap.c
> >>>>> index 12654c2e78f8..ae7777ce77d0 100644
> >>>>> --- a/fs/iomap.c
> >>>>> +++ b/fs/iomap.c
> >>>>> @@ -280,6 +280,23 @@ iomap_read_inline_data(struct inode *inode, st=
ruct page *page,
> >>>>>     SetPageUptodate(page);
> >>>>>  }
> >>>>>
> >>>>> +static void
> >>>>> +iomap_read_tail_data(struct inode *inode, struct page *page,
> >>>>> +           struct iomap *iomap)
> >>>>> +{
> >>>>> +   size_t size =3D i_size_read(inode) & (PAGE_SIZE - 1);
> >>>>> +   void *addr;
> >>>>> +
> >>>>> +   if (PageUptodate(page))
> >>>>> +           return;
> >>>>> +
> >>>>> +   addr =3D kmap_atomic(page);
> >>>>> +   memcpy(addr, iomap->inline_data, size);
> >>>>> +   memset(addr + size, 0, PAGE_SIZE - size);
> >>>>
> >>>> need flush_dcache_page(page) here for new page cache page since
> >>>> it's generic iomap code (althrough not necessary for x86, arm), I am=
 not sure...
> >>>> see commit d2b2c6dd227b and c01778001a4f...
> >>>
> >>> Thanks for your reminding, these all codes were copied from
> >>> iomap_read_inline_data(), so I think we need a separated patch to fix=
 this issue
> >>> if necessary.
> >>
> >> Yes, just a reminder, it is good as it-is.
> >
> > Not sure if that means that IOMAP_INLINE as is works for you now. In
> > any case, if the inline data isn't transparently copied into the page
> > cache at index 0, memory-mapped I/O isn't going to work.
> >
> > The code further assumes that "packed" files consist of exactly one
> > IOMAP_INLINE mapping; no IOMAP_MAPPED or other mappings may follow. Is
> > it that assumption that's causing you trouble? If so, what's the
>
> Yes, that's the problem we met.
>
> > layout at the filesystem level you want to support?
>
> The layout which can support tail-merge one, it means if the data locatin=
g at
> the tail of file has small enough size, we can inline the tail data into
> metadata area. e.g.:
>
> IOMAP_MAPPED [0, 8192]
> IOMAP_INLINE (or maybe IOMAP_TAIL) [8192, 8200]

Ah, now I see. Let's generalize the IOMAP_INLINE code to support that
and rename it to IOMAP_TAIL then.

Thanks,
Andreas
