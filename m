Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E50ECA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2739C2080F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dcM4L/hn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfKEAoS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:44:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42506 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbfKEAoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 19:44:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zlbQH+2y8LoZ/+HLM8Bqt3U7ypSfCQueE9jZw7HNrT0=; b=dcM4L/hn13vPtF4DIJcQeP5eS
        k7VXU8yYekUhZxuAfH7Lc+ewgT1ztqE8IAUZJDfhFwqyk3+rXQQb1tcxJ62a+t9Mh8xNVeCVx0Gmu
        4hAsjUei0Q2fQ5Ppoj2XA2YmCKLhKDr4y33VjD/ovqAqAqzFcvso8i7VfQe8tddbtQWpHCa0YACdh
        riICAb9OeNUreVC0ZUfTcujhQZ0l4okFnovQHgtfkyZADNEsskVmcT4nKu5oM2vh5mtEKPKGvQfCT
        x5yoENCUt5MJASiqEE0Yx9vFyPqwG19qh8xItVp6uZNUuG5Eybje/z7O1PJmjthqZF46g2U+LNw+C
        DhlSe5EEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRmxG-0006Ei-BE; Tue, 05 Nov 2019 00:44:18 +0000
Date:   Mon, 4 Nov 2019 16:44:18 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: decrease indenting problems in xfs_dabuf_map
Message-ID: <20191105004418.GA22247@infradead.org>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281985084.4151907.11548453010559620958.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281985084.4151907.11548453010559620958.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:24:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the code that complains when a dir/attr mapping doesn't exist
> but the caller requires a mapping.  This small restructuring helps us to
> reduce the indenting level.

I have to say I hate the calling convention here..  But the actual
change is perfectly fine, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
