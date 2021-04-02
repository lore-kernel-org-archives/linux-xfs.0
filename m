Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6785C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A272B61106
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhDBGpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 02:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhDBGpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 02:45:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09B4C0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 23:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=48MC+zXOzJ6dZjhsS0MkmUkuVq1Wg36WkSm1K5psL2U=; b=IPA2NcA4JFPEYS8LGObVOr2SsR
        KBFuchEJicJEgAMrdteRdHCFSt/Xw/z/hdKxJVna0fuUHwf4nXPY0WtbIrcZ9GZF9ML84QC4CNbd8
        Xe6xYqEHdyOmxNgI5hmpaHlfdJTdobnynhY04rW4UCPqQ5/2D0IyloDW1wuSBceoMcRpbWGeQRDjV
        eCLy5qV4eMs8TbJN1NPALPXyfDegNFUBBEM1n+ezULN2mIDUNaHBkzi7Bjv1IrRe3MlnZ3hvvb+5v
        3SSBCIxWf+hyYBJdIaqFyiXBrHXyAmd8lRtPXNmlKzkXE4JJqCK+mO0Ar9Q9sSx87UBU6HMY//Ghs
        +mZfgzZA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDYI-007Iiw-QW; Fri, 02 Apr 2021 06:45:07 +0000
Date:   Fri, 2 Apr 2021 07:45:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/2] xfs: Fix dax inode extent calculation when direct
 write is performed on an unwritten extent
Message-ID: <20210402064506.GB1739516@infradead.org>
References: <20210325140339.6603-1-chandanrlinux@gmail.com>
 <20210325140339.6603-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140339.6603-2-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:33:39PM +0530, Chandan Babu R wrote:
> With dax enabled filesystems, a direct write operation into an existing
> unwritten extent results in xfs_iomap_write_direct() zero-ing and converting
> the extent into a normal extent before the actual data is copied from the
> userspace buffer.
> 
> The inode extent count can increase by 2 if the extent range being written to
> maps to the middle of the existing unwritten extent range. Hence this commit
> uses XFS_IEXT_WRITE_UNWRITTEN_CNT as the extent count delta when such a write
> operation is being performed.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
