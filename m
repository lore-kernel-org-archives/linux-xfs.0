Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10C7CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98AF62080F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CAFu8BdS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfKEAoj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:44:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbfKEAoj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 19:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MfQsOXKFRUlVmZ8kGyehzpYpZhWqETsJ7kVtMfix1Ao=; b=CAFu8BdSEUy3rSxrCDkO1faHb
        i66TodEo/WuPQRc+BThw+7Fqc73TRgii22cKisnzy7gPl+PwRURDwfBTuazWtZcmuY1q3pd6btoLG
        g108Z6zOa5LjU7RxWVL2q2AjU8ccQNW5JZ8D6ellXjIwORtwvxA9qbRb9l6IBN6FjaUkH5vvKLvii
        HH832q4l4tRl1OoK3++yXsW5eNA6fXWdSp33DC2Z5kRjJ8VUzChvpGPGuknXxWinMvRRas0OeqB78
        0ma8xMJZhOgE/GvZ85g7qtunuAHdiu8HlbwqK8wnsLBmPRieFYHN3WQ9H37QIwT91W2ZjTdD5mH8N
        lK+P25EBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRmxa-0006HV-U4; Tue, 05 Nov 2019 00:44:38 +0000
Date:   Mon, 4 Nov 2019 16:44:38 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: add missing assert in xfs_fsmap_owner_from_rmap
Message-ID: <20191105004438.GB22247@infradead.org>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281985693.4151907.15767461539661066081.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281985693.4151907.15767461539661066081.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:24:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The fsmap handler shouldn't fail silently if the rmap code ever feeds it
> a special owner number that isn't known to the fsmap handler.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
