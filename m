Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ECBC4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 17:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C7C120767
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584725863;
	bh=G2+3MpD3WslFGLdp5NjeBbtVtx2oUkFUbLAe3FrGwo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aQLHbEgnLkWTvF9oCtbWXX5UnBHso8p6gi6BhBEAYH2/COAb9baNB/kujsVb7hV8s
	 vcI4UlVW/qxrsxLx+7rkZTJp7oK2G3bXqBAhORQrhV0wzcDo15H1HcsncGqsJdMneM
	 LOwL6emTAwp3mNJKOsbxmQSrTiSERJkoNo+UZxIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgCTRhh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 13:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgCTRhh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Mar 2020 13:37:37 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B72C20722;
        Fri, 20 Mar 2020 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584725856;
        bh=G2+3MpD3WslFGLdp5NjeBbtVtx2oUkFUbLAe3FrGwo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=avAm79PauNq7Mi8lepE1M+q8L6UcKnW/aDKz8d+iWcwGM0xSpN0CPodVkw5n7hjxI
         bmniaSQH/oDhJBhhL3LaO1e96w9j3KKiHwDmuCEMBhf2iB3BNRVYn0F6PNaJNIKpU0
         QA85GNq47i8AcHSpCY4OouI56lflivWj/ICnBfM4=
Date:   Fri, 20 Mar 2020 10:37:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org,
        William Kucharski <william.kucharski@oracle.com>,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, ocfs2-devel@oss.oracle.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v9 20/25] ext4: Convert from readpages to readahead
Message-ID: <20200320173734.GD851@sol.localdomain>
References: <20200320142231.2402-1-willy@infradead.org>
 <20200320142231.2402-21-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320142231.2402-21-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 20, 2020 at 07:22:26AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new readahead operation in ext4
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> ---
>  fs/ext4/ext4.h     |  3 +--
>  fs/ext4/inode.c    | 21 +++++++++------------
>  fs/ext4/readpage.c | 22 ++++++++--------------
>  3 files changed, 18 insertions(+), 28 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

> +		if (rac) {
> +			page = readahead_page(rac);
>  			prefetchw(&page->flags);
> -			list_del(&page->lru);
> -			if (add_to_page_cache_lru(page, mapping, page->index,
> -				  readahead_gfp_mask(mapping)))
> -				goto next_page;
>  		}

Maybe the prefetchw(&page->flags) should be included in readahead_page()?
Most of the callers do it.

- Eric
