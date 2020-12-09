Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA290C4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FAFE22ADC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgLISEr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 13:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgLISEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 13:04:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B430EC0613CF
        for <linux-xfs@vger.kernel.org>; Wed,  9 Dec 2020 10:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OmffREOfdHFSkBilDlmRAzA5dTUVMkhzR4/DIPoisCE=; b=GeZwvbyQ8rDr1wZUY1zfkCLSNZ
        ytD2AKdeWCptFoRtLAL0N8p35F5hariKBz+jlVQ36AtxKIS7j/K7qn4AmuEsWbFo4bXfxdVBUwRhA
        zR7sr8n/pyOo9V+xgmWfpzaxVHv2A5MkzZc6JjVpEcOUnvhc3tKIY+iuyVSgy1Kx7apWl47ANvnX9
        WzhGrVOb7iomAPuyTcGd86Dq/Wa2ohfW3BjsWgdE9K6rWiz56ygOsSG7fe8M/WBaDazsSz88GjPNj
        hCc9VFryA5Q6yZdAqzutgRCzoryaE3K67B3vRI4HIM0H5tJ+FmHYkpkFkJNiavI7oPOFoorSi5B+M
        zkmR/rOQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn3om-0007RF-Lb; Wed, 09 Dec 2020 18:04:00 +0000
Date:   Wed, 9 Dec 2020 18:04:00 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201209180400.GB28047@infradead.org>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729617344.1606994.3329458995178500981.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729617344.1606994.3329458995178500981.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Who is going to set this flag?  If the kernel ever sets it that is
a good way to totally brick systems if it happens on the root file
system.
