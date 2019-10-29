Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE4FCA9EC2
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF3F20862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfJ2H5R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 03:57:17 -0400
Received: from verein.lst.de ([213.95.11.211]:38630 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfJ2H5R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 03:57:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C9BC68AFE; Tue, 29 Oct 2019 08:57:15 +0100 (CET)
Date:   Tue, 29 Oct 2019 08:57:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: remove the extsize argument to
 xfs_eof_alignment
Message-ID: <20191029075715.GC18999@lst.de>
References: <20191025150336.19411-1-hch@lst.de> <20191025150336.19411-4-hch@lst.de> <20191028160638.GC15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028160638.GC15222@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:06:38AM -0700, Darrick J. Wong wrote:
> Why does it make more sense to do the inode extsize roundup only for
> direct writes and not as an intermediate step of determining the
> speculative preallocation size than what the code does now?

No behavior change in this patch.  xfs_buffered_write_iomap_begin
already passes a 0 extsize to xfs_eof_alignment, making the code moved
from xfs_eof_alignment to xfs_iomap_eof_align_last_fsb a no-op for
the buffered write path.
