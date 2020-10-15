Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59F4C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 912942224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgJOHym (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:54:42 -0400
Received: from verein.lst.de ([213.95.11.211]:59513 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgJOHym (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Oct 2020 03:54:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C7E3968B05; Thu, 15 Oct 2020 09:54:39 +0200 (CEST)
Date:   Thu, 15 Oct 2020 09:54:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: fix fallocate functions when rtextsize is
 larger than 1
Message-ID: <20201015075439.GI14082@lst.de>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia> <160235127396.1384192.5095447151831725417.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160235127396.1384192.5095447151831725417.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I don't really like the xfs_inode_alloc_blocksize helper, given that
it is very easy to be confused with the allocsize concept.

I'd just add a helper ala:

static bool
xfs_falloc_is_unaligned(
	struct inode		*inode,
	loff_t			offset,
	loff_t			len)
{
	struct xfs_mount	*mp = XFS_I(ip)->i_mount;

	unsigned int blksize_mask = i_blocksize(inode) - 1;

	if (XFS_IS_REALTIME_INODE(XFS_I(ip)))
		blksize_mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;

	return (offset & blksize_mask) || (len & blksize_mask);
}
