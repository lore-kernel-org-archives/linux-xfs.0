Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127BEC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 12:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC560233F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 12:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhAMMLA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 07:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbhAMMK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 07:10:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D68C061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 04:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b/xxYPzI/zhlfEkicfJjYJdpXUgUDHaUafdKKwMa3Bc=; b=NuXdkXhXrAoNJ2JYceg1YTB7E2
        GYvz+OZSkVE055Cns02qafjLp6whNzQrpaOcp+DBQUHseePNmpcml0ibh3UcgeEKDueanzzfbsR1X
        vXoOfgfdq948szQCPKo4LRz5NKFnoUPghK4vFjs66MhVHJNuzotoVRGOzVrUV5ABd/IgA+gxR7Hkd
        /nte3L90G8PLVatv1PrbVKOUz2820ulPUZJDUOAV9Xf36c6r59JvVqJqJv54Vf8D27M9rJbGtc165
        Ky8W06L2I5JmxOPlK/QIJhU/iRI4/mXtJjzL1JiF2lJkXC821kqM6mTG1x4W+FbjD+BIEeIU2QLOc
        YXgW5TdQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kzexe-006DwH-Cy; Wed, 13 Jan 2021 12:09:20 +0000
Date:   Wed, 13 Jan 2021 12:09:14 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [RFC PATCH 0/3] Remove mrlock
Message-ID: <20210113120914.GA1482951@infradead.org>
References: <20210113111707.756662-1-nborisov@suse.com>
 <20210113112744.GA1474691@infradead.org>
 <3b68fb68-f11f-1c50-a350-28159c003afe@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b68fb68-f11f-1c50-a350-28159c003afe@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 01:41:09PM +0200, Nikolay Borisov wrote:
> 
> 
> On 13.01.21 ??. 13:27 ??., Christoph Hellwig wrote:
> > Pavel has looked into this before and got stuck on the allocator
> > workqueue offloads:
> > 
> > [PATCH v13 0/4] xfs: Remove wrappers for some semaphores
> 
> I haven't looked into his series but I fail to see how lifting
> rwsemaphore out of the nested structure can change the behavior ? It
> just removes a level of indirection. My patches are semantically
> identical to the original code.

mrlocks have the mr_writer field that annotate that the is a writer
locking the lock.  The XFS asserts use it to assert that the lock that
the current thread holds it for exclusive protection, which isn't
actually what the field says, and this breaks when XFS uses synchronous
execution of work_struct as basically an extension of the kernel stack.
