Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4FAC04A68
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 11:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiG1LKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 07:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbiG1LKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 07:10:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149A8248D9;
        Thu, 28 Jul 2022 04:10:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4205F20767;
        Thu, 28 Jul 2022 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659006618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ch7OpJ9togQrcIvktUHsyLTlf/K2VFQcctastF2/ugA=;
        b=FCWtvrX0enwGt/24CACMuJlboGjfqQhB9CUh53r1V4R7Q+P2f8G/Rz2cOKMtCEqqMhF4ac
        cVrAELjWf+1zwF57+XpH1ipr3AaAAOzR1+WOfzMSgaY0O0ZcLK3avwiSxXAwmXK490k04D
        ulOVOEKQ8Td6kbdIiLNEKwHL5adoNy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659006618;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ch7OpJ9togQrcIvktUHsyLTlf/K2VFQcctastF2/ugA=;
        b=FUh7NyixVBdFFcjpzMMwj8qKd7dO71QTdNpxiDnX9HMHCJw+QKu+crfxmuo1KD6WUwxksP
        MjXSLHlpxT0XUMAA==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 97F522C141;
        Thu, 28 Jul 2022 11:10:17 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 4F4C9A0668; Thu, 28 Jul 2022 13:10:16 +0200 (CEST)
Date:   Thu, 28 Jul 2022 13:10:16 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>
Subject: Re: remove iomap_writepage v2
Message-ID: <20220728111016.uwbaywprzkzne7ib@quack3>
References: <20220719041311.709250-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719041311.709250-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph!

On Tue 19-07-22 06:13:07, Christoph Hellwig wrote:
> this series removes iomap_writepage and it's callers, following what xfs
> has been doing for a long time.

So this effectively means "no writeback from page reclaim for these
filesystems" AFAICT (page migration of dirty pages seems to be handled by
iomap_migrate_page()) which is going to make life somewhat harder for
memory reclaim when memory pressure is high enough that dirty pages are
reaching end of the LRU list. I don't expect this to be a problem on big
machines but it could have some undesirable effects for small ones
(embedded, small VMs). I agree per-page writeback has been a bad idea for
efficiency reasons for at least last 10-15 years and most filesystems
stopped dealing with more complex situations (like block allocation) from
->writepage() already quite a few years ago without any bug reports AFAIK.
So it all seems like a sensible idea from FS POV but are MM people on board
or at least aware of this movement in the fs land?

Added a few CC's for that.

								Honza

> Changes since v1:
>  - clean up a printk in gfs2
> 
> Diffstat:
>  fs/gfs2/aops.c         |   26 --------------------------
>  fs/gfs2/log.c          |    5 ++---
>  fs/iomap/buffered-io.c |   15 ---------------
>  fs/zonefs/super.c      |    8 --------
>  include/linux/iomap.h  |    3 ---
>  5 files changed, 2 insertions(+), 55 deletions(-)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
