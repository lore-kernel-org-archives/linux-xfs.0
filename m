Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347D9C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 13:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0DC420719
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 13:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601644064;
	bh=w7Q98xWmgIId9na9TFgx9+vmYElcAY53KjeEwsE4RbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ezmzvDREBEYer8q+82STf7Mi7Qa5Z0U5c8MSiTN0uLkuz1lpz70VtANvfhDScfhuS
	 MNAGjQkQsCSQ7WV7x4vNf+jJ1oP1Hye1tXY+NIO8InWKw5wf6Pr5cAPFaDD0mhmTxr
	 ik9AuykBVZ9kKWkBV1IxVKThNjP3JRhj7mv8F4dE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387878AbgJBNHn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 09:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgJBNHm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 09:07:42 -0400
Received: from localhost (unknown [73.61.18.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2606D20708;
        Fri,  2 Oct 2020 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601644062;
        bh=w7Q98xWmgIId9na9TFgx9+vmYElcAY53KjeEwsE4RbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kqDZFoN6mDjVMDUsQj+sbV8ZdesUG0EyIvW0x+SkNWQV4gnigP9wAMGQeEXoy8iuA
         RZ2oftB2zlDwEek8kQIusdvhaZU2Yixz9jx+19Oggw1VANHSdH2TQAZtKYh3KwM7PJ
         zLdoThrBMWoqYb6tdNFLrM4+G5u8d8mwbZkhA26A=
Date:   Fri, 2 Oct 2020 09:07:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH STABLE V2] xfs: trim IO to found COW extent limit
Message-ID: <20201002130740.GF2415204@sasha-vm>
References: <5d2f4fc1-e498-c45e-3d57-9c2d7ac275e6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5d2f4fc1-e498-c45e-3d57-9c2d7ac275e6@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 08:34:48AM -0500, Eric Sandeen wrote:
>A bug existed in the XFS reflink code between v5.1 and v5.5 in which
>the mapping for a COW IO was not trimmed to the mapping of the COW
>extent that was found.  This resulted in a too-short copy, and
>corruption of other files which shared the original extent.
>
>(This happened only when extent size hints were set, which bypasses
>delalloc and led to this code path.)
>
>This was (inadvertently) fixed upstream with
>
>36adcbace24e "xfs: fill out the srcmap in iomap_begin"
>
>and related patches which moved lots of this functionality to
>the iomap subsystem.
>
>Hence, this is a -stable only patch, targeted to fix this
>corruption vector without other major code changes.
>
>Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
>Cc: <stable@vger.kernel.org> # 5.4.x
>Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>Reviewed-by: Christoph Hellwig <hch@lst.de>
>---
>
>V2: Fix typo in subject, add reviewers
>
>I've tested this with a targeted reproducer (in next email) as well as
>with xfstests.
>
>There is also now a testcase for xfstests submitted upstream
>
>Stable folk, not sure how to send a "stable only" patch, or if that's even
>valid.  Assuming you're willing to accept it, I would still like to have
>some formal Reviewed-by's from the xfs developer community before it gets
>merged.

This is perfect stable-process-wise :) Will wait for reviews/acks before
merging.

-- 
Thanks,
Sasha
