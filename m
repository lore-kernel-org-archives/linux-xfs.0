Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3230C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 13:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F4C22389F
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 13:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KZjDAj8X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgI0NyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 09:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgI0NyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 09:54:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54283C0613CE;
        Sun, 27 Sep 2020 06:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m5nRCEdly2VlyOmuAaVk76c83K+r5ZovrTQwBtbzY/U=; b=KZjDAj8XYMnXh7iN6ppNAP8p6d
        TWMvDf0aj99iMUpCEqpKTrvObnAb6jvciZc2AhGmQNA66EKx+6yvcrlv4lkKlGANUVtsbXbQ12tBL
        7bHKm+m3J8FksG0AMDQhSafRoUy3CCwiq9iyX0trQfH3Bu3frpDUsJ9v8QKDQBq6macgRdluoI+4B
        W3ZBuRK/smu5wTegIpPSjAWi8pZq3vqWCihIu6dbvpGF1b1rax5x+SaMwsCHJ6BNyr8LJ7PvurJcL
        nR//eBcfXlgADBUQeeUwD2Kp6OD77k/d2a89av8In0VSD4zvDePKng0/NDS/d3RcGd8egqQUTWhR7
        sBkD0bAA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kMX89-0004Rc-JL; Sun, 27 Sep 2020 13:54:21 +0000
Date:   Sun, 27 Sep 2020 14:54:21 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Qian Cai <cai@redhat.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] iomap: Set all uptodate bits for an Uptodate page
Message-ID: <20200927135421.GD7714@casper.infradead.org>
References: <CA+icZUV3aL_7MptHbradtnd8P6X9VO-=Pi2gBezWaZXgeZFMpg@mail.gmail.com>
 <20200924235756.GD32101@casper.infradead.org>
 <CA+icZUWcx5hBjU35tfY=7KXin7cA5AAY8AMKx-pjYnLCsQywGw@mail.gmail.com>
 <CA+icZUWMs5Xz5vMP370uUBCqzgjq6Aqpy+krZMNg-5JRLxaALA@mail.gmail.com>
 <20200925134608.GE32101@casper.infradead.org>
 <CA+icZUV9tNMbTC+=MoKp3rGmhDeO9ScW7HC+WUTCCvSMpih7DA@mail.gmail.com>
 <20200925155340.GG32101@casper.infradead.org>
 <CA+icZUWmF_7P7r-qmxzR7oz36u_Wy5HA6fh5zFFZd1D-aZiwkQ@mail.gmail.com>
 <20200927120435.GC7714@casper.infradead.org>
 <CA+icZUWSHf9YbkuEYeG4azSrPt=GYu-MmHxj3+uGvxPW-HHjjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWSHf9YbkuEYeG4azSrPt=GYu-MmHxj3+uGvxPW-HHjjQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 03:48:39PM +0200, Sedat Dilek wrote:
> With your patch and assertion diff I hit the same issue like with Ext4-FS...
> 
> [So Sep 27 15:40:18 2020] run fstests generic/095 at 2020-09-27 15:40:19
> [So Sep 27 15:40:26 2020] XFS (sdb1): Mounting V5 Filesystem
> [So Sep 27 15:40:26 2020] XFS (sdb1): Ending clean mount
> [So Sep 27 15:40:26 2020] xfs filesystem being mounted at /mnt/scratch
> supports timestamps until 2038 (0x7fffffff)
> [So Sep 27 15:40:28 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:28 2020] File: /mnt/scratch/file1 PID: 12 Comm: kworker/0:1
> [So Sep 27 15:40:29 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:29 2020] File: /mnt/scratch/file1 PID: 73 Comm: kworker/0:2
> [So Sep 27 15:40:30 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:30 2020] File: /mnt/scratch/file2 PID: 12 Comm: kworker/0:1
> [So Sep 27 15:40:30 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:30 2020] File: /mnt/scratch/file2 PID: 3271 Comm: fio
> [So Sep 27 15:40:30 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:30 2020] File: /mnt/scratch/file2 PID: 3273 Comm: fio
> [So Sep 27 15:40:31 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:31 2020] File: /mnt/scratch/file1 PID: 3308 Comm: fio
> [So Sep 27 15:40:36 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:36 2020] File: /mnt/scratch/file1 PID: 73 Comm: kworker/0:2
> [So Sep 27 15:40:43 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:43 2020] File: /mnt/scratch/file1 PID: 73 Comm: kworker/0:2
> [So Sep 27 15:40:52 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:52 2020] File: /mnt/scratch/file2 PID: 73 Comm: kworker/0:2
> [So Sep 27 15:40:56 2020] Page cache invalidation failure on direct
> I/O.  Possible data corruption due to collision with buffered I/O!
> [So Sep 27 15:40:56 2020] File: /mnt/scratch/file2 PID: 12 Comm: kworker/0:1
> 
> Is that a different issue?

The test is expected to emit those messages; userspace has done something
so utterly bonkers (direct I/O to an mmaped, mlocked page) that we can't
provide the normal guarantees of data integrity.
