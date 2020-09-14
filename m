Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38FAC43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9B5217BA
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:29:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nP9Q6pVC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgINH3M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 03:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgINH3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 03:29:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0ECC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 00:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ja8X3upUbcV+jVjT8JZWqGJJJbWlgfpG1BPG/u3ct30=; b=nP9Q6pVCLA8+s6KcyDM+6AdB6t
        tfebFjBJltp0u/xIvI76w4/vFl00Edc6/zhxV3FiY7HHwGKmH48nixLiUKW5/6AESd733xSo5n4Ac
        DID8m92WvHID3CI2M6fbdndDAu+GEz4vOozRn6/5f1sohm2oU66xdmjxhd1Ul4qiZ4UHY64lBJ3zc
        LkSBBp0igsnCYpzSdposGKt3qNQcrwikqdFDobW5otXzTN3AlBC78/d//1T4uZRMymL+RkpAEIoK6
        2SuG98+H3D8slJAbJSAdPLHB1R1NnhjA0NPAxyBk3lS0uVqhFhccrkdEL/IG/kaRU4J53v2NTnsux
        WlgjP8Jg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHivF-0007vI-Ql; Mon, 14 Sep 2020 07:29:09 +0000
Date:   Mon, 14 Sep 2020 08:29:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <20200914072909.GC29046@infradead.org>
References: <20200911164311.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911164311.GU7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 09:43:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The V4 filesystem format contains known weaknesses in the on-disk format
> that make metadata verification diffiult.  In addition, the format will
> does not support dates past 2038 and will not be upgraded to do so.
> Therefore, we should start the process of retiring the old format to
> close off attack surfaces and to encourage users to migrate onto V5.
> 
> Therefore, make XFS V4 support a configurable option.  For the first
> period it will be default Y in case some distributors want to withdraw
> support early; for the second period it will be default N so that anyone
> who wishes to continue support can do so; and after that, support will
> be removed from the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: be a little more helpful about old xfsprogs and warn more loudly
> about deprecation
> v2: define what is a V4 filesystem, update the administrator guide

Whie this patch itself looks good, I think the ifdef as is is rather
silly as it just prevents mounting v4 file systems without reaping any
benefits from that.

So at very least we should add a little helper like this:

static inline bool xfs_sb_is_v4(truct xfs_sb *sbp)
{
	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
		return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
	return false;
}

and use it in all the feature test macros to let the compile eliminate
all the dead code.
