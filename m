Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11083C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D815320706
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oBfQxFQD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLXL34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 06:29:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfLXL34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 06:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6CSH0KIjAnKOXgwFxeOf6zq3Fl/DFfMTJRaUxx72V3s=; b=oBfQxFQDQM9Vi4zst44R09DI7
        OTl5u0bIsPcATTkwbPlLC2b9DmwTwScDRbQRtkqKDtXQdQMKORZwZbeuVTTTk0RAWiHrcFn4UlYY9
        0IzUB9/YX2dsZBx9FoWsiSfMUEyoWgZmadVBQB3z0V1EUW/7TKlX/+kd56t8yYcCmjlHTp0sXSWAA
        3vpAi+xKAEm/ReJqjm7dUlaPgKJ65B3qe5HIee/fEhUmvQ/Oufm4qLSo/odXG+ICqQM6mUunzZDcK
        40IDCXdZqngF3fWbs1o0vVZ1lqyIBvd1vawhxoxUS6aeSQnHRF5FxAkshlS14EcxkkDdKoKv2euSl
        ewm2lHxgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijiNt-000256-Dv; Tue, 24 Dec 2019 11:29:55 +0000
Date:   Tue, 24 Dec 2019 03:29:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rework collapse range into an atomic operation
Message-ID: <20191224112953.GD24663@infradead.org>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213171258.36934-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good modulo any commit log issues:

Reviewed-by: Christoph Hellwig <hch@lst.de>
