Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34E4C48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A413D613BF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 05:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFPFsH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 01:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhFPFsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 01:48:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790DCC061574;
        Tue, 15 Jun 2021 22:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xpI7KfdN2Y5IwYYN5Qvf+CRfPP0wOhcSm39QtBU/I8o=; b=aiumrNNb2i/fL/vmGB/tsvmvC+
        hWbB4kv2TR9k2vBy9NschWwPfnsedLgS2lJA8CTnfJbutN6++X9BthiGRdrjJ37F3VPZtbtGRzKap
        elj7gLymGwvrbu1rpCQCqquLgtTVqcMFSU+Z6FgAzxCfoplYeqonw/d6xAVP41ZcIR5h+/b7NK/Lv
        24slnzf+qg/+DRvSSXvg0GYNjLxuJt4keCVeutjfZdl/2NDSkTe/Kqh1wm4aA/oSXlKl/I5rxB1lK
        NbqlbyvGnM6i8rv4WKuTcZ1VH0F4yAcMEC3ojI03IQGenK2afLZ5IPJmsjCkKSQ92Ahero1tVpHbQ
        lBZnINJA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltOMv-007eWb-RP; Wed, 16 Jun 2021 05:45:45 +0000
Date:   Wed, 16 Jun 2021 06:45:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 06/13] fstests: clean up open-coded golden output
Message-ID: <YMmQBb2twYKhZZpm@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437228.3800603.4686985475787987320.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370437228.3800603.4686985475787987320.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the handful of tests that open-coded 'QA output created by XXX'.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Shouldn't this go before the mass conversion?
