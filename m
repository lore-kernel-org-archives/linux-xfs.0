Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35964 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1V5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 17:57:15 -0400
Received: by mail-io0-f175.google.com with SMTP id g33so4553483ioj.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 14:57:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170828214957.GJ4757@magnolia>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
 <1503956111-36652-16-git-send-email-keescook@chromium.org> <20170828214957.GJ4757@magnolia>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 28 Aug 2017 14:57:14 -0700
Message-ID: <CAGXu5j+pvxRjASUuBE49+uH34Mw26a4mtcWrZd=CEqcRHjetvA@mail.gmail.com>
Subject: Re: [PATCH v2 15/30] xfs: Define usercopy region in xfs_inode slab cache
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Windsor <dave@nullcore.net>, linux-xfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>

On Mon, Aug 28, 2017 at 2:49 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Aug 28, 2017 at 02:34:56PM -0700, Kees Cook wrote:
>> From: David Windsor <dave@nullcore.net>
>>
>> The XFS inline inode data, stored in struct xfs_inode_t field
>> i_df.if_u2.if_inline_data and therefore contained in the xfs_inode slab
>> cache, needs to be copied to/from userspace.
>>
>> cache object allocation:
>>     fs/xfs/xfs_icache.c:
>>         xfs_inode_alloc(...):
>>             ...
>>             ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
>>
>>     fs/xfs/libxfs/xfs_inode_fork.c:
>>         xfs_init_local_fork(...):
>>             ...
>>             if (mem_size <= sizeof(ifp->if_u2.if_inline_data))
>>                     ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
>
> Hmm, what happens when mem_size > sizeof(if_inline_data)?  A slab object
> will be allocated for ifp->if_u1.if_data which can then be used for
> readlink in the same manner as the example usage trace below.  Does
> that allocated object have a need for a usercopy annotation like
> the one we're adding for if_inline_data?  Or is that already covered
> elsewhere?

Yeah, the xfs helper kmem_alloc() is used in the other case, which
ultimately boils down to a call to kmalloc(), which is entirely
whitelisted by an earlier patch in the series:

https://lkml.org/lkml/2017/8/28/1026

(It's possible that at some future time we can start segregating
kernel-only kmallocs from usercopy-able kmallocs, but for now, there
are no plans for this.)

-Kees

-- 
Kees Cook
Pixel Security
