Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85FEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 13:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F9A22CAF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 13:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbhALNX7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 08:23:59 -0500
Received: from verein.lst.de ([213.95.11.211]:55529 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbhALNX7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jan 2021 08:23:59 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B37E067373; Tue, 12 Jan 2021 14:23:15 +0100 (CET)
Date:   Tue, 12 Jan 2021 14:23:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 04/12] fat: only specify I_DIRTY_TIME when needed in
 fat_update_time()
Message-ID: <20210112132315.GA13780@lst.de>
References: <20210109075903.208222-1-ebiggers@kernel.org> <20210109075903.208222-5-ebiggers@kernel.org> <20210111105201.GB2502@lst.de> <X/ysA8PuJ/+JXQYL@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/ysA8PuJ/+JXQYL@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 11:50:27AM -0800, Eric Biggers wrote:
> On Mon, Jan 11, 2021 at 11:52:01AM +0100, Christoph Hellwig wrote:
> > On Fri, Jan 08, 2021 at 11:58:55PM -0800, Eric Biggers wrote:
> > > +	if ((flags & S_VERSION) && inode_maybe_inc_iversion(inode, false))
> > > +		dirty_flags |= I_DIRTY_SYNC;
> > 
> > fat does not support i_version updates, so this bit can be skipped.
> 
> Is that really the case?  Any filesystem (including fat) can be mounted with
> "iversion", which causes SB_I_VERSION to be set.
> 
> A lot of filesystems (including fat) don't store i_version to disk, but it looks
> like it will still get updated in-memory.  Could anything be relying on that?

As Dave pointed out i_version can't really work for fat.  But I guess
that is indeed out of scope for this series, so let's go ahead with this
version for now:

Reviewed-by: Christoph Hellwig <hch@lst.de>
