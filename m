Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6F5C34056
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 18:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FFF524670
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 18:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgBSSnF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 13:43:05 -0500
Received: from verein.lst.de ([213.95.11.211]:45846 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbgBSSnF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Feb 2020 13:43:05 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 552B368B20; Wed, 19 Feb 2020 19:43:02 +0100 (CET)
Date:   Wed, 19 Feb 2020 19:43:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the di_version field from struct icdinode
Message-ID: <20200219184302.GA22307@lst.de>
References: <20200116104640.489259-1-hch@lst.de> <20200218210615.GA3142@infradead.org> <20200219001852.GA9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219001852.GA9506@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:18:52PM -0800, Darrick J. Wong wrote:
> IIRC I started reading this last month, and tried to picture what will
> happen when we introduce a v4 inode format -- will we have to revert all
> of the tests that went from "is di_version == 3" to "if hascrc" in this
> patch?  Or will we simply be adding more code, e.g.
> 
> 	if (hascrc(...)) {
> 		/* do v3 stuff */
> 	}
> 
> 	if (di_version == 4) {
> 		/* do v4 stuff */
> 	}
> 
> I think the answer is that the code for a v4 inode format would probably
> end up doing that and it's probably ok...

Depends on what a v4 inode format would really be.  v1 vs v2 was
basically a few new fields, and more importantl increasing them and
intended to be migrated on an as-needed basis without a reformat.
In reality we would not really need a version number for anything
but the larger fields, as new fields can just be added without
new versions (and we've done that, and in fact done larger fields
that way to by splitting them in case of the project id).

v3 is different in that it treats things different in logging, but
more importantly they require a reformat and thus are file system
wide.
