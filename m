Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9201AC4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57E6C21907
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X86tPaDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbfIRQrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:47:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387733AbfIRQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 12:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BOSzK00bngpKIMIdaRTj5HaOSpN28aQqb+m8ytKHoYk=; b=X86tPaDuk5GUAd+45VOBIASqW
        stP7mULtx7+VcDtJf+z1YhWnq2ZiJYMCesDpYrrq3FMecznUyb9LOh4abpLt8zaNlrVgzZmgqDIgw
        Hm6eKcIAOV1FN1TlcrS7NXKWrCx+hP7LJwL1YK/j9CeBO/XdXtYK5UmTMk0NGXBJ5sZovcVsxPOFh
        vlQXH6yHuEISjmpmJxE/MaT5ZotUEp+8Sddyad09S6GuFQw8voDTZb+Y9u+kT0LcfLnLANwMrADuL
        ayxqNPU6K+ubdTC0ljDtHDYfiif9MNUYx4UCLfb5AAAjAp5haTa36UFSK4YEk0AHhjWCV54xxQwlK
        2Li2OX91A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iAd7F-000703-Te; Wed, 18 Sep 2019 16:47:41 +0000
Date:   Wed, 18 Sep 2019 09:47:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 02/19] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20190918164741.GB20614@infradead.org>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-3-allison.henderson@oracle.com>
 <20190918164408.GF29377@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918164408.GF29377@bfoster>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 12:44:08PM -0400, Brian Foster wrote:
> > +	args->name.type = name->type;
> > +	args->name.name = name->name;
> > +	args->name.len = name->len;
> 
> Looks like this could be a struct copy:

Would it make sense to include a pointer instead so that we don't
have to copy the structure?
