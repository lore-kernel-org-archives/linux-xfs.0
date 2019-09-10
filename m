Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D122AC4740A
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 14:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCB621479
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 14:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfIJOkD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 10:40:03 -0400
Received: from verein.lst.de ([213.95.11.211]:59711 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbfIJOkC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Sep 2019 10:40:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3CA7468AFE; Tue, 10 Sep 2019 16:39:59 +0200 (CEST)
Date:   Tue, 10 Sep 2019 16:39:59 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Goldwyn Rodrigues <RGoldwyn@suse.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 07/19] iomap: use a srcmap for a read-modify-write I/O
Message-ID: <20190910143959.GB6794@lst.de>
References: <20190909182722.16783-1-hch@lst.de> <20190909182722.16783-8-hch@lst.de> <1568119693.12944.16.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568119693.12944.16.camel@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 10, 2019 at 12:48:14PM +0000, Goldwyn Rodrigues wrote:
> > +	if (srcmap.type)
> > +		end = min(end, srcmap.offset + srcmap.length);
> > +	if (pos + length > end)
> > +		length = end - pos;
> >  
> 
> 
> Yes, that looks more correct. However, can we be smart and not bother
> setting the minimum of end and srcmap.offset + srcmap.length if it is
> not required? ie in situations where end coincides with block boundary.
>  Or if srcmap.length falls short, until the last block boundary of
> iomap? 
> 
> I did think about this scenario. This case is specific to CoW and
> thought this is best handled by filesystem's iomap_begin(). If this
> goes in, the filesystems would have to "falsify" srcmap length
> information to maximize the amount of I/O that goes in one iteration.

The problem is really that we can easily run over the srcmap (that's
what happened to me with XFS..)  One thing you've done in btrfs that
I haven't done yet in XFS is to simply not bother with filling out
the srcmap if we don't need to (that is if the iteration is fully
page aligned in your patch set - the unshare op in this series will
complicate things a little).  With that optimization the only case
where the shortening of the iteration that matters is if the start
is unaligned and needs a read-modify-write cycle, but the end is
aligned and beyond the end of the srcmap.  Is that such an important
case?

> 
> -- 
> Goldwyn---end quoted text---
