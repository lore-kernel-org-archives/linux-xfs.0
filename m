Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C693C4CECE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68A2920716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:34:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pd1MoWSQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgCLOes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:34:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53358 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgCLOes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XjjsJbDLkOShvptxU5Ne7nBEmoit/32pztmYgg0aAjg=; b=Pd1MoWSQWbi78Y4pPu0KzufhEa
        7Zt3mPjqti/7DDBkb8nEXmSsKHQH6XREEfBpYVRqalmz2jDk8k8s1EBBEmt/SBsI8g3zWV9gqjA7i
        T4KGOCQcu1cl3AHXSNmCfCNcufyv9a617K5Ylr7prB9mIm1+M/tFWneAwqHScbNM9Jmwlblj5iqv3
        W9Y6aNPz2J+fdNZIItWN4kJxYcKM/4zb2MXuiSFiIN/k36EfG5CRmuBmsZRCYu/wbClHiqdh5Q9vX
        PFYSMYiwcijhgiO+t82o8et0GFhgSaGt3twHO0dgZghFX+AMC7XdgovyDdtcx7KO6vRKghZQmNzqP
        Bdjm7Q8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOv7-00055v-W4; Thu, 12 Mar 2020 14:34:45 +0000
Date:   Thu, 12 Mar 2020 07:34:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Filesystem Development List 
        <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] writeback: avoid double-writing the inode on a lazytime
 expiration
Message-ID: <20200312143445.GA19160@infradead.org>
References: <20200306004555.GB225345@gmail.com>
 <20200307020043.60118-1-tytso@mit.edu>
 <20200311032009.GC46757@gmail.com>
 <20200311125749.GA7159@mit.edu>
 <20200312000716.GY10737@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312000716.GY10737@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 11:07:17AM +1100, Dave Chinner wrote:
> > That's true, but when the timestamps were originally modified,
> > dirty_inode() will be called with flag == I_DIRTY_TIME, which will
> > *not* be a no-op; which is to say, XFS will force the timestamps to be
> > updated on disk when the timestamps are first dirtied, because it
> > doesn't support I_DIRTY_TIME.
> 
> We log the initial timestamp change, and then ignore timestamp
> updates until the dirty time expires and the inode is set
> I_DIRTY_SYNC via __mark_inode_dirty_sync(). IOWs, on expiry, we have
> time stamps that may be 24 hours out of date in memory, and they
> still need to be flushed to the journal.
> 
> However, your change does not mark the inode dirtying on expiry
> anymore, so...
> 
> > So I think we're fine.
> 
> ... we're not fine. This breaks XFS and any other filesystem that
> relies on a I_DIRTY_SYNC notification to handle dirty time expiry
> correctly.

I haven't seen the original mail this replies to, but if we could
get the lazytime expirty by some other means (e.g. an explicit
callback), XFS could opt out of all the VFS inode tracking again,
which would simplify a few things.
