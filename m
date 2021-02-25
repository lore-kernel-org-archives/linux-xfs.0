Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49FEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7859B64F06
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhBYIOi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhBYIOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:14:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA6FC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=RiUe6gBKRnfUQP4rKJQgDJn2SX
        Y2AjdnIgonjKcBAqvRnOd2k64UjVbHtuRTeuURQioHT8tr1PPQVaVCHcWkRtTurZmhg4D4yXZWhGc
        ZYWJeppJD4Gf/pXvle13ggHG5YmprAkK2QP7h2K0y7+OTctfLWmW2tufi2eI4VScX4nPt7LSv8B/+
        ShrJY6Oqc9brwL6fzcsU7pd1+At+bylUtaRWNb6Ct2J68Wp2KMKV2ze4n1Qo9fnf9T5kbr0I9Mt5z
        I6ft3ywBAPyW1vwwdni8K0q/OmETFuSD93/ZW4A2CoRDJs6Wunm5zGgDohje6lgwniUDjvfBzR3C4
        K/pEvxGA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBm6-00AS5t-96; Thu, 25 Feb 2021 08:13:35 +0000
Date:   Thu, 25 Feb 2021 08:13:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs_db: don't allow label/uuid setting if the
 needsrepair flag is set
Message-ID: <20210225081330.GK2483198@infradead.org>
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404924136.425352.783422563005701204.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161404924136.425352.783422563005701204.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
