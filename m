Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C250C0018C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F56D235FF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgLGORI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLGORI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:17:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11FEC0613D0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Dec 2020 06:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0ks9852gGPoD/ksjecyF0Z5WtNrq3rfsKZvU8vXSyfs=; b=I+EHZ3jZUZ212AGdUhyXGd5v/R
        5rRc3U3EcbIV23pcOtIvQo6G7hkEogkt+INYydpZANNjru9RRvd/az2R2Mtz/b1Dg+RcP6L4fFCkY
        VSRGMI/+o+fU+NyuQf0s6GnDLOWIlECpaxzQYP6G+6WvGiV9iCxJjTbD5hMZcVZnK6ChmcCpkxmwo
        ScucN6yeEPhc5GJetpFbOntgROjiQC7gl8P+ZTxL7CofiVwYlQQTiwYmXAniUcjgbbQqBu5fKVO2V
        kY8PL4OBAJI1UQ4frcdHbeYYOA5BVxRKQ6tmpGb4GMWfL/jfqyQ/V0n1oTxHCwb3Fy03KglznTtWU
        /LDetOMg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmHJS-0002Sv-Kw; Mon, 07 Dec 2020 14:16:26 +0000
Date:   Mon, 7 Dec 2020 14:16:26 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor realtime volume extent validation
Message-ID: <20201207141626.GB8637@infradead.org>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729626316.1608297.11622795343009336589.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729626316.1608297.11622795343009336589.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Same comment as for patch 1.
