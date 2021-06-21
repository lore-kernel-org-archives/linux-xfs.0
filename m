Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457E0C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F7E06108E
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhFUFWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhFUFWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 01:22:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51F8C061574
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 22:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ACOKAR/jemk0c8n3dt7fWn9OsMNIgDn9l9hVNA+aC14=; b=pt3Up9diQrrxSBj7RuHFTIgvB5
        4xwxj1nJSCTCQnCDheqIJzil4ONrxNHgyatzc7kh0qWYHsFZOFsPnhuLmVbN1tgxwWSYIrV20teK5
        b1WD56eKyQGbn3OTlpQlhOi973FB1ctc5RP1TxKPBK5i/WAm76DEOaH/PNDtQ5SJ/Fds2rntAVO+j
        5n7oI50Nc/XB+G/Zik/xoMRVIe12NeOKAck5l8xQ2UYe6dBmZUp2UNbuT4B99YJhYDBttfxvPv5eV
        670nZkXB//4xxXi9uNaQSpimbZwFrm6ZrvZIB7FJgZM5QbALQOMoGWstODTHZ43LggHtF0zH8/UqU
        QHYRVL+g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvCL3-00CkJy-GA; Mon, 21 Jun 2021 05:19:16 +0000
Date:   Mon, 21 Jun 2021 06:19:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 06/16] xfs: defer inode inactivation to a workqueue
Message-ID: <YNAhUUJp4THloqpm@infradead.org>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360482987.1530792.9282768072804488207.stgit@locust>
 <YMeA/3nXG/bdFoMA@bfoster>
 <20210614192720.GF2945763@locust>
 <YMi8kAJok6ZH71yh@bfoster>
 <20210615205324.GA158232@locust>
 <YMta7aDtYSSV/CPd@bfoster>
 <20210617184111.GD158232@locust>
 <YMym8SfmBHPoFbwu@bfoster>
 <20210618145847.GC158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618145847.GC158209@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 07:58:47AM -0700, Darrick J. Wong wrote:
> ...I think I will look into adding your series on to the start of mine.
> I was rather hoping that hch would save us all the trouble and repost
> the quotaoff killing patches + fstests fixes, but that clearly wasn't in
> the cards for 5.14.

I thought people weren't too happy with that patchset and had all other
ind of ideas to work around quotaoff.  I can dust it off again if there
is interest.
