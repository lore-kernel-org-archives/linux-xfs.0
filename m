Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7F9C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF9BF233EA
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbhATSzB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391908AbhATSyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 13:54:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7537C061757
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 10:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1yh4choBOJVXGyp29sKvMDgBCQIuSDq7Ilxv56fOFtI=; b=q+bP8K07+WZfMTPKnrRFzQnh1i
        50HZG0jEKn0JWaHM8upj8VT5SnLwa/Cen1V2s1GfKOZixrXll+6nUeQp50u91Fdfak4kozAJsWuSo
        FSR2GHUERROuqSc16YBIVDXExj1Cy9vQYpmJM5iX+oh3Aj2h0sErJvzoAtaVfmNQJQ2agT6PfKHHV
        ledtZDgOCtFRX+YKIBLNjpGG2C1BcQAfcDr/UOcQpKoCbUthAQnuIhvFtM03j3+54SfdDdewvQhFR
        ssU4eCjkNEmeD6PjhBSztMdwdVkIfXBbDegn/nvARvyB8opMobZr5BC8xGiIAL+0PakUM1Fuy8mBB
        2sebFCLA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l2Ibi-00G5Hh-Iz; Wed, 20 Jan 2021 18:53:32 +0000
Date:   Wed, 20 Jan 2021 18:53:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Yumei Huang <yuhuang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        sandeen@sandeen.net, bfoster@redhat.com
Subject: Re: [PATCH] xfs: Fix assert failure in xfs_setattr_size()
Message-ID: <20210120185330.GA3832968@infradead.org>
References: <316142100.64829455.1610706461022.JavaMail.zimbra@redhat.com>
 <1492355130.64829487.1610706535069.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1492355130.64829487.1610706535069.JavaMail.zimbra@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 15, 2021 at 05:28:55AM -0500, Yumei Huang wrote:
> An assert failure is triggered by syzkaller test due to
> ATTR_KILL_PRIV is not cleared before xfs_setattr_size.
> As ATTR_KILL_PRIV is not checked/used by xfs_setattr_size,
> just remove it from the assert.
> 
> Signed-off-by: Yumei Huang <yuhuang@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
