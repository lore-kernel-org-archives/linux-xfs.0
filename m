Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741FAC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 11:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C8A5207CD
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 11:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGNLA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 07:00:59 -0400
Received: from verein.lst.de ([213.95.11.211]:53826 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgGNLA7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Jul 2020 07:00:59 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2343368CFC; Tue, 14 Jul 2020 13:00:56 +0200 (CEST)
Date:   Tue, 14 Jul 2020 13:00:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: fall back to buffered writes for
 invalidation failures
Message-ID: <20200714110055.GC16178@lst.de>
References: <20200713074633.875946-1-hch@lst.de> <20200713074633.875946-3-hch@lst.de> <20200713153920.GU7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713153920.GU7606@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 08:39:20AM -0700, Darrick J. Wong wrote:
> -ENOTBLK is already being used as a "magic" return code that means
> "retry this direct write as a buffered write".  Shouldn't we use that
> instead?
> 
> -EREMCHG was a private hack we put in XFS for the one case where a
> direct write had to be done through the page cache (non block-aligned
> COW), but maybe it's time we put that to rest since the rest of the
> world apparently thinks the magic fallback code is -ENOTBLK.

Sure, I can switch the error code.
