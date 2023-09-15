Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDC6C46CA1
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 19:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbjIOTvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 15:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjIOTvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 15:51:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D226C7;
        Fri, 15 Sep 2023 12:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=14vBvaf+q0K2fr0TOz07mbChpshy7ApizxiUPLAC/WI=; b=Ja3fQlpPoWGk+zq+9o1/WB9r5B
        /7dMsOKS1yrOjRb8Npu5GcxdpAMGp0GzSdiTzniP4vkGLdM3IO2rvVEhyIa/gbKtpyNG3Buydxgl9
        EvUC5wZyoC5bkop2xQzC7KdgwPN0+YGcy6VQ7VxfMsvH756Wd1s59ay9eYQCyDHfC9wKDgxcBIrnP
        Fzoso8qb1KMfqTtprpebj7oi1UR9jn9u2U0crWJpbFWODC4aaduG4hG8Cijy6q784u9m/SU9gNl2H
        9T5uioF8X++lPczVI0O/z3eW6vp1doWkFRhhHmrOUXFbqH/k/NC+4qNxQz+2M0cZXTwLS3bQMVLLq
        +g3eyoHw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qhEqB-00BiaK-AI; Fri, 15 Sep 2023 19:50:59 +0000
Date:   Fri, 15 Sep 2023 20:50:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pankaj Raghav <kernel@pankajraghav.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        p.raghav@samsung.com, david@fromorbit.com, da.gomez@samsung.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        djwong@kernel.org, linux-mm@kvack.org, chandan.babu@oracle.com,
        mcgrof@kernel.org, gost.dev@samsung.com
Subject: Re: [RFC 08/23] filemap: align the index to mapping_min_order in
 filemap_get_folios_tag()
Message-ID: <ZQS1o38TOOI+AY5H@casper.infradead.org>
References: <20230915183848.1018717-1-kernel@pankajraghav.com>
 <20230915183848.1018717-9-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915183848.1018717-9-kernel@pankajraghav.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 08:38:33PM +0200, Pankaj Raghav wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Align the index to the mapping_min_order number of pages while setting
> the XA_STATE in filemap_get_folios_tag().

... because?  It should already search backwards in the page cache,
otherwise calling sync_file_range() would skip the start if it landed
in a tail page of a folio.

