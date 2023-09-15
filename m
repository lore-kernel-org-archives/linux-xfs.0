Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4BEEED61A
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 18:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbjIOS4B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 14:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbjIOSz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 14:55:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2DA268A;
        Fri, 15 Sep 2023 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ydxv0H4AQODCBA++n6E0d1nAOuRuwCzEkOyn7750pKU=; b=ZG7FxJoMGXk/kL4merXOhxNQ0b
        bZbpggT0P5T5ujSXAcV9rNN5WWQ2IR9g3DWHHZCeuwOcuBBvHwdwzLlNMpjORpzBK6SrPZe82KPap
        BcLeLVwpAA3F4v92pDFEWyi1E/510y2Yurro3rYT93uSUg77CFDWQ/HkAD49f999R8LBxbqSCQhbD
        mEsj/bHc3uyr/44dwj8SgDuJOTXtGx+we8gBzz+QTugqU286xR/k5pEGzcwS/NqI/S5SDhqk9vpdt
        yhumb613YKarn62iyq+ojZfIJR33DGB+loVFcmj0wMDX8QCkQVM0QSgPpMqxy2evP8RoK1feqCfZf
        2gxNfFmw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qhDyC-00BRx6-TY; Fri, 15 Sep 2023 18:55:12 +0000
Date:   Fri, 15 Sep 2023 19:55:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pankaj Raghav <kernel@pankajraghav.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        p.raghav@samsung.com, david@fromorbit.com, da.gomez@samsung.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        djwong@kernel.org, linux-mm@kvack.org, chandan.babu@oracle.com,
        mcgrof@kernel.org, gost.dev@samsung.com
Subject: Re: [RFC 02/23] pagemap: use mapping_min_order in fgf_set_order()
Message-ID: <ZQSokGztDTbXBxBU@casper.infradead.org>
References: <20230915183848.1018717-1-kernel@pankajraghav.com>
 <20230915183848.1018717-3-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915183848.1018717-3-kernel@pankajraghav.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 08:38:27PM +0200, Pankaj Raghav wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> fgf_set_order() encodes optimal order in fgp flags. Set it to at least
> mapping_min_order from the page cache. Default to the old behaviour if
> min_order is not set.

Why not simply:

+++ b/mm/filemap.c
@@ -1906,9 +1906,12 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
                folio_wait_stable(folio);
 no_page:
        if (!folio && (fgp_flags & FGP_CREAT)) {
-               unsigned order = FGF_GET_ORDER(fgp_flags);
+               unsigned order;
                int err;

+               order = min(mapping_min_folio_order(mapping),
+                               FGF_GET_ORDER(fgp_flags));

