Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34177 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdF3LvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 07:51:12 -0400
Received: by mail-vk0-f53.google.com with SMTP id r125so65139748vkf.1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2017 04:51:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170629135420.21357-6-hch@lst.de>
References: <20170629135420.21357-1-hch@lst.de> <20170629135420.21357-6-hch@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 30 Jun 2017 13:51:10 +0200
Message-ID: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, Jun 29, 2017 at 3:54 PM, Christoph Hellwig <hch@lst.de> wrote:
> Switch to the iomap_seek_hole and iomap_seek_data helpers for
> implementing lseek SEEK_HOLE / SEEK_DATA, and remove all the
> code that isn't needed any more.
>
> Note that with this patch ext4 will now always depend on the iomap
> code instead of only when CONFIG_DAX is enabled, and it requires
> adding a call into the extent status tree for iomap_begin as well
> to properly deal with delalloc extents.

This breaks SEEK_HOLE / SEEK_DATA on filesystems with the inline_data feature.

Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
to be added back for consistency between reading i_size and walking
the file extents.

Thanks,
Andreas
