Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6DAC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B25520727
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfKRGZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 01:25:07 -0500
Received: from verein.lst.de ([213.95.11.211]:54951 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfKRGZH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Nov 2019 01:25:07 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 892DE68B05; Mon, 18 Nov 2019 07:25:05 +0100 (CET)
Date:   Mon, 18 Nov 2019 07:25:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/9] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191118062505.GB4335@lst.de>
References: <20191116182214.23711-1-hch@lst.de> <20191116182214.23711-3-hch@lst.de> <20191117183521.GT6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117183521.GT6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 17, 2019 at 10:35:21AM -0800, Darrick J. Wong wrote:
> On Sat, Nov 16, 2019 at 07:22:07PM +0100, Christoph Hellwig wrote:
> > Use a flags argument with the XFS_DABUF_MAP_HOLE_OK flag to signal that
> > a hole is okay and not corruption, and return -ENOENT instead of the
> > nameless -1 to signal that case in the return value.
> 
> Why not set *nirecs = 0 and return 0 like we sometimes do for bmap
> lookups?

Sure, I can change it to that for the next version.
