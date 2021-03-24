Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AFFC433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3233C61A1E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbhCXSEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbhCXSEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 14:04:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79699C061763;
        Wed, 24 Mar 2021 11:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WBPYLQA7SOu9juQpDa+zV6IvltLlpg8vwWEe/jQRflM=; b=OS8X9g9sFFU75dP3JUPlldE6ul
        j7Ac6q+guiuyTf7zqE8RjrWYjYsxyM02S+t3GM0T8vOujNA/c/8dGXXlq5SbqZOYRHYoDwg+c/Klo
        TAO2ArSXL/zIAMQ/p5nWD0vA9gsPPL8mAyNai6OSoVG5NKDEHCN95ghPkEIyPJnmAa5p7ZQs49iLq
        Ci6zmLTuGvkQYwGSSNNkH9h/JT9NPzXucNeP13cLytcBNqk3EwwyYL+G13uOeb31VrXwCViBpHAqV
        MgDa6eWG5qscOEMB+L6G83xwhjubl6vfPjQHDbASmLghEcQ+IPJ3GawUyQaTA2oY9cn8RPGloDMvL
        kP3iFwLA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lP7rH-00BfUL-Nq; Wed, 24 Mar 2021 18:04:05 +0000
Date:   Wed, 24 Mar 2021 18:03:55 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] populate: create block devices when pre-populating
 filesystems
Message-ID: <20210324180355.GA2779737@infradead.org>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
 <161647318806.3429609.966502470186246038.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647318806.3429609.966502470186246038.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:19:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I just noticed that the fs population helper creates a chardev file
> "S_IFBLK" on the scratch filesystem.  This seems bogus (particularly
> since we actually also create a chardev named S_IFCHR) so fix up the
> mknod calls.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
