Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4489FC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 17:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B09520725
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 17:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgEGRTA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 13:19:00 -0400
Received: from verein.lst.de ([213.95.11.211]:47895 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgEGRTA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 13:19:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D9AD568B05; Thu,  7 May 2020 19:18:57 +0200 (CEST)
Date:   Thu, 7 May 2020 19:18:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200507171857.GA4136@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-9-hch@lst.de> <20200501155649.GO40250@bfoster> <20200501160809.GT6742@magnolia> <20200501163809.GA18426@lst.de> <20200501165017.GA20127@lst.de> <20200501182316.GT40250@bfoster> <20200507123411.GB17936@lst.de> <20200507134355.GF9003@bfoster> <20200507162846.GG9003@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507162846.GG9003@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 12:28:46PM -0400, Brian Foster wrote:
> To demonstrate, I hacked on repair a bit using an fs with an
> intentionally corrupted shortform parent inode and had to make the
> following tweaks to work around the custom fork verifier. The
> ino_discovery checks were added because phases 3 and 4 toggle that flag
> such that the former clears the parent value in the inode, but the
> latter actually updates the external parent tracking. IOW, setting a
> "valid" inode in phase 3 would otherwise trick phase 4 into using it.
> I'd probably try to think of something cleaner for that issue if we were
> to take such an approach.

Ok, so instead of clearing the parent we'll set it to a guaranteed good
value (the root ino).  That could kill the workaround I had entirely.
