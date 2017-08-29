Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:38583 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdH2NqI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 09:46:08 -0400
Received: by mail-vk0-f44.google.com with SMTP id l132so9567532vke.5
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 06:46:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170725124511.GG19943@quack2.suse.cz>
References: <20170629135420.21357-1-hch@lst.de> <20170629135420.21357-6-hch@lst.de>
 <20170725124511.GG19943@quack2.suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 29 Aug 2017 15:46:07 +0200
Message-ID: <CAHc6FU5e7SaEtZGVRPWdnLBHZ72dqd-3JTOHjJsPMQ=mOe9ZbA@mail.gmail.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

Jan,

On Tue, Jul 25, 2017 at 2:45 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 29-06-17 06:54:20, Christoph Hellwig wrote:
>> @@ -3359,6 +3358,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>>       unsigned long first_block = offset >> blkbits;
>>       unsigned long last_block = (offset + length - 1) >> blkbits;
>>       struct ext4_map_blocks map;
>> +     bool delalloc = false;
>>       int ret;
>>
>>       if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>> @@ -3369,6 +3369,27 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>>
>>       if (!(flags & IOMAP_WRITE)) {
>>               ret = ext4_map_blocks(NULL, inode, &map, 0);
>> +             if (!ret) {
>> +                     struct extent_status es = {};
>> +
>> +                     ext4_es_find_delayed_extent_range(inode, map.m_lblk,
>> +                                     map.m_lblk + map.m_len - 1, &es);
>> +                     /* Is delalloc data before next block in extent tree? */
>> +                     if (es.es_len && es.es_lblk < map.m_lblk + map.m_len) {
>> +                             ext4_lblk_t offset = 0;
>> +
>> +                             if (es.es_lblk < map.m_lblk)
>> +                                     offset = map.m_lblk - es.es_lblk;
>> +                             map.m_lblk = es.es_lblk + offset;
>> +                             map.m_pblk = ext4_es_pblock(&es) + offset;
>
> This is wrong for delalloc extent - adding offset to some magic block
> value...

Right.

>> +                             map.m_len = es.es_len - offset;
>> +                             if (ext4_es_status(&es) & EXTENT_STATUS_UNWRITTEN)
>> +                                     map.m_flags |= EXT4_MAP_UNWRITTEN;
>> +                             if (ext4_es_status(&es) & EXTENT_STATUS_DELAYED)
>> +                                     delalloc = true;
>> +                             ret = 1;
>> +                     }
>> +             }
>
> Also the delalloc handling seems to be wrong that if we have file as:
>
> HD
>
> where H is hole, D is delalloc block, and iomap is called at offset 0, we
> should be getting back "hole at 0" back but instead you will return
> "delalloc at 1".
>
> We deal with a similar situation in ext4_da_map_blocks() so it would be
> good if we could reuse that one rather than reimplementing it here. But
> factoring the necessary functionality out isn't that easy.

I've tried to figure out where the issue might be, and I really don't see any.

It may be confusing that ext4_iomap_begin doesn't split up
IOMAP_UNWRITTEN maps into holes and data as ext4_find_unwritten_pgoff
did. This splitting is instead done generically in
iomap_seek_{hole,data} for IOMAP_UNWRITTEN maps using
page_cache_seek_hole_data.

I'll post an improved version of this patch queue shortly.

Thanks,
Andreas
