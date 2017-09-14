Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:43566 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751724AbdINJR0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2017 05:17:26 -0400
Received: by mail-io0-f171.google.com with SMTP id k101so16342250iod.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2017 02:17:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170830145921.GB5920@quack2.suse.cz>
References: <20170829142942.21594-1-agruenba@redhat.com> <20170829142942.21594-5-agruenba@redhat.com>
 <20170830145921.GB5920@quack2.suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 14 Sep 2017 11:17:24 +0200
Message-ID: <CAHc6FU4aDVF7fhYVfShnRyg=0P=8T7mJ9D59r2CC1i2OO-SEeQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Jan,

On Wed, Aug 30, 2017 at 4:59 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 29-08-17 16:29:42, Andreas Gruenbacher wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> Switch to the iomap_seek_hole and iomap_seek_data helpers for
>> implementing lseek SEEK_HOLE / SEEK_DATA, and remove all the code that
>> isn't needed any more.
>>
>> Note that with this patch, ext4 will now always depend on the iomap code
>> instead of only when CONFIG_DAX is enabled, and it requires adding a
>> call into the extent status tree for iomap_begin as well to properly
>> deal with delalloc extents.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> [Minor fixes and cleanups by Andreas]
>> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>
> ...
>
>> @@ -3425,6 +3425,29 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>>
>>       if (!(flags & IOMAP_WRITE)) {
>>               ret = ext4_map_blocks(NULL, inode, &map, 0);
>> +             if (ret < 0)
>> +                     return ret;
>
> One general question about IOMAP_REPORT: When there is unwritten extent, we
> use page_cache_seek_hole_data() to determine what is actually a hole and
> what is data. We could use exactly the same function to determine what is a
> hole and what is data in an IOMAP_HOLE extent, couldn't we? Now I
> understand that a filesystem is supposed to return IOMAP_DELALLOC extent if
> there is delayed allocation data covering queried offset so probably it's
> not a great idea to use that however it still seems a bit like an
> unnecessary duplication...

There is no point in scanning the page cache on filesystems that don't
support delayed allocation, so it does make sense to distinguish the
two types of mappings.

>> +             if (!ret) {
>
> Please go to this branch only for IOMAP_REPORT case to avoid unnecessary
> overhead for DAX mappings...
>
>> +                     struct extent_status es = {};
>> +
>> +                     ext4_es_find_delayed_extent_range(inode, map.m_lblk,
>> +                                     map.m_lblk + map.m_len - 1, &es);
>> +                     /* Is delalloc data before next block in extent tree? */
>> +                     if (es.es_len && es.es_lblk < map.m_lblk + map.m_len) {
>
> And this is still wrong - I have actually verified that with attached patch
> that disables caching of extents (so it is equivalent to *very* aggresive
> slab reclaim happening). With that patch applied you'll get:
>
> kvm0:~ # rm /mnt/file; xfs_io -f -c "pwrite 4096 4096" -c "seek -a 0"
> /mnt/file
> wrote 4096/4096 bytes at offset 4096
> 4 KiB, 1 ops; 0.0000 sec (16.693 MiB/sec and 4273.5043 ops/sec)
> Whence  Result
> DATA    0
> HOLE    8192
>
> Which is obviously wrong - hole should be 0, data should be 4096.
>
> And the reason why this is wrong is that when we are asked to map things at
> first_block and there is a hole at that offset, we need to just truncate
> the hole extent returned by ext4_map_blocks() by possibly following
> delalloc allocation. But we still need to return that there *is a hole* at
> first_block. But your patch seems to try to return the delalloc extent
> instead which is wrong.

Got it, thanks for the debug patch. I'll send a fixed version of the series.

>> +                             ext4_lblk_t offs = 0;
>> +
>> +                             if (es.es_lblk < map.m_lblk)
>> +                                     offs = map.m_lblk - es.es_lblk;
>> +                             map.m_lblk = es.es_lblk + offs;
>> +                             map.m_pblk = ext4_es_pblock(&es) + offs;
>> +                             map.m_len = es.es_len - offs;
>> +                             if (ext4_es_is_unwritten(&es))
>> +                                     map.m_flags |= EXT4_MAP_UNWRITTEN;
>> +                             if (ext4_es_is_delayed(&es))
>> +                                     delalloc = true;
>> +                             ret = 1;
>> +                     }
>> +             }
>>       } else {
>>               int dio_credits;
>>               handle_t *handle;

Thanks,
Andreas
