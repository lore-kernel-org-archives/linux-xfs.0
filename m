Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD67AC3A59B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92B4221773
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbfHSE3J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 00:29:09 -0400
Received: from verein.lst.de ([213.95.11.211]:44213 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfHSE3I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 00:29:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A4A0768B02; Mon, 19 Aug 2019 06:29:05 +0200 (CEST)
Date:   Mon, 19 Aug 2019 06:29:05 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190819042905.GA15613@lst.de>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com> <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de> <20190818173426.GA32311@lst.de> <20190819000831.GX6129@dread.disaster.area> <20190819034948.GA14261@lst.de> <20190819041132.GA14492@lst.de> <20190819042259.GZ6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819042259.GZ6129@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 02:22:59PM +1000, Dave Chinner wrote:
> That implies a kmalloc heap issue.
> 
> Oh, is memory poisoning or something that modifies the alignment of
> slabs turned on?
> 
> i.e. 4k/8k allocations from the kmalloc heap slabs might not be
> appropriately aligned for IO, similar to the problems we have with
> the xen blk driver?

That is what I suspect, and as you can see in the attached config I
usually run with slab debuggig on.
