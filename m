Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A71C432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jul 2021 05:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5FB760EB4
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jul 2021 05:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhGWEaR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jul 2021 00:30:17 -0400
Received: from verein.lst.de ([213.95.11.211]:36943 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhGWEaQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jul 2021 00:30:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D570B67373; Fri, 23 Jul 2021 07:10:48 +0200 (CEST)
Date:   Fri, 23 Jul 2021 07:10:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/7] xfs/152: avoid failure when quotaoff is not
 supported
Message-ID: <20210723051048.GA31230@lst.de>
References: <20210722073832.976547-1-hch@lst.de> <20210723050859.GR559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723050859.GR559212@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 10:08:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Switch the test that removes the quota files to just disable enforcement
> and then unmount the file system as disabling quota accounting is about
> to go away.

Looks like mostly copy of xfs/106 for the idmapped mount case.  Somehow
that did not run on my test setups.

Looks good and sorry for missing this one:

Reviewed-by: Christoph Hellwig <hch@lst.de>
