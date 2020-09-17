Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06636C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBEED221E7
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v+/bwiom"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIQIMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgIQIMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:12:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C509C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cHqK/fU5pm6Utf/H4wImXgHJb9/Hx2oGcnTyxnzDKt8=; b=v+/bwiomJjBcE6u4rYzZmnfovB
        vWPw8N3U673gLwKz/RtrW7WF0genMf799lEafReWMYmHcwHvySXI6aTVPSBxcCfX1WOAKE1/DrsgZ
        x+gAgOpoEGypv/KWdMyHdGM0vDfJ1Gt/7LKpsA1ttZuYkwxA1/qj1/Dqedmxfz/7dKgL3mfV1ATvA
        T/0KIQwQ3kFXYgL7GZ/nNN74WDjHTdOqWMQ9TRyNwLkdABR3m7QVJeiU5xIuviKixIgzzPaujQv86
        yA23btdPJH1Kv8VktIBvItdxyvxPp5OSyLqG0R0XrYE5D0nhh68Gci2eRnVxVk/J22CtGlW5DuST0
        HZ9G7yoA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIp1S-00007Z-1a; Thu, 17 Sep 2020 08:12:06 +0000
Date:   Thu, 17 Sep 2020 09:12:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: check dabtree node hash values when loading
 child blocks
Message-ID: <20200917081205.GE26262@infradead.org>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
 <160031331944.3624286.5979437788459484830.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031331944.3624286.5979437788459484830.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:28:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xchk_da_btree_block is loading a non-root dabtree block, we know
> that the parent block had to have a (hashval, address) pointer to the
> block that we just loaded.  Check that the hashval in the parent matches
> the block we just loaded.
> 
> This was found by fuzzing nbtree[3].hashval = ones in xfs/394.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
