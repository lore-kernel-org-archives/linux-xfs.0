Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27E2C3F2CD
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 16:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B585120722
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 16:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aJek0piv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgCWQto (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:49:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41460 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbgCWQto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 12:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ENOB86QPPW1hZ7cXTJ91MQndQ6TVAdAYxv1/WjXtLMc=; b=aJek0pivurM+MEpL/YLkHga5zT
        bH8tbfeKaPGMDpqSF814Rsww9r7Yq/eKBNujL/eew2VY6IhADrU1FO4fKSBMWpaTPN/ePyhQG2stl
        LJKx779la10U4/5r7lrbHT8AugYYOah9xTk3040z0kQyUOFTkxW6q4/igFC+uMth3N0mte4SaedRk
        qF84+80d7SOjXjJ6jVwR8EmDpURSMUvC9Yl2bkCFPaCb8Q4PAZVfetyEmw+ZuRdIilU+/x6YHXWnq
        ci7n4R5kxpUrYFFn6IifMfaV2s2KPC4B5XJ0qp5+KLu7QV2zBhwb75YmdfgEKj8PtAOQrsq6Tzqa2
        9vIp33sg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGQGk-0008MH-RF; Mon, 23 Mar 2020 16:49:42 +0000
Date:   Mon, 23 Mar 2020 09:49:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 0/4] xfs: Remove wrappers for some semaphores
Message-ID: <20200323164942.GA30433@infradead.org>
References: <20200320210317.1071747-1-preichl@redhat.com>
 <20200323032809.GA29339@magnolia>
 <CAJc7PzXuRHhYztic9vZsspiHiP-vL_0HANd8x76Y+OdRVw6wwg@mail.gmail.com>
 <20200323163342.GD29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323163342.GD29339@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 09:33:42AM -0700, Darrick J. Wong wrote:
> lockdep tracks the rwsem's lock state /and/ which process actually
> holds the rwsem.  This ownership doesn't transfer from 28177 to 27081,
> so when the kworker asks lockdep if it holds ILOCK_EXCL, lockdep says
> no, because 27081 doesn't own the lock, 28177 does.  Kaboom.

> The old mrlock_t had that 'int mr_writer' field which didn't care about
> lock ownership and so isilocked would return true and so the assert was
> happy.
> 
> So now comes the fun part -- the old isilocked code had a glaring hole
> in which it would return true if *anyone* held the lock, even if the
> owner is some other unrelated thread.  That's probably good enough for
> most of the fstests because we generally only run one thread at a time,
> and developers will probably notice. :)
> 
> However, with your series applied, the isilocked function becomes much
> more powerful when lockdep is active because now we can test that the
> lock is held *by the caller*, which closes that hole.
> 
> Unfortunately, it also trips over this bmap split case, so if there's a
> way to solve that problem we'd better find it quickly.  Unfortunately, I
> don't know of a way to gift a lock to another thread temporarily...
> 
> Thoughts?

lock_release() in the donor, lock_acquire in the worker context, and
vice versa on return.  We already do that dance indirectly with
xfs_setfilesize_trans_alloc and friends.
