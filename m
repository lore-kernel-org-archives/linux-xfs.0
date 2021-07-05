Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A02C07E98
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D607D613C9
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGEIn4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 04:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhGEIn4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 04:43:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5477C061574
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jul 2021 01:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pnArfTJmUhdKpV3A0HQKYANwH6FjhK4haOZmyz53Eao=; b=lPDUEGykDTe4NuM0GlIDiTFwa3
        3Du8X8GBPrijQM8C8qmjnGqYMky7wtOMUH90YSY62VSNUintXo3yCdmYOtTmbJ3NOb9hpC3JbwGxF
        wYa6sX/MNiw3lKDdVvreuSGSs4EIGBaYN/E9NdYwbwH33vAgvE1vvZXwgDD83DI3rmPwi7VzdCF1k
        meCbsbaI7HkT5RlJ1rTUppk6g2Gut90QXdDZZ7KmlyZFB+MzyMFaWBoQFc76Np4p+dE0IwBM1owo5
        01B3t1iv8bf/EI4LGv74uSPc9s2qQbNa3O7pdi9NNnVMPblV4/vxkgZdVsbt3H0lPTBNrnPirDExG
        tpvU7zeQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0KA3-00A3Hv-G1; Mon, 05 Jul 2021 08:41:06 +0000
Date:   Mon, 5 Jul 2021 09:41:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <YOLFnx0F8xHBjvda@infradead.org>
References: <20210703030233.GD24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703030233.GD24788@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 08:02:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running xfs/168, I noticed a second source of post-shrink
> corruption errors causing shutdowns.
> 
> Let's say that directory B has a low inode number and is a child of
> directory A, which has a high number.  If B is empty but open, and
> unlinked from A, B's dotdot link continues to point to A.  If A is then
> unlinked and the filesystem shrunk so that A is no longer a valid inode,
> a subsequent AIL push of B will trip the inode verifiers because the
> dotdot entry points outside of the filesystem.
> 
> To avoid this problem, reset B's dotdot entry to the root directory when
> unlinking directories, since the root directory cannot be removed.

Uggh.  This causes extra overhead for every remove.  Can't we make
the verifieds deal with this situation instead of creating extra
overhead?  If we can't please at least limit it to file systems that do
have parent pointers enabled.
