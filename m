Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97870C001B0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 20:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjGKUGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjGKUGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 16:06:07 -0400
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65767139
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:06:06 -0700 (PDT)
Date:   Tue, 11 Jul 2023 16:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689105964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=beCzAAgGGGWYoTxU+DMOv8Ui10HFwHhnTS6QvcEqUpk=;
        b=DAg1iG2tkmSKG8ExnJeDYtob8cxD57LanGTbIwa7wWdx2ZdxTzT42U8xg0V1mXvhDL2Lp6
        mf/NCSl5KxPxVdU6CsNzkNCGSo6Ztu5DAZBTOJhaD+S6yMLQNVDDfuuyQc8kbn9jL0F1gZ
        jrR9b9b/yw93Ypv2vHgWjBfiVchvn0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v4 1/9] iov_iter: Handle compound highmem pages in
 copy_page_from_iter_atomic()
Message-ID: <20230711200559.kg5kitwhgex6w7uf@moria.home.lan>
References: <20230710130253.3484695-1-willy@infradead.org>
 <20230710130253.3484695-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710130253.3484695-2-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2023 at 02:02:45PM +0100, Matthew Wilcox (Oracle) wrote:
> copy_page_from_iter_atomic() already handles !highmem compound
> pages correctly, but if we are passed a highmem compound page,
> each base page needs to be mapped & unmapped individually.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>

I just pulled this into the bcachefs tree; in a week or two if you
haven't heard anything you can add my Tested-by:
