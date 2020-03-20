Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A188C4332D
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 17:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1D8C20767
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584725261;
	bh=9Rmx4sIHCfciKwdk1TlIL8UQL6z2SYFTiMvIISrnXWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=if5D/5X0TjRFc2QA6TfAKMMhPHSgFyjFrrRoPJRELMt6KN6acnTX/jdF14qJj1u6U
	 NZo5SgzvOlvS/PUx3dBCwQWCZJko1aBvDlD3t9u1BWER2YbYOqH8TArG1POYR//Vc5
	 tEfqCG6MfwCigkmrYUUgsAOJMCZY8vSuX6dLLO0U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgCTR1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 13:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCTR1i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Mar 2020 13:27:38 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 730F020722;
        Fri, 20 Mar 2020 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584725257;
        bh=9Rmx4sIHCfciKwdk1TlIL8UQL6z2SYFTiMvIISrnXWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/YkKArfq1iF3otzHszrdNEK4pGZu8HmyG06yoUAx/x7Zmux14+oQSDHmTEj+ASkO
         Ut9Lxt32+DGg8O7DncGb51HyQWEXBRRA2k/YwVYoHBih1SPbfHbofIIG4q5up22QYO
         QL5J3+neUV0oZD8wLEzn53mMK4ACXSmYlzLi7NcA=
Date:   Fri, 20 Mar 2020 10:27:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        William Kucharski <william.kucharski@oracle.com>
Subject: Re: [PATCH v9 13/25] mm: Add page_cache_readahead_unbounded
Message-ID: <20200320172736.GC851@sol.localdomain>
References: <20200320142231.2402-1-willy@infradead.org>
 <20200320142231.2402-14-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320142231.2402-14-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 20, 2020 at 07:22:19AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> ext4 and f2fs have duplicated the guts of the readahead code so
> they can read past i_size.  Instead, separate out the guts of the
> readahead code so they can call it directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>
Tested-by: Eric Biggers <ebiggers@google.com>

- Eric
