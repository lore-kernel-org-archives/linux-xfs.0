Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,BODY_SINGLE_WORD,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFC0C55ABD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0883520825
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NXqDrmfu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgKJSfz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731128AbgKJSfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:35:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0497CC0613D1;
        Tue, 10 Nov 2020 10:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C/pdC8dnj7/DxNoUzPIgMWM627KIfAadaNykJ5h7fUk=; b=NXqDrmfuHmt73MxAH+qV1mWpiS
        qaUGmpY+Rkf5mIULFwdAVrwFGexYHtWFFUekkG9CJaQ8Ky3DH6njd1u++T8eUQ4/M/cHehpir7Gw7
        ZBcpq/ZQZgr9onjI2drq2zGtg3XgzowSfY4XGu6WVpDbd6Y/2mYidBuvbuDaDYid7mgj9+eIgYtyR
        cW0uCTfU6pOhfwvM/vGZ4+lkbj33c3av2JwnBjGH2MYs4ZHT9g7huiBkp2RVURWmQVpFSeOJWo278
        LUdzjrUhSR7A93YNq8CFa4Y5UfeYgNFV+eNMskYzRwON4W/Zvm46v6vXsdUbzP9X7F7E9744BESKA
        yoYAK+Jw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYUh-0002cq-Uo; Tue, 10 Nov 2020 18:35:52 +0000
Date:   Tue, 10 Nov 2020 18:35:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Tristate moount option comatibility fixup
Message-ID: <20201110183551.GE9418@infradead.org>
References: <cover.1604948373.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1604948373.git.msuchanek@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

s/moount/mount/
