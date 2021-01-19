Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3FBC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C38392312D
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbhASHQb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 02:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbhASHOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:14:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC91C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6IkzSpqIg0GwPlCV5ab90izFJnvPhDdstpXJzKacwdY=; b=nk08psxMcUjOd4cqeVvhft4vd3
        DKVCSB9NJAWnD9gBXj/+19QJZMPICSCkPdVeLYFjxEvY43P8fgE3e4cgOQR07w8CaCNC33cykvxhn
        Bd4IwviAZKYywFalh4TdfjsTddnDGPkjmkW0ZkEDUjyGPT93u7hu/GX+dwBvzV2XEH77B9+eriSzZ
        J8FzyCC6UAHHa3IEAQRqDqxYjnkWBH2WoE7m+I9ijBAITAAYz6MXn9Yhb5KTI/uMDW1NLr1GiCDgZ
        0dcTgKiA3bsnXI60PQnslc1l9KdTOvxflajkG0O5raUDCPVcHB18FStrRKVChJnHByDq9rX/4FlwI
        WKd7G47w==;
Received: from [2001:4bb8:188:1954:b440:557a:2a9e:a981] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1lCp-00Dwkj-BL; Tue, 19 Jan 2021 07:13:44 +0000
Date:   Tue, 19 Jan 2021 08:13:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: hide xfs_icache_free_eofblocks
Message-ID: <YAaGng4oszs/SVsA@infradead.org>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
 <161100799230.90204.6358063643921626790.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100799230.90204.6358063643921626790.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:13:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Change the one remaining caller of xfs_icache_free_eofblocks to use our
> new combined blockgc scan function instead, since we will soon be
> combining the two scans.  This introduces a slight behavior change,
> since the XFS_IOC_FREE_EOFBLOCKS now clears out speculative CoW
> reservations in addition to post-eof blocks.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
