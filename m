Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E02C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 12:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E1460FE8
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 12:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhKAMnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 08:43:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231807AbhKAMnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 08:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635770465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j+gYxaHEAFuVJ+DJo3x07QEuuhtZCDwSEuGUWeCK9J0=;
        b=K+90MiNm0mmziorW5hALAF1zln6kw7+z7N8hRr40VuUwkWfXZp8eDuqubKD+5ctV7VOXwD
        /WM3eVSszBqLonhD2enjrwcIdeFcVJvlzlt2RFcJxrt7tYaP9Cr5jWIrPQ0vQkZp3hr3w/
        byBSYFzuqg6agFRHj6+OZOa3nQKfd4w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-oCh0KnbYN4y_bQMegq2gmg-1; Mon, 01 Nov 2021 08:41:02 -0400
X-MC-Unique: oCh0KnbYN4y_bQMegq2gmg-1
Received: by mail-ed1-f69.google.com with SMTP id o22-20020a056402439600b003dd4f228451so15401463edc.16
        for <linux-xfs@vger.kernel.org>; Mon, 01 Nov 2021 05:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=j+gYxaHEAFuVJ+DJo3x07QEuuhtZCDwSEuGUWeCK9J0=;
        b=y4KYLBwoIw7EvqhGGjIf5+cPI5msj0nEnDXermVJNTLpww8bNIRA4j7WUMZsgSRx0U
         R2P+nGpzq/+SEBtAzAGzLAbJOZhFBchDcY7NGVjaB4Bt/UP+OV3VXXuR0F+TcoF9UQmC
         A7CQlvR+3u5ZA4ZAvu3MrMdaGElX6DCRED9j3f3PqnDEj+IDYO9VxzbSENxm7qIyfTfE
         xZ4Qv+LcUBtduE192yjIjm0nI9+wpeu/csgVUvHgF5ilp1sqIVU6/qAcY5SM2ICTs5bJ
         9PYtmkeufb0pDGzSeM7Xqy0hv6Vc4gRc3O9lkLyPGcGPWekyzCOeijY4w8D04QplbXPz
         Zd8w==
X-Gm-Message-State: AOAM5319i45acWQdFvJveqEgancAEYL4tVGiGuB4m1gpsDfNuVSUKI7h
        k+9lX/+509sdeAfF9Q8CAUr0iX5eWqWNMS+sV9m0mfZYIHX9GEib+Usla0f2/gzoGI6nX/0HkHu
        YC65WPTfQjXErvOSztCx0
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr39314510edd.94.1635770461629;
        Mon, 01 Nov 2021 05:41:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYnqCs+XHgpL3Di4ElIKr9LS4B1DCO72rkdXFPGRLrJf2eeOky8Hm6wWWZAsSq2JTRflw3cQ==
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr39314474edd.94.1635770461393;
        Mon, 01 Nov 2021 05:41:01 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id gs19sm2979263ejc.117.2021.11.01.05.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 05:41:00 -0700 (PDT)
Date:   Mon, 1 Nov 2021 13:40:58 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v2 0/2] xfs: clean up zone terminology
Message-ID: <20211101124058.7vravktsufrcruzu@andromeda.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, linux-xfs@vger.kernel.org
References: <163466951226.2234337.10978241003370731405.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163466951226.2234337.10978241003370731405.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 19, 2021 at 11:51:52AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Dave requested[1] that we stop using the old Irix "zone" terminology to
> describe Linux slab caches.  Since we're using an ugly typedef to wrap
> the new in the old, get rid of the typedef, and change the wording to
> reflect the way Linux has been for a good 20+ years.  This enables
> cleaning up of the bigger zone/cache mess in userspace.
> 
> [1] https://lore.kernel.org/linux-xfs/20210926004343.GC1756565@dread.disaster.area/
> 
> v2: rebase atop the final btree cursor series
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

LGTM. For the series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=slab-cache-cleanups-5.16
> ---
>  fs/xfs/kmem.h                      |    4 -
>  fs/xfs/libxfs/xfs_alloc.c          |    6 -
>  fs/xfs/libxfs/xfs_alloc_btree.c    |    2 
>  fs/xfs/libxfs/xfs_attr_leaf.c      |    2 
>  fs/xfs/libxfs/xfs_bmap.c           |    6 -
>  fs/xfs/libxfs/xfs_bmap.h           |    2 
>  fs/xfs/libxfs/xfs_bmap_btree.c     |    2 
>  fs/xfs/libxfs/xfs_btree.h          |    4 -
>  fs/xfs/libxfs/xfs_da_btree.c       |    6 -
>  fs/xfs/libxfs/xfs_da_btree.h       |    3 
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
>  fs/xfs/libxfs/xfs_inode_fork.c     |    8 +
>  fs/xfs/libxfs/xfs_inode_fork.h     |    2 
>  fs/xfs/libxfs/xfs_refcount_btree.c |    2 
>  fs/xfs/libxfs/xfs_rmap_btree.c     |    2 
>  fs/xfs/xfs_attr_inactive.c         |    2 
>  fs/xfs/xfs_bmap_item.c             |   12 +-
>  fs/xfs/xfs_bmap_item.h             |    6 -
>  fs/xfs/xfs_buf.c                   |   14 +-
>  fs/xfs/xfs_buf_item.c              |    8 +
>  fs/xfs/xfs_buf_item.h              |    2 
>  fs/xfs/xfs_dquot.c                 |   26 ++--
>  fs/xfs/xfs_extfree_item.c          |   18 +--
>  fs/xfs/xfs_extfree_item.h          |    6 -
>  fs/xfs/xfs_icache.c                |   10 +-
>  fs/xfs/xfs_icreate_item.c          |    6 -
>  fs/xfs/xfs_icreate_item.h          |    2 
>  fs/xfs/xfs_inode.c                 |    2 
>  fs/xfs/xfs_inode.h                 |    2 
>  fs/xfs/xfs_inode_item.c            |    6 -
>  fs/xfs/xfs_inode_item.h            |    2 
>  fs/xfs/xfs_log.c                   |    6 -
>  fs/xfs/xfs_log_priv.h              |    2 
>  fs/xfs/xfs_mru_cache.c             |    2 
>  fs/xfs/xfs_qm.h                    |    2 
>  fs/xfs/xfs_refcount_item.c         |   12 +-
>  fs/xfs/xfs_refcount_item.h         |    6 -
>  fs/xfs/xfs_rmap_item.c             |   12 +-
>  fs/xfs/xfs_rmap_item.h             |    6 -
>  fs/xfs/xfs_super.c                 |  218 ++++++++++++++++++------------------
>  fs/xfs/xfs_trans.c                 |    8 +
>  fs/xfs/xfs_trans.h                 |    2 
>  fs/xfs/xfs_trans_dquot.c           |    4 -
>  43 files changed, 226 insertions(+), 231 deletions(-)
> 

-- 
Carlos

