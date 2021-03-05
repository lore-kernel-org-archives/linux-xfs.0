Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28544C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5E6465029
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCEIcn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCEIcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:32:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8DAC061574;
        Fri,  5 Mar 2021 00:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BGD+jVHn+AseeWG4H9vlx2tjHHW7IzUNcZe4eeYpwR4=; b=b5IOHqKFGz1Nr3cWOL1PvstVoE
        Kt8cezAJcCaGpfL3ERHXZ3CPzhFK8ddsmvPst30v9AFlRItDzosxvXm784a54K0y4hmvWDbVOg8IG
        Uwy/Kg5z0RSP07GjvF3MDaNyyvlQ2Mvk0/FIcIe+fMJ/Qg3ri8XHY4Z+GhvrhKEtWpO9ELBZZyXFM
        bNdLLVkOr+LZYG4vp06Eok2kXDapg1gz6L/n734KoJfreNekhKHvilMD2WDeSpAhlN7TbmomsywKp
        Z0MWFt/9n1+XklAb6/5nC5H6CpZHIJumBbVPZnZNTT2IKFarQTL2wD/oDXE778GlUmQ3lJvNxEQ3x
        5Oqkj3oQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5sD-00AqFX-QO; Fri, 05 Mar 2021 08:31:56 +0000
Date:   Fri, 5 Mar 2021 08:31:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/4] xfs/271: fix test failure on non-reflink filesystems
Message-ID: <20210305083149.GI2567783@infradead.org>
References: <161472735404.3478298.8179031068431918520.stgit@magnolia>
 <161472736521.3478298.1405183245326186350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472736521.3478298.1405183245326186350.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 03:22:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test creates an empty filesystem with rmap btrees enabled, and then
> checks that GETFSMAP corresponds (roughly) with what we expect mkfs to
> have written to the filesystem.
> 
> Unfortunately, the test's calculation for the number of "per-AG
> metadata" extents is not quite correct.  For a filesystem with a
> refcount btree, the rmapbt and agfl blocks will be reported separately,
> but for non-reflink filesystems, GETFSMAP merges the records.
> 
> Since this test counts the number of records, fix the calculation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
