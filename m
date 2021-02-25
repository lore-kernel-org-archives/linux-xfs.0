Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DCFC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A919664F06
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhBYIVQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbhBYIVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:21:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD5EC061786
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=uTqQHKA2ris0DQV01QFxYam3ZI
        rdeqJE8/2oUrTJBXupv0ftJUGTK0WNWrQ5FZ6Jk/v/KaeuxD6jm2brvrBvO2837J/HYrxZvW/ner9
        LIv735TDg6SAUVYplhtRIvG4TwfkacEaJhKhrQpYjD0tjEC42H/cfGF2jKRrJ/0ePUQPJcVILZ5uW
        ttotAL8IIchi8YKrnJDvWYrz0GiT3OPqSRvlrthLvKBWVr+zDlMHaSRoou7qxLq214niTlEQJ0PHx
        flO/qu8/2OV1FPTk9qeLWD8mrgKc6LFyGvWkrXRbOlR4okODBq5Fi5FKSQJKvCmL0Gs2RcjSM6kjm
        qT5QQSrQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBsB-00ASSb-2H; Thu, 25 Feb 2021 08:19:54 +0000
Date:   Thu, 25 Feb 2021 08:19:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: add post-phase error injection points
Message-ID: <20210225081947.GO2483198@infradead.org>
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404928343.425602.4302650863642276667.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161404928343.425602.4302650863642276667.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
