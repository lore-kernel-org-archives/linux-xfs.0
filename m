Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E050C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 06:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A88207BC
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 06:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgJEGZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:25:07 -0400
Received: from verein.lst.de ([213.95.11.211]:57789 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgJEGZG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Oct 2020 02:25:06 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2095168B05; Mon,  5 Oct 2020 08:25:03 +0200 (CEST)
Date:   Mon, 5 Oct 2020 08:25:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5.2 3/3] xfs: fix an incore inode UAF in
 xfs_bui_recover
Message-ID: <20201005062502.GA11883@lst.de>
References: <160140142711.830434.5161910313856677767.stgit@magnolia> <160140144660.830434.10498291551366134327.stgit@magnolia> <20201002042236.GV49547@magnolia> <20201002073006.GE9900@lst.de> <20201002162958.GX49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002162958.GX49547@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 09:29:58AM -0700, Darrick J. Wong wrote:
> > Instead of coming up with our own inode unlocking and release schemes,
> > can't we just require that the inode is joinged by passing the lock
> > flags to xfs_trans_ijoin, and piggy back on xfs_trans_commit unlocking
> > it in that case?
> 
> Yes, and let's also xfs_iget(capture_ip->i_ino) to increase the incore
> inode's refcount, which would make it so that the caller would still
> unlock and rele the reference that they got.

Please use ihold(VFS_I(capture_ip)) as that is a lot more efficient.

Can you resend the whole 2 series?  I'm lost with all the incremental
updates for individual patches.
