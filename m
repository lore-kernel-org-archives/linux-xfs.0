Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF40C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD2564F17
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhBYJIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbhBYJGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:06:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FB5C061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pVLrKSZ/pm4ZOeakWMdbB+csSdUA3rD1nYUteuuc/gI=; b=YzH37Q0ABsgxnzONunDytdhMMo
        AvQkiF8aaZ+gAmjqgIg8exMV7jGEgEDKQ80iFskV2+9QposjiLkIafw0AIVV6aPxOBDk4khyk7QDi
        Okx8WQbwitgK9ZcmcgRAgCDSLlbK0Zu2bRbDlZOLCiQPJqGWpNOlRUpv6Ddwp4UBV/SU2RV8HL03F
        z1iGtgZNVgAKlM0Qab/vbwWCHzRhdAwvOX+vnx/oJI2gom8Ipl/p5GYrZ172hc9ojoyc8ejq97dKR
        KiuVFKA7LCOxQjlmftYnMxgnz9BZKWbiL+VmWUnUdknEttVivsnR0Huco0K7dWiaSkiTOVgkOhMjR
        ORFSDDpA==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCah-00AV43-KA; Thu, 25 Feb 2021 09:05:53 +0000
Date:   Thu, 25 Feb 2021 10:03:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: type verification is expensive
Message-ID: <YDdn6f+6S/wCJDF+@infradead.org>
References: <20210223054748.3292734-1-david@fromorbit.com>
 <20210223054748.3292734-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223054748.3292734-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Any reason to not just mark them static inline and move them to
xfs_types.h?
