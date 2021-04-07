Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E642C43460
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41891613C6
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345603AbhDGG1s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 02:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345587AbhDGG1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 02:27:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6821C06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 23:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qqjhZsQGile4RMU36C07ju8HRn
        3lKdsoGvpU2eRIeGkuK0Nk1fIH1qKDdrCqPAMuLVJjxOY/+lHY9GHm38f2p7oi7HLVSLpMwQX8nIk
        LOdYJ+7b0sKFK3VTk26HjWY96Go2rmMyvt99+vaNMpVfvhsv4AoovkCHaFvW3pSEyg5BREIeci0Dv
        mh/8gkXLXavCeBs7nYEXP8wno7/hvGlWS4ksVMm/lzdztnfS6YI6Z/5QHwX5q5YzE0y9lHwy9yUMa
        bSSNYN5hhOp4uVhjjBbBi4Bf+ZOaRqX9TLWzVGdrJnNphvtWxTg1/qK30yY5iPPUsWilYzntKJLXT
        j6bx+/Jw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU1ey-00E0jz-Ga; Wed, 07 Apr 2021 06:27:30 +0000
Date:   Wed, 7 Apr 2021 07:27:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V2] xfs: scrub: Disable check for unoptimized data fork
 bmbt node
Message-ID: <20210407062728.GA3339217@infradead.org>
References: <20210406065519.696-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406065519.696-1-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
