Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAB9C5DF9E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A7D2245A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ce+ABOzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgJ1Vv4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:51:56 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgJ1Vvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ce+ABOzZ677iao34HC0NIXjnsf
        cz//DNjP8r3DfYFZh/fiQlc7IGJOAzS1zJMZYZnOvIVW9iqTtcwmlhHid/z5Zh4WwZ83ny/+O2cdh
        BoJxZi70pWUedHLqMBZjKCkjd5qCE9ykekm6fF6Ifyems1p/0d3D5Cp9YT4g7k+93ilZtVNGC4uxz
        dXqEtNkGsQu3yE+ua9uFhiI8/cgUtBAqw8p9ryUGJ0wuNKaalIZ6lqkGO0TkkrubEopTJsS7XXOdM
        aUBa3vn+Mouz/oHdzgb96y8TmL0sFVlkYuGKcrtvNkp9DsiBbk5oQcE3s0JBmtkROdQ4CpE8bSbV8
        0s8EhRBg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXfw9-0000CK-SX; Wed, 28 Oct 2020 07:32:01 +0000
Date:   Wed, 28 Oct 2020 07:32:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] mkfs: allow users to specify rtinherit=0
Message-ID: <20201028073201.GB32068@infradead.org>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375511989.879169.8816363379781873320.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
