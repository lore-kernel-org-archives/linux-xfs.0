Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECFCC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 07:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAC7651BC
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 07:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCHHyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 02:54:16 -0500
Received: from verein.lst.de ([213.95.11.211]:54497 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232128AbhCHHxt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 02:53:49 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1A4AA68B02; Mon,  8 Mar 2021 08:53:47 +0100 (CET)
Date:   Mon, 8 Mar 2021 08:53:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 3/4] xfs: force log and push AIL to clear pinned inodes
 when aborting mount
Message-ID: <20210308075346.GB983@lst.de>
References: <161514874040.698643.2749449122589431232.stgit@magnolia> <161514875722.698643.971171271199400538.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161514875722.698643.971171271199400538.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 07, 2021 at 12:25:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we allocate quota inodes in the process of mounting a filesystem but
> then decide to abort the mount, it's possible that the quota inodes are
> sitting around pinned by the log.  Now that inode reclaim relies on the
> AIL to flush inodes, we have to force the log and push the AIL in
> between releasing the quota inodes and kicking off reclaim to tear down
> all the incore inodes.  Do this by extracting the bits we need from the
> unmount path and reusing them.
> 
> This was originally found during a fuzz test of metadata directories
> (xfs/1546), but the actual symptom was that reclaim hung up on the quota
> inodes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
