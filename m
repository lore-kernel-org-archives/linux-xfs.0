Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374E5C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 18:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiJYSCx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJYSCw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 14:02:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A726552
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 11:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=44uWC48wo/Cp/64RSzfSDsWEyCAAdK5b7+ipH6hbEdc=; b=C3o7hwOoE+PBSxhR4e+IS44FIK
        rLHloVBjZ4//HuxTkv11mzMCFofTHWYprSeofvXNC1Mc5dCC0DqZXw5O+Hyx/vmHp9Iud7UuYAL01
        +2r0tV99ILe6Kd4nVTb+yTsTD6hbg2baftoBJVwxTyAzGTKTOzmzKbo/Qxz9TnFF05r2sVM7GSAXH
        Sq/PNXdWypaglUNnz1aNKXXj+VyJh8nfHKMpBJR8TxCpd8HLeSDgzJaXQ2zPdAw+7nTQ1FLMoYFxd
        iK5m6yWW31J82STCC53rIFYa2kOheVfEDN8z7+FhcjXMDXQZo1I0W/nZHeUa3lHA/1ZcA/tYGF29O
        66FuD0sQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onOGL-00GRcF-4z; Tue, 25 Oct 2022 18:02:53 +0000
Date:   Tue, 25 Oct 2022 19:02:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: fix incorrect return type for fsdax fault handlers
Message-ID: <Y1gkzZzAl1QilpVe@casper.infradead.org>
References: <Y1cEYs4TK/kED/52@magnolia>
 <Y1cKIEmT2R9INlDT@casper.infradead.org>
 <Y1crWdYUGatxJn+T@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1crWdYUGatxJn+T@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 05:18:33PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 24, 2022 at 10:56:48PM +0100, Matthew Wilcox wrote:
> > On Mon, Oct 24, 2022 at 02:32:18PM -0700, Darrick J. Wong wrote:
> > > Fix the incorrect return type for these two functions, and make the
> > > !fsdax version return SIGBUS since there is no vm_fault_t that maps to
> > > zero.
> > 
> > Hmm?  You should be able to return 0 without sparse complaining.
> 
> Yes I know, but is that the correct return value for "someone is calling
> the wrong function, everything is fubar, please stop the world now"?

No, it's "success, but I didn't bother to lock the page myself, please
do it for me", which doesn't really make any sense.  I think in this
case, having not initialised vmf->page, we'd probably take a NULL
ptr dereference in lock_page().

From your changelog, it seemed like you were trying to come up with the
vm_fault_t equivalent of 0, rather than trying to change the semantics
of the !fsdax version.
