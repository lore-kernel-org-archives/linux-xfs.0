Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962A0C3524A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7250520674
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDGPs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:15:48 -0500
Received: from verein.lst.de ([213.95.11.211]:59432 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgBDGPs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 01:15:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9ABBD68BFE; Tue,  4 Feb 2020 07:15:46 +0100 (CET)
Date:   Tue, 4 Feb 2020 07:15:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 6/6] xfs: remove XFS_BUF_TO_SBP
Message-ID: <20200204061546.GA31878@lst.de>
References: <20200130133343.225818-1-hch@lst.de> <20200130133343.225818-7-hch@lst.de> <d965fc02-1fa6-c52c-9d91-7803ac77a824@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d965fc02-1fa6-c52c-9d91-7803ac77a824@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 12:38:34PM -0600, Eric Sandeen wrote:
> > @@ -707,7 +707,7 @@ xfs_sb_read_verify(
> >  	 * Check all the superblock fields.  Don't byteswap the xquota flags
> >  	 * because _verify_common checks the on-disk values.
> >  	 */
> > -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> > +	__xfs_sb_from_disk(&sb, bp->b_addr, false);
> 
> why not dsb here

Yes, this should just pass dsb.

> In any case seems like if you already have a local xfs_dsb, use that vs.
> bp->b_addr?

That was the planned, but I obviously missed one spot.
