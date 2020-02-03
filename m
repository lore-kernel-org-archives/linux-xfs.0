Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A64C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C17C2086A
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgBCRrp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:47:45 -0500
Received: from verein.lst.de ([213.95.11.211]:57194 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbgBCRrp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Feb 2020 12:47:45 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 01C1968B20; Mon,  3 Feb 2020 18:47:42 +0100 (CET)
Date:   Mon, 3 Feb 2020 18:47:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct
 xfs_agfl
Message-ID: <20200203174742.GA20176@lst.de>
References: <20200130133343.225818-1-hch@lst.de> <20200130133343.225818-2-hch@lst.de> <28df721b-a351-23b7-6e66-a777215fe1b6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28df721b-a351-23b7-6e66-a777215fe1b6@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 11:46:11AM -0600, Eric Sandeen wrote:
> On 1/30/20 7:33 AM, Christoph Hellwig wrote:
> > struct xfs_agfl is a header in front of the AGFL entries that exists
> > for CRC enabled file systems.  For not CRC enabled file systems the AGFL
> > is simply a list of agbno.  Make the CRC case similar to that by just
> > using the list behind the new header.  This indirectly solves a problem
> > with modern gcc versions that warn about taking addresses of packed
> > structures (and we have to pack the AGFL given that gcc rounds up
> > structure sizes).  Also replace the helper macro to get from a buffer
> > with an inline function in xfs_alloc.h to make the code easier to
> > read.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I like it.
> 
> Giving it an RVB but are we 100% sure that there won't ever be any padding
> after the xfs_agfl structure before the bno?  I don't understand gcc
> alignment magic.

That is at least the definition of __attribute__((packed))..
