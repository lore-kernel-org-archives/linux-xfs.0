Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271C3C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 18:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344584AbiEZSMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 14:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiEZSMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 14:12:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FF1AF338;
        Thu, 26 May 2022 11:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pogBGoip5aMEAhJtgZOFEjnZJskuM9yf6zn2SWIHv6o=; b=XIzNCFY7EDW1/aTlmqvyqQIpnZ
        FjuIRzw9jWl2VsOsW2anpTGRcIeuuq454F065xtfMHRSEgXG21hxQsAjRJm+DNwi/BsG9wJ2JvWiI
        +muokaFSnFqBfY/X7Gzq7r3xRbjX2kyngjGTe5RTcQSRUYA2/E788DQIBoCjMtspcMy2u3/5p1Uiz
        djMu8WIfRvTxDIIDpzdxD21ZJAvWea+Wrf8nGv7eBpo1SE7i9JcPFT+4ZneHMHUfvtrVn3IWxCQw5
        8cpfDu9w9MWGoytiynnhtzkQT93Zhu5gnDSTLahxELp6zs16im16aCW1tNzW2gLzrwuC4a+jyFD32
        Pfs/21iA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuHxr-001RWL-U3; Thu, 26 May 2022 18:12:03 +0000
Date:   Thu, 26 May 2022 19:12:03 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 00/16] io-uring/xfs: support async buffered writes
Message-ID: <Yo/C8y3hsOP/viiy@casper.infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-1-shr@fb.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 10:38:24AM -0700, Stefan Roesch wrote:
> Changes:
>   V6:
>   - pass in iter->flags to calls in iomap_page_create()

Dude, calm down.  It's been less than 24 hours since v5.  It's the
middle of the merge window and you have to give people more time to
review your patches.  Don't post another version for a week.
