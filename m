Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:36474 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdF3MMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 08:12:00 -0400
Received: by mail-ua0-f180.google.com with SMTP id g40so74197000uaa.3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2017 05:11:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
References: <20170629135420.21357-1-hch@lst.de> <20170629135420.21357-6-hch@lst.de>
 <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 30 Jun 2017 14:11:58 +0200
Message-ID: <CAHc6FU7NOnYywJAbQTwgUS+cqkAZTSeQU3NsCMHWbQ6cztvNJw@mail.gmail.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Jun 30, 2017 at 1:51 PM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> On Thu, Jun 29, 2017 at 3:54 PM, Christoph Hellwig <hch@lst.de> wrote:
>> Switch to the iomap_seek_hole and iomap_seek_data helpers for
>> implementing lseek SEEK_HOLE / SEEK_DATA, and remove all the
>> code that isn't needed any more.
>>
>> Note that with this patch ext4 will now always depend on the iomap
>> code instead of only when CONFIG_DAX is enabled, and it requires
>> adding a call into the extent status tree for iomap_begin as well
>> to properly deal with delalloc extents.
>
> This breaks SEEK_HOLE / SEEK_DATA on filesystems with the inline_data feature.
>
> Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
> to be added back for consistency between reading i_size and walking
> the file extents.

Same on xfs, btw.

Thanks,
Andreas
