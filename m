Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8DFC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1CA221473
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgEGMeR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:34:17 -0400
Received: from verein.lst.de ([213.95.11.211]:46296 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgEGMeP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 08:34:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B548768B05; Thu,  7 May 2020 14:34:11 +0200 (CEST)
Date:   Thu, 7 May 2020 14:34:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200507123411.GB17936@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-9-hch@lst.de> <20200501155649.GO40250@bfoster> <20200501160809.GT6742@magnolia> <20200501163809.GA18426@lst.de> <20200501165017.GA20127@lst.de> <20200501182316.GT40250@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501182316.GT40250@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 02:23:16PM -0400, Brian Foster wrote:
> Can we use another dummy parent inode value in xfs_repair? It looks to
> me that we set it to zero in phase 4 if it fails verification and set
> the parent to NULLFSINO (i.e. unknown) in repair's in-core tracking.
> Phase 6 walks the directory entries and explicitly sets the parent inode
> number of entries with an unknown parent (according to the in-core
> tracking). IOW, I don't see where we actually rely on the directory
> header having a parent inode of zero outside of detecting it in the
> custom verifier. If that's the only functional purpose, I wonder if we
> could do something like set the bogus parent field of a sf dir to the
> root inode or to itself, that way the default verifier wouldn't trip
> over it..

I don't think we need a dummy parent at all - we can just skip the
parent validation entirely, which is what my incremental patch does.
