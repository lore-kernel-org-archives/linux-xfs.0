Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E23C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 11:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5D361100
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 11:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhIILlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 07:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbhIILlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 07:41:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44589C061575
        for <linux-xfs@vger.kernel.org>; Thu,  9 Sep 2021 04:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4c2khVOQjrYaRBeeuLES9ctidcPb3oWliST1BVfodBo=; b=pOZDNSGy50wQzGcaXUHzttdyBw
        motN1wrL2IUgPA58sNDTGxP4xU4HxRV85e8I8JPPiZojgxSqsLfBF9I3yzOKNS9kBr/7DQS5/9eI5
        2I792B+I1RGqHGe37JWZAPRf7jVbMKUgKxDygIcP2sP/brI0jlpfWLUpi3t0IoyLzK7UyJ6EW8C42
        BHXcKT7+4q9bCxPAA8uDHrvoelYOZFauPqTnvSBqivxyEDCSYiVb8HGqGeGPh4ESjIifmaC5YJGID
        M5h6oGPacLvi7M+f8VpthMpycw+0KXUyFHbsiIJ0Y02IZqBuIsA149fV00al1pCadQhZwh7Xi5mYk
        +djTMZlg==;
Received: from 089144209162.atnat0018.highway.a1.net ([89.144.209.162] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOINp-009m1o-AJ; Thu, 09 Sep 2021 11:39:02 +0000
Date:   Thu, 9 Sep 2021 13:37:49 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] xfs: intent item whiteouts
Message-ID: <YTnyDZ8mx3ucqKBn@infradead.org>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 02, 2021 at 07:59:20PM +1000, Dave Chinner wrote:
> HI folks,
> 
> This is a patchset built on top of Allison's Logged Attributes
> and my CIL Scalibility patch sets.

Do you have a git tree with all applied somewhere to help playing
with this series?

