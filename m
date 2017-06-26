Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35815 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdFZOLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 10:11:53 -0400
Received: by mail-ua0-f175.google.com with SMTP id j53so1552260uaa.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2017 07:11:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170626104716.GB23149@infradead.org>
References: <1498224884-346-1-git-send-email-agruenba@redhat.com>
 <1498224884-346-2-git-send-email-agruenba@redhat.com> <20170626104716.GB23149@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 26 Jun 2017 16:11:52 +0200
Message-ID: <CAHc6FU4wSzZ8zswKmyfX5NOq3faHJPrmJxPXWKqAYau+ipE1FQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] vfs: Add iomap_seek_hole_data helper
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>

On Mon, Jun 26, 2017 at 12:47 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jun 23, 2017 at 03:34:39PM +0200, Andreas Gruenbacher wrote:
>> Filesystems can use this for implementing lseek SEEK_HOLE / SEEK_DATA
>> support via iomap.
>>
>> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>> ---
>>  fs/iomap.c            | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/iomap.h |  3 ++
>>  2 files changed, 92 insertions(+)
>>
>> diff --git a/fs/iomap.c b/fs/iomap.c
>> index 4b10892..781f0a0 100644
>> --- a/fs/iomap.c
>> +++ b/fs/iomap.c
>> @@ -584,6 +584,95 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>>  }
>>  EXPORT_SYMBOL_GPL(iomap_fiemap);
>>
>> +static loff_t
>> +iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
>> +                   void *data, struct iomap *iomap)
>> +{
>> +     if (iomap->type == IOMAP_HOLE)
>> +             goto found;
>> +     length = iomap->offset + iomap->length - offset;
>
> What is the problem with the passed in length value?

Yep, no need to recompute that.

>> +     if (iomap->type != IOMAP_UNWRITTEN)
>> +             return length;
>> +     offset = page_cache_seek_hole_data(inode, offset, length, SEEK_HOLE);
>> +     if (offset < 0)
>> +             return length;
>> +found:
>> +     *(loff_t *)data = offset;
>> +     return 0;
>
> What about using a switch statement?
>
>         switch (iomap->type) {
>         case IOMAP_UNWRITTEN:
>                 offset = page_cache_seek_hole_data(inode, offset, length,
>                                 SEEK_HOLE);
>                 if (offset < 0)
>                         return length;
>                 /*FALLTHRU*/
>         case IOMAP_HOLE:
>                 *(loff_t *)data = offset;
>                 return 0;
>         default:
>                 return length;
>         }

Ok.

>> +static loff_t
>> +iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
>> +                   void *data, struct iomap *iomap)
>> +{
>> +     if (iomap->type != IOMAP_HOLE && iomap->type != IOMAP_UNWRITTEN)
>> +             goto found;
>> +     length = iomap->offset + iomap->length - offset;
>> +     if (iomap->type != IOMAP_UNWRITTEN)
>> +             return length;
>> +     offset = page_cache_seek_hole_data(inode, offset, length, SEEK_DATA);
>> +     if (offset < 0)
>> +             return length;
>> +found:
>> +     *(loff_t *)data = offset;
>> +     return 0;
>
>> +loff_t
>> +iomap_seek_hole_data(struct inode *inode, loff_t offset,
>> +                  int whence, const struct iomap_ops *ops)
>> +{
>> +     static loff_t (*actor)(struct inode *, loff_t, loff_t, void *,
>> +                            struct iomap *);
>
> I wonder (but I'm not sure) if it would be simpler and easier to
> understand to just have to different functions for SEEK_HOLE
> vs SEEK_DATA here.

Neither variant seems obviously better to me.

Thanks,
Andreas
