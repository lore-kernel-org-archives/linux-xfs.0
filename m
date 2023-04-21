Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA41C77B7F
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 20:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbjDUUPY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 16:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjDUUPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 16:15:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9E82719;
        Fri, 21 Apr 2023 13:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7jDGoKVRVE8/8Iw2EXqkPonvmAc0gvYRAzqps4fjwwg=; b=mr+zjn1yXtzKk4APmgRaOn77YC
        qyrdJusW0V5fFBehp0H4LgJmcOzWB0HiZ/19FHS9XzMMBWYiQQiK2ov9vzahR7YBu95NK76q9JJZs
        AkLKN4MUKm/MQ5+LZ/SLYHWNNTKsZIr04BKzck1FGkgdltQkKD7lNhCvCFoMTcFExtsIMgiMKVPre
        m9Im6jnJmlKaq2x+wCYrcuNfTZjtNWDTsZNJmxJoZAgKC50KnsIBoeDx/zoi7hd2VV9XP++ihIvTA
        tOEZ5yH+/ubaSmLHWmwzD23OC6iMGfb2/N5vqIvhKd4FYrTP8/q/0FOd4KBWDZDlc9qXT016NGn1F
        NwwreEtg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ppxA3-00FZsC-AG; Fri, 21 Apr 2023 20:15:15 +0000
Date:   Fri, 21 Apr 2023 21:15:15 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        christoph.boehmwalder@linbit.com, hch@infradead.org,
        djwong@kernel.org, minchan@kernel.org, senozhatsky@chromium.org,
        patches@lists.linux.dev, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        hare@suse.de, p.raghav@samsung.com, da.gomez@samsung.com,
        kbusch@kernel.org
Subject: Re: [PATCH 1/5] dm integrity: simplify by using PAGE_SECTORS_SHIFT
Message-ID: <ZELu017UCTZWrCjv@casper.infradead.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421195807.2804512-2-mcgrof@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 12:58:03PM -0700, Luis Chamberlain wrote:
> -	*pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	*pl_index = sector >> (PAGE_SECTORS_SHIFT);

You could/should remove the () around PAGE_SECTORS_SHIFT

(throughout)
