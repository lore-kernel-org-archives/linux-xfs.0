Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:51798 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdJBOkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Oct 2017 10:40:00 -0400
Received: by mail-ua0-f178.google.com with SMTP id 47so3044866uas.8
        for <linux-xfs@vger.kernel.org>; Mon, 02 Oct 2017 07:39:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170928175748.23b7wkjiqavpunvj@thunk.org>
References: <20170914095047.23935-1-agruenba@redhat.com> <20170914095047.23935-4-agruenba@redhat.com>
 <20170928175748.23b7wkjiqavpunvj@thunk.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 2 Oct 2017 16:39:59 +0200
Message-ID: <CAHc6FU4iEYQb7TV-kqFUt4Z6qTkRO1NgWixdeQ-BYBDTk6v3EA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ext4: Add iomap support for inline data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 28, 2017 at 7:57 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 14, 2017 at 11:50:46AM +0200, Andreas Gruenbacher wrote:
>> +int ext4_inline_data_iomap(struct inode *inode, struct iomap *iomap)
>> +{
>> +     __u64 addr;
>> +     int error = -EAGAIN;
>> +     struct ext4_iloc iloc;
>> +
>> +     down_read(&EXT4_I(inode)->xattr_sem);
>> +     if (!ext4_has_inline_data(inode))
>> +             goto out;
>         ....
>> +out:
>> +     up_read(&EXT4_I(inode)->xattr_sem);
>> +     return error;
>> +}
>
>
> If we race with the inline data flag getting cleared,
> ext4_iomap_begin() will return with -EAGAIN.

Actually, in that case, ext4_iomap_begin will treat the file as non-inline.
It will not return -EAGAIN.

> As near as I can tell,
> this will get reflected all the way up to userspace, instead of having
> the retry happen in the kernel.  Is this intentional?
>
> It looks like a user visible change, no?

That would be a bug.

Thanks,
Andreas
