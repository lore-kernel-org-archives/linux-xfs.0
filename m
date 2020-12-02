Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978D7C64E7C
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 08:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F83A20872
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 08:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbgLBIGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387654AbgLBIGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 03:06:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C2DC0613D4;
        Wed,  2 Dec 2020 00:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z9KqhaAsXAc9JurpkJ+8oS6ooAn/GC5FmBHauam3UMs=; b=ZSw0Avvkh7WUOglt9xE0h4fhwy
        ByX6PKX0a6yiwAoUtW+SIz61a7zESvPeJJgIrAiiTH9mOe1Wu80EGtMm1R5AuDG0Nxesrph/yNI7p
        d0YtYWvOVHPazt44kGi8cw6rbKjfzrTvBu5r4TgPoaoOi1gSsw8g7IEVAkZZPp8cszjzBpjJz9ZKw
        hea+uo4zl0y2O3nkgDDjYp5aeF34yNI0jTe4U5a9xfjLbQnj0VrTykUpSz6oLPVwwGWH8ek5BDAeo
        igLpxtI5vP/SGTWqoB8z6J6pQ2ZI50Zwn/8/ynAOsaqkmQ4iaspus6QchMckGuMKngqD8dcDlEg9Z
        xTwlHGEA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkN9H-0004W1-9I; Wed, 02 Dec 2020 08:06:03 +0000
Date:   Wed, 2 Dec 2020 08:06:03 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     torvalds@linux-foundation.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>
Subject: Re: [PATCH V2] uapi: fix statx attribute value overlap for DAX &
 MOUNT_ROOT
Message-ID: <20201202080603.GC15726@infradead.org>
References: <3e28d2c7-fbe5-298a-13ba-dcd8fd504666@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e28d2c7-fbe5-298a-13ba-dcd8fd504666@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good for the urgent fix:

Reviewed-by: Christoph Hellwig <hch@lst.de>

We can keep debatting about stx_attributes_mask for a while once this
is sorted out :)
