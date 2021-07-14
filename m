Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166FAC07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB63613A9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbhGNGUd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 02:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbhGNGUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:20:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1808C0613DD
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=BM9wrDCtMhvrlOurgKvzXVavx7
        waxsEidFNFOcyvG/NTWIilHn8CSS/BphObC3ZWDRsW5oIio+olnMjGvcvI5Sgjb7cCr4wpztCRqPH
        QvGu7EWCBWu5zDpOWtwU9RAIdMhRKZMzvYSuo+vVMjRKBnYMkUjmq0jL9A+Su5Wz7rv8eOcWn9KVr
        klPnNfj9Jf2WEv07EO+ntX2FoBCzm/4DaS8abZXpw11ZBqMTMwIVP81Sm6ZNfYaLiqHlvBHRmz6vx
        rzYO8QeZQ2h3MpdXQ/hjjP5SbtN61R2EmDo9aEmFczJjhmGmKe0T9G8NGnj4fQrAcsHYIonUEkIeW
        tpCBgBYw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3YD2-001utW-Od; Wed, 14 Jul 2021 06:17:33 +0000
Date:   Wed, 14 Jul 2021 07:17:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: separate out log shutdown callback processing
Message-ID: <YO6BeECUDXBuEuUT@infradead.org>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
