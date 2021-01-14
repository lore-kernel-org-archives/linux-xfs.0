Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAF4C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 21:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B7B7221FD
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 21:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbhANVzl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 16:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730522AbhANVzf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 16:55:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76AAD221FD;
        Thu, 14 Jan 2021 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610661294;
        bh=ibVnI2n3Ko44ZKaaGqtoXBT65M1Yaepo+0IShDIMeVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=otFfWOOb6OsFG30R0YSUNjXeyKGOxFO/ZFT+cN1jaIs0i1UQYsRGR4DNMU4am3tae
         mrHfTLQG9m5aHwWPmvo+yUt/gyl3M6gWK49HOgB3k+95T7BX3s7kPM2kAmxyo/42Ab
         9uwQ2FFbfAhAZ5J7tzv2RTZiaJxkYNnRqyrQL4kP9nBDbna4vyuOJU5B33uW95YdCT
         feWOcoOSzlLA+XOs9qlF6cxZl4lqdubf2a+gJGrirCfix2jd/0Cksn9M7yhQiBvNHr
         lMZkIvEDJoOtIUoFGO+rGI503g5Ogvn+jFL9UPp3q6yw9ZfKDREphxpJ9Si7xpSHz5
         8yrQiKpj+2UJQ==
Date:   Thu, 14 Jan 2021 13:54:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210114215453.GG1164246@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737263.1582114.4973977520111925461.stgit@magnolia>
 <X/8HLQGzXSbC2IIn@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/8HLQGzXSbC2IIn@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 03:43:57PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 11, 2021 at 03:22:52PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't stall the cowblocks scan on a locked inode if we possibly can.
> > We'd much rather the background scanner keep moving.
> 
> Wouldn't it make more sense to move the logic to ignore the -EAGAIN
> for not-sync calls into xfs_inode_walk_ag?

I'm not sure what you're asking here?  _free_cowblocks only returns
EAGAIN for sync calls.  Locking failure for a not-sync call results in a
return 0, which means that _walk_ag just moves on to the next inode.

--D
