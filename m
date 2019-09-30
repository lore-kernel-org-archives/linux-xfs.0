Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC17EC32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 11:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A6E216F4
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 11:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbfI3LKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 07:10:52 -0400
Received: from verein.lst.de ([213.95.11.211]:36441 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbfI3LKw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Sep 2019 07:10:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6CB0068B20; Mon, 30 Sep 2019 13:10:47 +0200 (CEST)
Date:   Mon, 30 Sep 2019 13:10:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/19] xfs: pass two imaps to xfs_reflink_allocate_cow
Message-ID: <20190930111047.GB6987@lst.de>
References: <20190909182722.16783-1-hch@lst.de> <20190909182722.16783-11-hch@lst.de> <20190918172617.GB2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918172617.GB2229799@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:26:17AM -0700, Darrick J. Wong wrote:
> Hmm.  At first I thought this was a behavior change but I think it isn't
> because prior to this patch we'd set cmap = imap and if _allocate_cow
> didn't find a shared extent then it would just return without doing
> anything or touching cmap.  In the !shared case this would just set imap
> to itself pointlessly.
> 
> Now that we pass both imap and cmap to _allocate_cow, in the !shared
> case we don't initialized cmap at all, so adding the @shared check is
> required for correct operation, right?

Exactly.
