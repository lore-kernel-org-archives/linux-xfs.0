Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEBAC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A3A61038
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhHLIIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhHLIIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:08:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4904DC061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=OyLJK8rdvN5sndh3iWimdpg5uv
        TlWAsJsZTBmUdlMNCmxLLn/8cCxKeymnA1qtkQBDRmbsTWiE0R3SKWuwgZ++vaMYdYfd0GSIz4s28
        UesEUtY+wt0J7St2UxD08ERNOIvXjvR23OvapCdzsM5FeuyW1GqJo2mGL/2wJLadZ8KbY9O1bcjbp
        dnQu7qfmB05W0eEfqJnknZPnubU204pnewm40EbQ5/isFMDaewMlY/rdaH5l59mOABwShpILu4Rbc
        FbNjszumtHFDYsnoCm/qhLlVSl9itqCSOOg9Fthj770eMBwaKYWOog8jAI4SN538INnsE/Ng4VBIB
        E2TNru0A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5kP-00EKVs-Si; Thu, 12 Aug 2021 08:07:50 +0000
Date:   Thu, 12 Aug 2021 09:07:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: consolidate mount option features in
 m_features
Message-ID: <YRTWwcCaMpOb7WTD@infradead.org>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052451.41578-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
