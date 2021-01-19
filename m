Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84897C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 19:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 391782313F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 19:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbhASTsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729946AbhASTsC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 14:48:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFC552310B;
        Tue, 19 Jan 2021 19:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611085640;
        bh=q7YoXV3+8wHIo9rlqjIWNPXTs0pvjzQ6oQRN48hy8ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gpccbbcfZpPr+rGBRTkfS+wC0fKg8wTcL2vHUI6gr+Tn1dwa5HcHwIgNplOOp99y+
         n4ZWv85ob8xTUfRHXndH5Ap4HJmHRNOEgxPfAdTkc/WrxBnW4FBluqfRWxiXhS0Nan
         r2C19l1shvYX1V/b44FSo1HGCTD45XCq8QbNy4Et5BUwbtEX2L8jW0z4T+MaWqDg0t
         Un8HNVXmnWXdCK2C4soaNwwkTwmbdw7kxP3+gBW2V8/cjupagHKlbgODiEB40KhHjA
         bps6+lvXwGq//Ew9P3ajMQY8TKE4uOLDsw3BnZ+X8CzLPjSLnsAxKyNt8sYXHWAd2w
         MGeXglefuQwcg==
Date:   Tue, 19 Jan 2021 11:47:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create convenience wrappers for incore quota
 block reservations
Message-ID: <20210119194719.GR3134581@magnolia>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
 <161100791039.88678.6897577495997060048.stgit@magnolia>
 <YAZ/s1a0c7drWZv3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAZ/s1a0c7drWZv3@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 07:44:03AM +0100, Christoph Hellwig wrote:
> > -	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
> > -						XFS_QMOPT_RES_REGBLKS);
> > +	error = xfs_quota_reserve_blkres(ip, alen, XFS_QMOPT_RES_REGBLKS);
> 
> This is the only callsite outside of xfs_quota_unreserve_blkres,
> so I'm not sure how useful the wrapper is.  Also even on the unreserved
> side we always pass XFS_QMOPT_RES_REGBLKS except for one case that
> conditionally passes XFS_QMOPT_RES_RTBLKS.  So if we think these helpers
> are useful enough I'd at least just pass a bool is_rt argument and hide
> the flags entirely.

Seeing as XFS doesn't even let you mount with quota and rt, I elect to
get rid of the third parameter entirely.  Whoever decides to make them
work together will have a lot of work to do beyond fixing that one
unreserve call.

--D
