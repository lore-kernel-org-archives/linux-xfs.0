Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C656C47404
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 07:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B2BF20882
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 07:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbfJNHTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 03:19:19 -0400
Received: from verein.lst.de ([213.95.11.211]:47579 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729928AbfJNHTT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Oct 2019 03:19:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A3AD768CFC; Mon, 14 Oct 2019 09:19:16 +0200 (CEST)
Date:   Mon, 14 Oct 2019 09:19:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: ignore extent size hints for always COW inodes
Message-ID: <20191014071916.GE10081@lst.de>
References: <20191011130316.13373-1-hch@lst.de> <20191011130316.13373-3-hch@lst.de> <20191012003226.GN13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012003226.GN13108@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 05:32:26PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2019 at 06:03:16AM -0700, Christoph Hellwig wrote:
> > There is no point in applying extent size hints for always COW inodes,
> > as we would just have to COW any extra allocation beyond the data
> > actually written.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, I guess?
> 
> By the way, what's the plan for always_cow inodes, seeing as it's still
> only a debugging feature?

Support for zoned devices and an O_ATOMIC-like mode that supports
data integrity safe overwrites.  I've found some time to spend on
both lately, but the former might land on the list first.
