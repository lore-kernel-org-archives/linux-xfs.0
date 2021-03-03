Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F49C1550E
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA7F864F44
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241957AbhCDARF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:05 -0500
Received: from verein.lst.de ([213.95.11.211]:35367 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355472AbhCCGqj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 01:46:39 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9ECD268B05; Wed,  3 Mar 2021 07:45:56 +0100 (CET)
Date:   Wed, 3 Mar 2021 07:45:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 2/3] xfs: avoid buffer deadlocks in inumbers/bulkstat
Message-ID: <20210303064556.GC7499@lst.de>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia> <161472410813.3421449.1691962515820573818.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472410813.3421449.1691962515820573818.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're servicing an INUMBERS or BULKSTAT request, grab an empty
> transaction so that we don't hit an ABBA buffer deadlock if the inode
> btree contains a cycle.
> 
> Found by fuzzing an inode btree pointer to introduce a cycle into the
> tree (xfs/365).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

So basically you want to piggy back on the per-trans recursion using
xfs_trans_buf_item_match?  Why do we need the sb-counter for that?
Can the comments be a little more clear?  Why don't we want that
elsewhere where we're walking the btrees?
