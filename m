Return-Path: <SRS0=K1zF=AH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6620AC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 15:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4155F206E9
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 15:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITmZ3eR9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgFZPCm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Jun 2020 11:02:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725836AbgFZPCm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jun 2020 11:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593183761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fHKbqpiGBYPXJ+14sGPnxiW9V8XsYSBUqlw0hE9Dm9c=;
        b=ITmZ3eR9zqY5p2WjvBCT6OwZYgqDIwV+4Ds2rRDQYgEld5IMYkosn0XQ/AoLZnaJlh2ekU
        rSsCSiGB/iAa10PBvRZyeszxwrW9dDiJacbpXxdGwQFBnc/aUNqOnLT4Koh/45KPKulwbp
        +uRRa2TL4qr13IpPbo2+/1Q+adXAzUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-6Os_ZGzQM0a4ZkBmt1xVMw-1; Fri, 26 Jun 2020 11:02:27 -0400
X-MC-Unique: 6Os_ZGzQM0a4ZkBmt1xVMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E290464;
        Fri, 26 Jun 2020 15:02:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99A9A60F8A;
        Fri, 26 Jun 2020 15:02:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05QF2MDr012492;
        Fri, 26 Jun 2020 11:02:22 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05QF2J5i012464;
        Fri, 26 Jun 2020 11:02:21 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 26 Jun 2020 11:02:19 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
Message-ID: <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200625113122.7540-1-willy@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi

I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
prevents both filesystem recursion and i/o recursion.

Note that any I/O can recurse into a filesystem via the loop device, thus 
it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
and PF_MEMALLOC_NOIO is not set.

Mikulas

On Thu, 25 Jun 2020, Matthew Wilcox (Oracle) wrote:

> I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
> for an upcoming patch series, and Jens also wants it for non-blocking
> io_uring.  It turns out we already have dm-bufio which could benefit
> from memalloc_nowait, so it may as well go into the tree now.
> 
> The biggest problem is that we're basically out of PF_ flags, so we need
> to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
> out the PF_ flags are really supposed to be used for flags which are
> accessed from other tasks, and the MEMALLOC flags are only going to
> be used by this task.  So shuffling everything around frees up some PF
> flags and generally makes the world a better place.
> 
> Patch series also available from
> http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc
> 
> Matthew Wilcox (Oracle) (6):
>   mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
>   mm: Add become_kswapd and restore_kswapd
>   xfs: Convert to memalloc_nofs_save
>   mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
>   mm: Replace PF_MEMALLOC_NOIO with memalloc_nocma
>   mm: Add memalloc_nowait
> 
>  drivers/block/loop.c           |  3 +-
>  drivers/md/dm-bufio.c          | 30 ++++--------
>  drivers/md/dm-zoned-metadata.c |  5 +-
>  fs/iomap/buffered-io.c         |  2 +-
>  fs/xfs/kmem.c                  |  2 +-
>  fs/xfs/libxfs/xfs_btree.c      | 14 +++---
>  fs/xfs/xfs_aops.c              |  4 +-
>  fs/xfs/xfs_buf.c               |  2 +-
>  fs/xfs/xfs_linux.h             |  6 ---
>  fs/xfs/xfs_trans.c             | 14 +++---
>  fs/xfs/xfs_trans.h             |  2 +-
>  include/linux/sched.h          |  7 +--
>  include/linux/sched/mm.h       | 84 ++++++++++++++++++++++++++--------
>  kernel/sys.c                   |  8 ++--
>  mm/vmscan.c                    | 16 +------
>  15 files changed, 105 insertions(+), 94 deletions(-)
> 
> -- 
> 2.27.0
> 

