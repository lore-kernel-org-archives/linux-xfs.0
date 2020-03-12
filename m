Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D086AC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A32A520663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WSiPrMWc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgCLONw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:13:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLONw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=X3LyyxlYL3mEi9oq/a1IvHPCtmVp3aG4dFOIPk4QMk4=; b=WSiPrMWcqMgyVNk7LOrSSl3/G2
        E9x0+o94OrS+52sUQ8jD0Ii5ALXLolGmG7UiEoILy31Sxyt7wL8ihdz1aW4KzmRFG9iiiJYVvzJI9
        5Ye6H269xrTBqRgJRBLiy405nbJeij2YANei8r4gd8JcjAtywnPAMYzRCIfM7jNuoNBJZHs3SG3de
        eGQBVrbhbVIDZTTKJrD8Hjjb/UASXoi98oV3lHQucnUkglcx0tuIs0QinDfJJqoN9tYYX3lwae5W4
        i4V/COzjsy0C1H3VaMitqW/ogV/BhlJi5FPGej993t777/VIHQvldWXW0fXqvPqDWqTu1GmIPvhIo
        mLMSQjZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOat-0000Gq-IF; Thu, 12 Mar 2020 14:13:51 +0000
Date:   Thu, 12 Mar 2020 07:13:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     sandeen@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: xfsprogs process question
Message-ID: <20200312141351.GA30388@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric and others,

I've recently tried to port my attr cleanups to xfsprogs, but noticed
that a lot of patches from others are missing before I could apply
my ptches.  Any chance we could try to have a real xfsprogs for-next
branch that everyone can submit their ports to in a timely fashion?
Without that I'm not sure how to handle the porting in a distributed
way.
