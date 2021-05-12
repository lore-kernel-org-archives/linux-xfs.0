Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1496FC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA07D613EB
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhELMBz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 08:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhELMBy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 08:01:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80194C061574
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 05:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hUx8JgX0C+JJgZy62ebEx641Qwtl6uyCC+zo9zcqwB8=; b=DAJf8f1kK8MrT4ZLK+TzIqxEU9
        /j83ceH2P7hPa36rSaiMcrlqUtOvErn+KYBJvFE5636GwjECa5wiKoI9+qLdMmwzdHH1S+ELWzNlF
        rxqGhDvwelzqDfTi8YgXD1qwqPRB7PpjIGCFaQmQaOSH25bmg0kY5CUR1ySFVboYebk4ctjTzLEMS
        TtqmXlgOD2rJ8sSmxyModR18WTMKUjlP7wLPXO9xUwU/1cnKkqlZ/FfGpu6v8ZE+TK9oYY5nVsFs0
        b3zFZn+xk8sDN0M2a/mVPcsHCQQKAhlx90+hW2aDSdhS8VZti/6MWKQucrVLXLgb6z4pYnEyjGqhj
        XDEO0z7A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgnXN-008Etv-Dv; Wed, 12 May 2021 12:00:33 +0000
Date:   Wed, 12 May 2021 13:00:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove dead stale buf unpin handling code
Message-ID: <YJvDWUgZupjoW5Ib@infradead.org>
References: <20210511135257.878743-1-bfoster@redhat.com>
 <20210511135257.878743-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511135257.878743-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +		ASSERT(list_empty(&lip->li_trans) && !bp->b_transp);

Nit:  Two separate ASSERTS are generally better than one with two
conditions and a "&&", so that when the assert triggers it shows which
condition caused it.
