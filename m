Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0046C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 18:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbiDFSET (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240049AbiDFSEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:04:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573861CFC1
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EByvRETAMJDWHKLBFxlg3xPns397qvEOUjj1INTJsy8=; b=hXrh+4UStud1jsjOMBPvrLE0iI
        RLp7jq1SybIfrJlXB1UoKZuCr+SLaTB5jWoPf1mtQutiTKWt3h4BXxgTs+RFYqLUgcBaWWdQCcNrg
        iCF8MdUyWD5ndjyWEUv+heKv0zJBK92yraBOax0k0oYIMf4pre2w9b314PVHqggythu5MhlPkCIwJ
        YE1Qpu3wDFeAfVAMQIic4RrRMdSepue7Gs7gMF/VdRmQ8SvP7ryhHPoXhHK66p7BD0wpJN9D47ydy
        5bXJLWGvh3a9eBj/CBQJqVue22o9S0SbpGt6qVgPoSfLLRPM7LpXK4zi1nFw2s4wnQK8INKBrrsRZ
        UfD20ZSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8gH-007E3z-02; Wed, 06 Apr 2022 16:38:53 +0000
Date:   Wed, 6 Apr 2022 09:38:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_quota: apply -L/-U range limits in uid/gid/pid
 loops
Message-ID: <Yk3CHM6QDk+c74zZ@infradead.org>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-6-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328222503.146496-6-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Please write a commit log that explains why you are doing this and
maybe some higher level context.
