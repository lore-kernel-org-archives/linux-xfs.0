Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD84FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 05:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243034AbiC3FsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 01:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243045AbiC3Fr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 01:47:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB60D25B931;
        Tue, 29 Mar 2022 22:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ShlAuSZLyEq25xAfycHWI7hECNIi/GQOtl1mtKw5Shk=; b=hpQUdyyucc04FsSCWb013XTcO0
        y2GjL8gVriHew3MYCDqfR8ivlsTCoQ7g8whXxPt36DScOa0Zo6Zj9DDqJWWziGgLmYOJpAfGCm0qq
        BH77DEtEPOutPjLuav55+27+6J+YBCiF+PSdGg7AfoHRcx/iByOBAWfP1jvPNIXff6RArvYBV8qF0
        xnpWDCU3i+zCa/FxT/6PAxeN2Nx5zkJXV7JD+75XSBZIxKikg3jWrTOOe6gDK1DULV3xnjxXMX0e0
        h/JxGdqxaSEruRTcEV2rZgvsEtKc/eSNEqJKpEO88YBfEdbgpkV3cAsUYswOBVFv+kuRmz1KOt5Dn
        0yyRSCjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZR9m-00EMtx-Iy; Wed, 30 Mar 2022 05:46:10 +0000
Date:   Tue, 29 Mar 2022 22:46:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, djwong@kernel.org,
        dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
        jane.chu@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v11 5/8] mm: move pgoff_address() to vma_pgoff_address()
Message-ID: <YkPuooGD139Wpg1v@infradead.org>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-6-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227120747.711169-6-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 27, 2022 at 08:07:44PM +0800, Shiyang Ruan wrote:
> Since it is not a DAX-specific function, move it into mm and rename it
> to be a generic helper.

FYI, there is a patch in -mm and linux-next:

  "mm: rmap: introduce pfn_mkclean_range() to cleans PTEs"

that adds a vma_pgoff_address which seems like a bit of a superset of
the one added in this patch, but only is in mm/internal.h.
