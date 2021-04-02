Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD65C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A91610FC
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 06:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhDBGoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 02:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhDBGog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 02:44:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C4AC0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 23:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=lQEFRd6bBi3M5ZoATcvu6mhc5O
        NiX/g74dBhIKlJTfsjw7RM97M0e3gKkdMqr6Eyri1h1BhHHFpDo9m/QCM12+stu1E5Tjx1/Zn/p77
        wxYJLZ/aL5Lk46D5rPNw8oyVn2B3SJ1VGU5ZVVXakqFb9gE55GlogzjqC5doOfRqoAu69a9I0ynJz
        kfab6xNwbClnq4uhYlk4UWehB9PoMHAnBQmV5i4cDfhuWaamEgGsppCfXGox4hKLLt5BLHy5lqL5H
        BG2rGwy5IPf1W6ti8VpKJKqfCBXxM/GA76Vn06IS/3Jii6YNf9GfrmUV6hCsxj40ZKINR3DqKXeKu
        aWR4ubSg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDXh-007Ics-LR; Fri, 02 Apr 2021 06:44:30 +0000
Date:   Fri, 2 Apr 2021 07:44:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: Initialize xfs_alloc_arg->total correctly when
 allocating minlen extents
Message-ID: <20210402064429.GA1739516@infradead.org>
References: <20210325140339.6603-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140339.6603-1-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
