Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664DFC433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 11:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27423233EA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 11:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbhAML3M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 06:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbhAML3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 06:29:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE4CC06179F
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 03:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=toDcTckO0G+UnlwpRKGV1M/10SRxhKAzu72COkp3bTk=; b=fj/5kf6S0NMGkWE0gYEnJ3ww7w
        k4k13UUVZcQruG9CGMRkhPISZu3cNPAi6nFYNhH9pq/STCU5PRjr/DsMd8DD/82TiSbjVE7bqz2hK
        8Y/To+On3iuPnxdepER5gIkCkKD2NAyWQLP0PR1iGWVpvmkfzrC4WQMecWOempChCDobxkEkGuG6W
        w+IMlS2zlnq6Xlr8c7kY7qktlNNl2TsYAujKahuKDQrzuuhnviF0W1guZpj2GzaJz9kKTAN7w0Z2H
        FlT5feweBWuewKh5ZeoY9XIFjXJrY5Hwu8l/6/eFFN8++0lc2ZGzmJeaRskdt6TPw41fDWvWng9p3
        W+9D8DyQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kzeJU-006Bi4-CO; Wed, 13 Jan 2021 11:28:08 +0000
Date:   Wed, 13 Jan 2021 11:27:44 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Nikolay Borisov <nborisov@suse.com>,
        Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [RFC PATCH 0/3] Remove mrlock
Message-ID: <20210113112744.GA1474691@infradead.org>
References: <20210113111707.756662-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113111707.756662-1-nborisov@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Pavel has looked into this before and got stuck on the allocator
workqueue offloads:

[PATCH v13 0/4] xfs: Remove wrappers for some semaphores

On Wed, Jan 13, 2021 at 01:17:03PM +0200, Nikolay Borisov wrote:
> This series removes mrlock_t and directly replaces i_lock and i_mmaplock with
> rw_semaphore in xfs_inode. My end game with this is to eventually lift i_mmaplock
> in VFS and use it from there. The necessity for the latter came up since BTRFS
> is also about to get its own private version of i_mmaplock for the same use case.
> This  will mean that all 3 major filesystems on linux (ext4/xfs/btrfs) wil share
> the same lock. Christoph naturally suggested for the lock to be lifted to VFS.
> 
> Before proceeding with this work I'd like to get the opinion of XFS developers
> whether doing that is acceptable for them. I've heard that Dave wants to eventually
> convert the mmapsem to a range lock for XFS and implement a callback mechanism
> for VFS to call into every filesystem...
> 
> I've only compile tested this and also the way the rwsem is checked for write
> is admittedly a bit hackish but it can easily be changed to utilize lockdep.
> I'm aware of https://lore.kernel.org/linux-xfs/20201102194135.174806-1-preichl@redhat.com/
> but frankly that series went too far up to rev 10 which is a bit mind boggling...
> 
> Nikolay Borisov (3):
>   xfs: Add is_rwsem_write_locked function
>   xfs: Convert i_lock/i_mmaplock to  rw_semaphore
>   xfs: Remove mrlock
> 
>  fs/xfs/mrlock.h          | 78 ----------------------------------------
>  fs/xfs/xfs_inode.c       | 48 ++++++++++++++-----------
>  fs/xfs/xfs_inode.h       |  6 ++--
>  fs/xfs/xfs_linux.h       |  1 -
>  fs/xfs/xfs_qm_syscalls.c |  2 +-
>  fs/xfs/xfs_super.c       |  7 ++--
>  6 files changed, 34 insertions(+), 108 deletions(-)
>  delete mode 100644 fs/xfs/mrlock.h
> 
> --
> 2.25.1
> 
---end quoted text---
