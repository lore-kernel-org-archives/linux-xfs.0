Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01B2C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 17:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B77523B31
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 17:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbhANRaC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:30:02 -0500
Received: from verein.lst.de ([213.95.11.211]:36715 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbhANRaB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 12:30:01 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8474A68B02; Thu, 14 Jan 2021 18:29:18 +0100 (CET)
Date:   Thu, 14 Jan 2021 18:29:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        avi@scylladb.com
Subject: Re: [PATCH 09/10] iomap: add a IOMAP_DIO_NOALLOC flag
Message-ID: <20210114172918.GB30826@lst.de>
References: <20210112162616.2003366-1-hch@lst.de> <20210112162616.2003366-10-hch@lst.de> <20210112232923.GD331610@dread.disaster.area> <20210113153215.GA1284163@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113153215.GA1284163@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 10:32:15AM -0500, Brian Foster wrote:
> Something I hadn't thought about before is whether applications might
> depend on current unaligned dio serialization for coherency and thus
> break if the kernel suddenly allows concurrent unaligned dio to pass
> through. Should this be something that is explicitly requested by
> userspace?

direct I/O has always been documented as not being synchronized.  Also
for block devices you won't get any synchronization at all, down to
the sector level.

> 
> That aside, I agree that the DIO_UNALIGNED approach seems a bit more
> clear than NOALLOC, but TBH the more I look at this the more Christoph's
> first approach seems cleanest to me. It is a bit unfortunate to
> duplicate the mapping lookups and have the extra ILOCK cycle, but the
> lock is shared and only taken when I/O is unaligned. I don't really see
> why that is a show stopper yet it's acceptable to fall back to exclusive
> dio if the target range happens to be discontiguous (but otherwise
> mapped/written).

I think both approaches have pros an cons.  My original one (which really
is yours as you suggested it) has the advantage of having a much simpler
structure, and not limititing the non-exclusive I/O to a single extent.
The refined version of Dave's approach avoids the extra one or two extent
lookups, and any knowledge of extent state above the iomap layer.
