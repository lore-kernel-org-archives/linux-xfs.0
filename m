Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76813C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E3364EBD
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBIJRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhBIJNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:13:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B5EC061794
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=URErjoVyfSzT9rTQ/hNesIKOctv86XKQCvvnNR0suGQ=; b=Hn1Bq4X9Uc5O3lnvSwLbN4AlZB
        za8FM2JkMXLqcRSWWyATG1qJhcXpY5hbxrR5WlDH0kvPedUWwyTiKLy4q78RDTT37lXSi2JLnw8zS
        jWwNQKHZ39U2p4y4D5Ujy5+W11w/+s6eEV/pm18jl7C0xKVsynfoPrthsE5O6OEiChEyXZ0/MSeW1
        G+8ZKM2gmCv5WtYkOQ1kSpPhpcsipa6dgRMItXOIMQfFk9u4YeR/hz8ikl4YTzOAJs1fVJgh42+kx
        1QA7+bPPGi1irt4yFRkG8LCGR1bfR+kbADjb87S8cHWMJN2FUi3+1hUrfQWoWUAOt7VOaRPENaTqW
        zIgTFl4w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P4J-007DLF-O3; Tue, 09 Feb 2021 09:12:24 +0000
Date:   Tue, 9 Feb 2021 09:12:23 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 06/10] xfs_repair: clear the needsrepair flag
Message-ID: <20210209091223.GF1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284383828.3057868.1762356472271947821.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284383828.3057868.1762356472271947821.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the needsrepair flag, since it's used to prevent mounting of an
> inconsistent filesystem.  We only do this if we make it to the end of
> repair with a non-zero error code, and all the rebuilt indices and
> corrected metadata are persisted correctly.
> 
> Note that we cannot combine clearing needsrepair with clearing the quota
> checked flags because we need to clear the quota flags even if
> reformatting the log fails, whereas we can't clear needsrepair if the
> log reformat fails.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
