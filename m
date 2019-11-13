Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EF6C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 06:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A65221A49
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 06:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfKMG7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:59:20 -0500
Received: from verein.lst.de ([213.95.11.211]:60626 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfKMG7U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Nov 2019 01:59:20 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 319D568BE1; Wed, 13 Nov 2019 07:59:18 +0100 (CET)
Date:   Wed, 13 Nov 2019 07:59:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: devirtualize ->m_dirnameops
Message-ID: <20191113065918.GA2606@lst.de>
References: <20191111180415.22975-1-hch@lst.de> <20191113042247.GH6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113042247.GH6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 08:22:47PM -0800, Darrick J. Wong wrote:
> > @@ -718,7 +718,7 @@ xfs_dir2_block_lookup_int(
> >  		 * and buffer. If it's the first case-insensitive match, store
> >  		 * the index and buffer and continue looking for an exact match.
> >  		 */
> > -		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
> > +		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
> 
> gcc complains about the unused @mp variable here.  With that fixed the
> rest looks ok, so:

What gcc version do you use?  I see a consistent pattern lately that
yours (correctly) find initialized but unused variable, but neither my
local one nor the build bot does..
