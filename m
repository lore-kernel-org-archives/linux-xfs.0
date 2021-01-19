Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27074C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 15:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C19E523137
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 15:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbhASPlU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 10:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390277AbhASPhY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 10:37:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8398C061574
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 07:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=C3X4txeQ7lGyC88FvVq6TH8NaB
        xBoo8zz4z9FlUGOXy8snb/kTCB7AufH5RxH5nk9MSB8UQXEtNZhsAsLP+O/abCAlUSJOec/fFSP3w
        +NhCBPA3ZS9NpNvcgRPc1OMtBA+o9u19PAed9XXFzibbvjAudWiH6ATswH/8KbErOfc29oxW5zgPV
        5CJaLRfZ5g4BNNLU/WBL1p19p3fTNTjx25hxol2F9D3eAwbx0F30VnjrXEvwwT9r9tStGqWNcw2ol
        8TjBeVHn4oY+q6+E+uWr9ufefHyUEYAaQgUj4zD77erCqyBQMCXMFi9NTUEnNrd6v2+Xyu63Q7klI
        QKY/0R4w==;
Received: from [2001:4bb8:188:1954:3126:9c25:fe7d:c7d6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1t2J-00EVFJ-4r; Tue, 19 Jan 2021 15:35:58 +0000
Date:   Tue, 19 Jan 2021 16:35:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: cover the log during log quiesce
Message-ID: <YAb8Mp2QCNp9Cv0g@infradead.org>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-5-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
