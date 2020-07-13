Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEC1C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF3F206F0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgGMQKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:10:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:36262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgGMQKU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Jul 2020 12:10:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FFF9B66C;
        Mon, 13 Jul 2020 16:10:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4DADDDA809; Mon, 13 Jul 2020 18:09:57 +0200 (CEST)
Date:   Mon, 13 Jul 2020 18:09:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: fall back to buffered writes for invalidation
 failures
Message-ID: <20200713160957.GM3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20200713074633.875946-1-hch@lst.de>
 <20200713074633.875946-3-hch@lst.de>
 <20200713122050.okus7qlampk5ysyb@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713122050.okus7qlampk5ysyb@fiona>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 07:20:50AM -0500, Goldwyn Rodrigues wrote:
> On  9:46 13/07, Christoph Hellwig wrote:
> > Failing to invalid the page cache means data in incoherent, which is
> > a very bad state for the system.  Always fall back to buffered I/O
> > through the page cache if we can't invalidate mappings.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks. This will help btrfs. The current next tree contains the iomap
> changes I recomended and would need to be reverted in order to
> incorporate this. Once this is in the next tree I will (re)format the
> btrfs iomap dio patches.

Patches in next don't need to be reverted, if you put together a branch
with any iomap or other prep patches + btrfs iomap-dio I'll replace it
in the for-next snapshot I push.
