Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C43DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCFDF64EBA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhBYJ2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbhBYJ1z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:27:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF22C061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vdyQh3kh0wQ9QaFdeSdRUbafxU2eCHLU7cgC8v7WPm8=; b=W7cn3WLGWzYQ+Z3v4gjv58Is7C
        fCRQV8n8v+eF5GSfC99Y635gF1ys6oycxzw1tZx5eNWkW/0pymkNCdAQK3JcVtkWxS7COd9w6hDkY
        ctn+c9GlfGn6Q9TkF46vaFfE+fTgo0W1uBWBzXwNeuwaB63cGUPk264Q+gAb8wHcPE1f1p241uxBe
        yF+tB7R/VokzQXpgwOhgiZ2DUb14JsFvgugLdbFZgP0WimH4XPTJiWPH7SzyzRA9NXHTSrClm7lJb
        ltAL6hRdUC5FOVJhQV9B2jl8BUZDgi8xtMNZm/F3hytnMAG9cqgW/LiegJgjHp5O/vL1FTdvEFhTt
        DlNpcavA==;
Received: from [2001:4bb8:188:6508:774c:3d81:3abc:7b82] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCuz-00AWMC-4q; Thu, 25 Feb 2021 09:26:51 +0000
Date:   Thu, 25 Feb 2021 10:26:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: embed the xlog_op_header in the unmount record
Message-ID: <YDdtStHV6kxxobnE@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 05:34:49PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Remove another case where xlog_write() has to prepend an opheader to
> a log transaction. The unmount record + ophdr is smaller than the
> minimum amount of space guaranteed to be free in an iclog (2 *
> sizeof(ophdr)) and so we don't have to care about an unmount record
> being split across 2 iclogs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
