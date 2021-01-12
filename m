Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4165C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 13:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA6A230F9
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 13:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbhALN0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 08:26:06 -0500
Received: from verein.lst.de ([213.95.11.211]:55540 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbhALN0F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jan 2021 08:26:05 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5AC0A68B02; Tue, 12 Jan 2021 14:25:21 +0100 (CET)
Date:   Tue, 12 Jan 2021 14:25:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 11/12] ext4: simplify i_state checks in
 __ext4_update_other_inode_time()
Message-ID: <20210112132521.GB13780@lst.de>
References: <20210109075903.208222-1-ebiggers@kernel.org> <20210109075903.208222-12-ebiggers@kernel.org> <20210111105342.GE2502@lst.de> <X/yzzKhysdFUY/6o@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/yzzKhysdFUY/6o@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 12:23:40PM -0800, Eric Biggers wrote:
> > I think a descriptively named inline helper in fs.h would really improve
> > this..
> 
> Do you want this even though it is specific to how ext4 opportunisticly updates
> other inodes in the same inode block as the inode being updated?  That's the
> only reason that I_FREEING|I_WILL_FREE|I_NEW need to be checked; everywhere else
> justs want I_DIRTY_TIME.
> 
> We could add:
> 
> 	static inline bool other_inode_has_dirtytime(struct inode *inode)
> 	{
> 		return (inode->state & (I_FREEING | I_WILL_FREE |
> 					I_NEW | I_DIRTY_TIME)) == I_DIRTY_TIME;
> 	}
> 
> But it seems a bit weird when it's specific to ext4 at the moment.
> 
> Are you thinking that other filesystems will implement the same sort of
> opportunistic update, so we should add the helper now?

For my taste these checks for flags is way too much black magic and will
trivially break when people add new flags.  So having a helper next to
the definition of the I_* flags that is well documented would be very,
very helpful.  My preferred naming would be something along the lines
of 'inode_is_dirty_lazytime_only()'.
