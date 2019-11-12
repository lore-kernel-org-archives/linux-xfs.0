Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FB9C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 14:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5F5F21D7F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 14:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfKLOQE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 09:16:04 -0500
Received: from verein.lst.de ([213.95.11.211]:56042 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfKLOQE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Nov 2019 09:16:04 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3095168BE1; Tue, 12 Nov 2019 15:16:01 +0100 (CET)
Date:   Tue, 12 Nov 2019 15:16:00 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, y2038@lists.linaro.org,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 1/5] xfs: [variant A] avoid time_t in user api
Message-ID: <20191112141600.GB10922@lst.de>
References: <20191112120910.1977003-1-arnd@arndb.de> <20191112120910.1977003-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112120910.1977003-2-arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 01:09:06PM +0100, Arnd Bergmann wrote:
> However, as long as two observations are true, a much simpler solution
> can be used:
> 
> 1. xfsprogs is the only user space project that has a copy of this header

We can't guarantee that.

> 2. xfsprogs already has a replacement for all three affected ioctl commands,
>    based on the xfs_bulkstat structure to pass 64-bit timestamps
>    regardless of the architecture

XFS_IOC_BULKSTAT replaces XFS_IOC_FSBULKSTAT directly, and can replace
XFS_IOC_FSBULKSTAT_SINGLE indirectly, so that is easy.  Most users
actually use the new one now through libfrog, although I found a user
of the direct ioctl in the xfs_io tool, which could easily be fixed as
well.

XFS_IOC_SWAPEXT does not have a direct replacement, but the timestamp
is only used to verify that the file did not change vs the previous
stat.  So not being able to represent > 2038 times is not a real
problem anyway.

At some point we should probably look into a file system independent
defrag ioctl anyway, at which point we can deprecate XFS_IOC_SWAPEXT.

> Based on those assumptions, changing xfs_bstime to use __kernel_long_t
> instead of time_t in both the kernel and in xfsprogs preserves the current
> ABI for any libc definition of time_t and solves the problem of passing
> 64-bit timestamps to 32-bit user space.

As said above their are not entirely true, but I still think this patch
is the right thing to do, if only to get the time_t out of the ABI..

Reviewed-by: Christoph Hellwig <hch@lst.de>
