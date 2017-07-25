Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:37643 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdGYMTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 08:19:02 -0400
Received: by mail-ua0-f174.google.com with SMTP id f9so101542998uaf.4
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2017 05:19:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170725121644.GF19943@quack2.suse.cz>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
 <1499462881-4238-4-git-send-email-agruenba@redhat.com> <20170725121644.GF19943@quack2.suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 25 Jul 2017 14:19:01 +0200
Message-ID: <CAHc6FU59B+s9rktG8PmDJvqnag-hQMcwJC57N-ZVFF2JwjAAPg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] ext4: Add IOMAP_REPORT support for inline data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Tue, Jul 25, 2017 at 2:16 PM, Jan Kara <jack@suse.cz> wrote:
> On Fri 07-07-17 23:28:01, Andreas Gruenbacher wrote:
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 82f3f7d..e2b0a8a 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3361,8 +3361,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>>       bool delalloc = false;
>>       int ret;
>>
>> -     if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>> -             return -ERANGE;
>> +     if (ext4_has_inline_data(inode)) {
>> +             if (WARN_ON_ONCE(!(flags & IOMAP_REPORT)))
>> +                     return -ERANGE;
>> +             if (!ext4_inline_data_iomap(inode, iomap) &&
>> +                 offset < iomap->length)
>
> Hum, what's the thinking behind this "offset < iomap->length" check? If it
> fails, we'd just fall through to the normal case which I'm not sure is
> guaranteed to be safe? Shouldn't we return error instead?

Indeed. I'll send out an updated patch queue including this and
several other changes shortly.

Thanks,
Andreas
