Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B366C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B902220D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JkqWQWIU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIWHIX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgIWHIX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:08:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E010FC061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lN6w1iz1L1cy5q6/1HTlSqnV0temTG53qYUT64+trNo=; b=JkqWQWIUWsxZP7E+8249asiF34
        5Hqu0ywYqmWGdbNspyW4Uppe6MDdFR5YMEarHDZOC4dJC2Ldt71sJLtn/002MkWdnktMXq5MTlHI9
        dHcw2MlRVYMRTXmdn25QFRHeZdE11c2By82jNVXLDsqdr+u0Vr2iMy1oK/QyABzI6J7Q++2viNcQX
        Z2ODyFVy8yI2O5Dg9ZI1LhOuslnHbi30nYGx1LNUzcB3KXPLtq6FYy7GU4IUSCfGYFsMQx4qvYLLY
        Cd5p9/xYrE+iwpsT/V+cEqOBeBt4RLY0Wv/8hzQrcDPdlpI/uogZiMU9F74D0uTwTtKK0AK6zBbDk
        xroH8ghg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKyst-0007ZJ-4z; Wed, 23 Sep 2020 07:08:11 +0000
Date:   Wed, 23 Sep 2020 08:08:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v3 6/7] xfs: code cleanup in
 xfs_attr_leaf_entsize_{remote,local}
Message-ID: <20200923070811.GD25798@infradead.org>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
 <1600844358-16601-7-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600844358-16601-7-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 02:59:17PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Cleanup the typedef usage, the unnecessary parentheses, the unnecessary
> backslash and use the open-coded round_up call in
> xfs_attr_leaf_entsize_{remote,local}.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
