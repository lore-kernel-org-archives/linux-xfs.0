Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEAECA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67C8520717
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfKEBgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:36:01 -0500
Received: from verein.lst.de ([213.95.11.211]:42467 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387416AbfKEBgA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 20:36:00 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D47DF68BE1; Tue,  5 Nov 2019 02:35:58 +0100 (CET)
Date:   Tue, 5 Nov 2019 02:35:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/34] xfs: refactor btree node scrubbing
Message-ID: <20191105013558.GA32531@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-3-hch@lst.de> <20191104183617.GC4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104183617.GC4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 10:36:18AM -0800, Darrick J. Wong wrote:
> Seeing as this function returns a pointer to struct xfs_attr_leaf_entry,
> why not clean this up to:
> 
> ent = xfs_attr3_leaf_entryp(...)[blk->index]; ?

Well, it should really be xfs_attr3_leaf_entryp + blk->index.  But
otherwise agreed and fixed up for the next version.
