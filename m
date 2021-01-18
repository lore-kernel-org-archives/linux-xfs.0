Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479BEC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D77022CA1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437376AbhARTvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437773AbhARTvf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 14:51:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0A0E22257;
        Mon, 18 Jan 2021 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610999454;
        bh=u4gd8b0U9dSoeofG9PQy35/GhV9TdEDK/yGXrzNYi6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sUlFkVIsX1BVWTpFNu9b8u4bpmf561ynitaD0UFCVT0KHmDxBDiHDoEk0PkrVMJAq
         pv/Dpl6aOc321oeAjeyPYv+LBn7EJ2UXnRcQcvUXP98iSnVe70it7LyeLGgTHuThyV
         j9W96A9Uk0lULOyQsEOrX9I1RQqfK3dUhNQ+bBmRyfgqKKDngk3jfG7dbRSUoXP8sn
         H6f2BGLqXih39PhzQTXY/nWeszUfJoxADk1C5mfL2i1rrCQPTM6hhIifH6gRZdDJZU
         o9PmbjI46UyVe9jMqctDH1UUds/aL7EsiEG+SMy26hwL80TsxSQMV52uB9mBE6zTDW
         yS3/IDvyN0fbQ==
Date:   Mon, 18 Jan 2021 11:50:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: hide most of the incore inode walk interface
Message-ID: <20210118195054.GK3134581@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040736028.1582114.17043927663737160536.stgit@magnolia>
 <X/8E6jcpKD6TzUO7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/8E6jcpKD6TzUO7@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 03:34:18PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 11, 2021 at 03:22:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Hide the incore inode walk interface because callers outside of the
> > icache code don't need to know about iter_flags and radix tags and other
> > implementation details of the incore inode cache.
> 
> This looks correct, but I'm still rather lukewarm on all the extra code
> just to hide a single flags argument.

Yeah, I looked at the extra patches that are now in this series to deal
with the cleanups mentioned in other review comments and decided to drop
this.

--D
