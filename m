Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DE7C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43D792184C
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RF1x4fH2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKKRtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:49:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:32876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfKKRtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 12:49:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gZGGyhyrEF0YNHtao7ZWAXcSYmomREMNzG6LQE7MWac=; b=RF1x4fH2URWaO5sg+zwhPsmy5
        KZN0zFPp6p1LM8TOe2warUfb2OHOFcICLYTvF/18YgjtTGLkKvsVof1uFHvShSNqqAS/8Vob7lPO7
        zZNCEBZzkYjfXjJp0WnC4lCB0y5rlDLiDgmMM8feKeYC/cIE7dtS2AX6pqsPZBQDsDVni+06AT+q0
        tI9I/d7h8Rm7YQq72R1Gcp0X9K2Sic5+YQP9kE6FlZ47d9wlFG9eYM6txpDiRc/awLqCsBpRueTiR
        b48F+1euoQ5UaLkW3Z6h/zemL52ePdgrnoITs72eCwOjGuXTmH2RoTLriPbDJ8JGiyHS7iyKewf28
        txwI3l68w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUDoa-0007oL-Cn; Mon, 11 Nov 2019 17:49:24 +0000
Date:   Mon, 11 Nov 2019 09:49:24 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 02/17] xfs: Replace attribute parameters with struct
 xfs_name
Message-ID: <20191111174924.GB28708@infradead.org>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-3-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:46PM -0700, Allison Collins wrote:
> This patch replaces the attribute name and length parameters with a
> single struct xfs_name parameter.  This helps to clean up the numbers of
> parameters being passed around and pre-simplifies the code some.

Does it?  As-is the patch doesn't look too bad, although it adds more
lines than it removes.  But together with the next patch that embedds
an xfs_name into the xfs_da_args structure and the now added memcpys
it doesn't really look very helpful to me.
