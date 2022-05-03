Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897B4C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 14:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiECO75 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 10:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237549AbiECO7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 10:59:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7851396B8
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 07:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lvBl54UUOKHUSyd0s8jIPTkkweXCHMqoFQI84qCjIAU=; b=DyTV1fxt1DyK/mmtC/ZlpmeDGS
        PjLfZ12NcS5xi1w4U7GBUrbIRqThUlzRQBchIB93g03MzBDHk3ebbvvpuvyt9/G2M7Y4XjvqgmETP
        Kc0DkEm9XCkCUIGuIZGHqAZBC7cIWZgdmkd22b67OK0OOygrNWWdWpziTHcbf/8VijIUak0yEb0Yj
        9pfwkIoVY5c3utJd2cfqO0qzi6JaGMC7PXD6ZSLas3vig1oU1NyJNss+PAbF80gRVeWq/AeHqk1Ua
        dBfBhVONSyVwFBrLFREfL/VVjvGg01nOo7JHH0wJt3gSJnLP/4q3gevMVsseBzWJ5wPjEIRpIyPEu
        RQ5ZpyMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nltwq-006N1C-C2; Tue, 03 May 2022 14:56:20 +0000
Date:   Tue, 3 May 2022 07:56:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: set XFS_FEAT_NLINK correctly
Message-ID: <YnFClHs4dg17fhF+@infradead.org>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 02, 2022 at 06:20:17PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> While xfs_has_nlink() is not used in kernel, it is used in userspace
> (e.g. by xfs_db) so we need to set the XFS_FEAT_NLINK flag correctly
> in xfs_sb_version_to_features().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
