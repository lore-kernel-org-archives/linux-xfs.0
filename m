Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CA4C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A56F22B4D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:41:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tf+JXRdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgH0Glw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgH0Glv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:41:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A98C061263
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9UVm9YJVRM3D5Y55dur+xUnwIIrvTu3PUbX02DYRdCc=; b=tf+JXRdriuoo4SM2ICq7ckzAya
        X90W+54LPoo2stfQovU57dfBUDO2tYadTQzvSSxfimR414WXC5DktJXzmEhOxKn/WfBlHB0TV4/K3
        c2sUi5Vf2rB9MYfXVYXEtqy+VchvGXhp5sDQusx9JYMl4RjJzQJUFy0JStr6kYLH4P1YNWf1tImGf
        DqMhONGdKCHg2LjK7V5bJoz+BZBG+KNhXwDn7pU7lU6jeD3gwDlUmX7DZpnIywxYC9NT0wdJ1o+k0
        Ivt9lsKmL0sCh+F7eGlL3IkFWlV/qelntw3B/PPeRnRX4hm6E922irTxwbhdVXP4uOX7q0GTuP/hi
        NBlEuJXQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBbX-00049p-93; Thu, 27 Aug 2020 06:41:47 +0000
Date:   Thu, 27 Aug 2020 07:41:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH v4 00/11] xfs: widen timestamps to deal with y2038
Message-ID: <20200827064147.GA14944@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


That was quick - I haven't managed to get back to questions on my
reviews of the last one.  I'll just review this series and see if
anything sticks, sorry if I haven't taken account of earlier comments.
