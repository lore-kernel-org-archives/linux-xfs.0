Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0711C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DDB164DE3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhBYIfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhBYIe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:34:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0B5C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=fiCF8TmO67bDO3N4q8dR4Sj8cc
        FR+hCurzvS/v9Btq9dd0fvSwVppHS1M9qtcMr0RXp3rseBv7reuTqT2oconUvxoOhhIrbslwQFs7U
        md1jhR+kBBSfZxTi8aYYthm7xG/eB1ZoVTYQl6soO+uj4axU7W7LOSMGA3BOWwZlKwIGr2P70A7jg
        Gl/nSmwObqjgXuiJnvzOKT6T6zbaPSDYjinNlOWI95rnP4SCsy+6bkSUjvvts+LOZxAYHt8QE7gd1
        X8VdfAGr4bicyFidjmGF9yDr4pKThgK16+lZHHdlF7IIrPIAO+V+3SVl6MuB4qsPzxjqBAHD8+14c
        mKKOF5lg==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFC67-00ATI5-8z; Thu, 25 Feb 2021 08:34:13 +0000
Date:   Thu, 25 Feb 2021 09:32:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: log stripe roundoff is a property of the log
Message-ID: <YDdggLeMmcOchqkX@infradead.org>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
