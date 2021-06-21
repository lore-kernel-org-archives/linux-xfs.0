Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B932EC48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BCAC6108E
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhFUF3x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFUF3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 01:29:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537E9C061574
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 22:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=LxlggnhqN1mqB9thRZEVEzBFIE
        zTTMPy8dIZDOtpIColoAJgrbzTEiiwHinN9RXC3F131yAtUeUKzDcXDCF7CuhfRQ6IFutvJu3AbPI
        4jPUSQu+nQKniHLclXJ5+yXggX8cGt8lH7/l5/kstc/Q7MA28/jyGUfIloc6TfWqKcYbpz6SFAh98
        G1AQLGVx/2NTEw+oDgAdysJdcZkXH1rQw0BdqbSbIB1yM/62s7AOVPcXXPfxbUA269PD4Y1Z2fgdP
        DQOa7eaSaGvfZk1vLoWAfrtd4bnY4UGqW2WY8sDpp4ZMbbgiVO9/fYUgF6n5gi66YZysCvv4X9vlN
        PdAnWrOw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvCSV-00CkdY-V0; Mon, 21 Jun 2021 05:27:02 +0000
Date:   Mon, 21 Jun 2021 06:26:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, chandanrlinux@gmail.com
Subject: Re: [PATCH 2/3] xfs: print name of function causing fs shutdown
 instead of hex pointer
Message-ID: <YNAjH4CZ/OFe5KIh@infradead.org>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404244503.2377241.5074228710477395763.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162404244503.2377241.5074228710477395763.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
