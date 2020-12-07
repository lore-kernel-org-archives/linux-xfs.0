Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986C8C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624602388D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgLGRby (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgLGRbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:31:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9001EC061749;
        Mon,  7 Dec 2020 09:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uKkfud9W1xKzKc1pD6pa9TXvJlrWUSQmihtGunO81uc=; b=cppHYimZIz9CqAKUwG1lwtvlNO
        bf9nPJg79m0R8kMt5I4QGDACSY9NfAjNV4D9Z9kvUBH1SeOPC/52LM/uZmUuzbEklQ4JciGbijWK7
        KWWDOXHSrZsQDGZMuGmffGaDSO96J4FjlrH6vfv9NNNMxL/sJR0jOuZQtPMQBpQTr1MnfSeJrIKxF
        OJgVMR0TuEMabJfLwNzoW5nX3uTBDEsM0TAZZH1mfOnptldSrk2mJgjpTM/ImX5n8FbNBZAq01Svu
        L5nQmccAKe0lW5uo3f18LPjrgfm3k4XaI1oFfNERJG97CFtU3XaBtwavrQFCSHpqm4BHwFmbH5Rwi
        MfkQAIfg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmKLv-0005vs-Q4; Mon, 07 Dec 2020 17:31:11 +0000
Date:   Mon, 7 Dec 2020 17:31:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201207173111.GA21651@infradead.org>
References: <20201202232724.1730114-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202232724.1730114-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Btw, while looking at the code before replying to Casey I noticed
something else in this area of code which we should probably fix
if we touch all this.  We are really supposed to create the ACLs
and security labels atomically with the actual inode creation.  And
I think we have all the infrastructure to do this without too much
pain now for ACLs.  Security labels with the weird
security_inode_init_security interface might be a little harder but
not impossible.

And I suspect security_inode_init_security might be right thing
to reuse for the helper to figure out what attrs would be set.  If
security_inode_init_security with an idempotent callback is
idempotent itself we might be able to use it directly, but all the
weird hooking makes it rather hard to read.
