Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FD2C48BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 09:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2960861406
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 09:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhFJJJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 05:09:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbhFJJJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 05:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623316024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=361/Mv7Fre9yzH+UkaH8Am6n4w1iJ449u+nGkGfSsgU=;
        b=ERBgHfqneTUTF/izPs8m4bWArhZ/KsiUfWNCMTkhqaaS7Bm8BUQfFRZR1NCBBOWo2gLm6w
        oJYrnnamOcm9JZsYXh0kiFRJ4KknRdYmv3A4Z4GsShDN//rGMbX/nL6sb1abG4gT1H0Wb/
        BgDnq9YJc/OieuX+eC2FQWK+gcPgBHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-5j4c0fCIN22TQ8P_CUs7aw-1; Thu, 10 Jun 2021 05:07:03 -0400
X-MC-Unique: 5j4c0fCIN22TQ8P_CUs7aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFD06185060A;
        Thu, 10 Jun 2021 09:06:59 +0000 (UTC)
Received: from T590 (ovpn-13-145.pek2.redhat.com [10.72.13.145])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0092660917;
        Thu, 10 Jun 2021 09:06:46 +0000 (UTC)
Date:   Thu, 10 Jun 2021 17:06:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, ceph-devel@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Steve French <sfrench@samba.org>, Ted Tso <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 01/14] mm: Fix comments mentioning i_mutex
Message-ID: <YMHWIcbnLPW5AfiC@T590>
References: <20210607144631.8717-1-jack@suse.cz>
 <20210607145236.31852-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607145236.31852-1-jack@suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 04:52:11PM +0200, Jan Kara wrote:
> inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
> comments still mentioning i_mutex.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

...

> diff --git a/mm/rmap.c b/mm/rmap.c
> index 693a610e181d..a35cbbbded0d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -20,9 +20,9 @@
>  /*
>   * Lock ordering in mm:
>   *
> - * inode->i_mutex	(while writing or truncating, not reading or faulting)
> + * inode->i_rwsem	(while writing or truncating, not reading or faulting)
>   *   mm->mmap_lock
> - *     page->flags PG_locked (lock_page)   * (see huegtlbfs below)
> + *     page->flags PG_locked (lock_page)   * (see hugetlbfs below)
>   *       hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share)
>   *         mapping->i_mmap_rwsem
>   *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
> @@ -41,7 +41,7 @@
>   *                             in arch-dependent flush_dcache_mmap_lock,
>   *                             within bdi.wb->list_lock in __sync_single_inode)
>   *
> - * anon_vma->rwsem,mapping->i_mutex      (memory_failure, collect_procs_anon)
> + * anon_vma->rwsem,mapping->i_mmap_rwsem   (memory_failure, collect_procs_anon)

This one looks a typo.

-- 
Ming

