Return-Path: <SRS0=wlCw=EG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31E8C388F7
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Oct 2020 08:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28511207DE
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Oct 2020 08:40:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oioJl8Z3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgJaIka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Oct 2020 04:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgJaIjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Oct 2020 04:39:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2991BC0613D5;
        Sat, 31 Oct 2020 01:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2KYQtPplw6W/3CnpjBTM9LqLjfNkHc1YUcaDmPzNR9w=; b=oioJl8Z3T4rBUYDEyTzSkE8Dt8
        JUnwz/CPBmAm8LhTzgQ6trA9/CfGbHBmYJ/EgLNO/N0p+B7zn2Gzy6IRdNCYa0FM6vm2WdADckU4S
        MiEKR2Qpznwsxzjb+gdA1YXxG92q02qEq62Q++l4SEWp5Ci/R6Yf97eObwntk1M/mU2E5oauuVwCf
        v3y7A4JOJc/JRyMJ6XxCZBO9EPPYhaCl/kte0XvZAXS0apwGsQVBkhzP3EKfvz560APaR1EptVTUk
        djd1yJHgjXblffay60JzH3S4nFbwhytaHjdipjXUk+2Hb2GtvC+/vF/20ErVzqwGfD3YkazTcRYB+
        BT7FteMA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYmPY-0005p4-Mg; Sat, 31 Oct 2020 08:38:56 +0000
Date:   Sat, 31 Oct 2020 08:38:56 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Fengfei Xi <fengfei_xi@126.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix the comment of function xfs_buf_free_maps
Message-ID: <20201031083856.GA22316@infradead.org>
References: <1604130915-5025-1-git-send-email-fengfei_xi@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604130915-5025-1-git-send-email-fengfei_xi@126.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 31, 2020 at 03:55:15PM +0800, Fengfei Xi wrote:
> Fix the inappropriate comment to help people to understad the code
> 
> Signed-off-by: Fengfei Xi <fengfei_xi@126.com>

I think we can just drop the comment entirely as it isn't very useful
to start with.
