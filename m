Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B30C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3757F21D90
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:08:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="owAzIdxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIQIGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgIQIGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:06:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C80C0611BC
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=owAzIdxZD2OhvYkm15PQyIKwlF
        pL1QDRG9z2C6IvjmpA+WP8pTm2oepWeQVO0Rag4AKOR+KEp2locs8+W2VP0s9nytrqboDjZaDwjW7
        a9sXDLn2cbQd3dDd3aK/RryRfa5Cqd+YKk9CfxH3Mi3JOE5PX0XDV6ghbMFsUUK8qI6ZM5Y2nz3dc
        vNiIXhJmqdMb3w+iKI9gSV/kgiikGUc2GE594HkOGIlkbygKM1vHOez1IenuvZHQHPQT9GsYPK6mF
        5mDKJQO0ff4nz2czXv2FYvBBAM6IJbQMQ+vMA3fSsEK5GGx8gKvxDsTeIcIeBURA6iTobzp1weBHj
        HOdWUO+g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIotE-0007uZ-41; Thu, 17 Sep 2020 08:03:36 +0000
Date:   Thu, 17 Sep 2020 09:03:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unused SYNCHRONIZE macro
Message-ID: <20200917080336.GX26262@infradead.org>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-2-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
