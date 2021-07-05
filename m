Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE32C07E99
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D0161964
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhGEP34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 11:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhGEP34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 11:29:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C94CC061574
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jul 2021 08:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5QUzovyiu0tpGC4IPHU+Nl1loICgkwghxlR3UCCTA+k=; b=enTeaqU8hEiKmSvJdYprdoAaAY
        QahvSQmQaT4bHFKd48zGuMjz3w46ac/B837xFORv/UopkpKpRXoU+UIvHlSFBMCJ/Fy7R7uOLAm0f
        FNrqhnpO1pfC8kJJ80MuD5NjnmYSv6hzFApF9gkO1viZFGCiz+qtRB5VqvjrNpWnYGLGd1SAk3xCk
        AsFPyJQxlDtFA3MPG3c3m5sBPW9+eSC0V23nLUAdmJhcrW2iSetO1whFmYrDsWBt0dU4zrjDR3Zg8
        PPa044OPeHIQpCtKigZ7TximZyyJeIrDmdVsxFcKDEYHZ1yIEeA99fu6RmSBMU7xjpJaZuZX0/xla
        nGXGjamA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0QUy-00AMJx-UT; Mon, 05 Jul 2021 15:27:08 +0000
Date:   Mon, 5 Jul 2021 16:27:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_admin: support label queries for mounted
 filesystems
Message-ID: <YOMkyEicA+N3rYqy@infradead.org>
References: <162528110904.38981.1853961990457189123.stgit@locust>
 <162528111450.38981.8857321675621059098.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528111450.38981.8857321675621059098.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:58:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adapt this tool to call xfs_io if the block device in question is
> mounted.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
