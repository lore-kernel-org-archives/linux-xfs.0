Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F9AC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 149CD61423
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhDUG0t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 02:26:49 -0400
Received: from verein.lst.de ([213.95.11.211]:53140 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234077AbhDUG0t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 02:26:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C07B368BFE; Wed, 21 Apr 2021 08:26:14 +0200 (CEST)
Date:   Wed, 21 Apr 2021 08:26:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: RFC: don't allow disabling quota accounting on a mounted file
 system
Message-ID: <20210421062614.GA29662@lst.de>
References: <20210420072256.2326268-1-hch@lst.de> <20210420173634.GO3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420173634.GO3122264@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 10:36:34AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 20, 2021 at 09:22:54AM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > disabling quota accounting (vs just enforcement) on a running file system
> > is a fundamentally race and hard to get right operation.  It also has
> > very little practical use.
> > 
> > This causes xfs/007 xfs/106 xfs/220 xfs/304 xfs/305 to fail, as they
> > specifically test this functionality.
> 
> What kind of failures do you get now?  Are they all a result of the
> _ACCT flags never going away?  Which I guess means that tests expecting
> to get ENOSYS after you turn off _ACCT will now no longer error out?

Sort of.  Snipplets of the errors:

xfs/007:

 core.nblocks = 1
 *** turn off ug quotas
+XFS_QUOTARM: Invalid argument
 *** umount
 *** Usage after quotarm ***
-core.nblocks = 0
-core.nblocks = 0
+core.nblocks = 1
+core.nblocks = 1

xfs/106:

-User quota are not enabled on SCRATCH_DEV
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode: #131 (2 blocks, 2 extents)
+Blocks grace time: [3 days 01:00:00]

xfs/220:

+XFS_QUOTARM: Invalid argument

xfs/304:

 *** turn off project quotas
+Quota already off.
 *** umount

xfs/305:

 *** turn off project quotas
+Quota already off.
 *** done
