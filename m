Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C30CC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 15:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03A0D206E3
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 15:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgGUPGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 11:06:20 -0400
Received: from verein.lst.de ([213.95.11.211]:52542 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgGUPGT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Jul 2020 11:06:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EC46568B05; Tue, 21 Jul 2020 17:06:15 +0200 (CEST)
Date:   Tue, 21 Jul 2020 17:06:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Dave Chinner <david@fromorbit.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: RFC: iomap write invalidation
Message-ID: <20200721150615.GA10330@lst.de>
References: <20200713074633.875946-1-hch@lst.de> <20200720215125.bfz7geaftocy4r5l@fiona> <20200721145313.GA9217@lst.de> <20200721150432.GH15516@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721150432.GH15516@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 21, 2020 at 04:04:32PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 21, 2020 at 04:53:13PM +0200, Christoph Hellwig wrote:
> > On Mon, Jul 20, 2020 at 04:51:25PM -0500, Goldwyn Rodrigues wrote:
> > > Hi Christoph,
> > > 
> > > On  9:46 13/07, Christoph Hellwig wrote:
> > > > Hi all,
> > > > 
> > > > this series has two parts:  the first one picks up Dave's patch to avoid
> > > > invalidation entierly for reads, picked up deep down from the btrfs iomap
> > > > thread.  The second one falls back to buffered writes if invalidation fails
> > > > instead of leaving a stale cache around.  Let me know what you think about
> > > > this approch.
> > > 
> > > Which kernel version are these changes expected?
> > > btrfs dio switch to iomap depends on this.
> > 
> > No idea.  Darrick, are you ok with picking this up soon so that
> > Goldwyn can pull it in?
> 
> I thought you were going to respin this with EREMCHG changed to ENOTBLK?

Oh, true.  I'll do that ASAP.
