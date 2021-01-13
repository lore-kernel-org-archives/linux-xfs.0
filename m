Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4415C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF42235FA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbhAMPA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbhAMPA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:00:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FB6C061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kJ+wwatr903B5a4JoKd6BYgx1mNrmpR6A9gzGGudL+Q=; b=IMQiCxvAWOWPSdGoMcsSZPamyb
        RS2l0UtJeJ8FqR0qpdIAw/scb0B5pi7EQ7+TPoCN3gYplkOt/HAUWZKg4vsATn/MQwUAAmVEPnTqW
        4z7Vahgs7RxiZs2UUrf9+PdCwpdUHCOXtbkVybWWUxNt9m9jMZ3k/LGGFYbWKco9kgnxdShtKv0Js
        6xG0Z8PD2fOBMF/VTlRjyxNE+00Eg8dEjeLJ9kjF4lNVLZsmgcVlH3TWPEV3fGXxCqc+tgjEPAr/8
        CgAeFanC+h+ZxCPoP9q+GeJVjY2oVmwlPt28JcAqIlmuEZjD6sE0vIoIgZvzJZ5di9eYlNrFaGDEe
        jUVC9SSg==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhcB-006O5h-92; Wed, 13 Jan 2021 14:59:26 +0000
Date:   Wed, 13 Jan 2021 15:59:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: consolidate incore inode radix tree
 posteof/cowblocks tags
Message-ID: <X/8Kwedt/T4BbVe7@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040741435.1582286.3950020739629626839.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040741435.1582286.3950020739629626839.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:23:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The clearing of posteof blocks and cowblocks serve the same purpose:
> removing speculative block preallocations from inactive files.  We don't
> need to burn two radix tree tags on this, so combine them into one.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
