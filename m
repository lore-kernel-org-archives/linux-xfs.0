Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C9CC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 325872339D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mg7nVjlv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfIDGHv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:07:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfIDGHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZFOB1omkSv/zbVXG5EyG5nnsvP17g24Wfj1AhR9jy9E=; b=Mg7nVjlvoep8NQqVoK8h/v/lD
        nNrPgpwpuLekcVl55gbvTr9bbEU+ttKR8L/JdUWKs2bFqoHzw/OdbkXBcZyQvB8fOvyRW3zgxp8JN
        gN8cKdGgsqgpeMxKFApLjE9yTKaFgowWPifEnzeRp1VjyRfsYMIDaWIzmcEmkWHduyFzxdyeOzvsP
        sFL8XcpemcRKvRQRs8JS+MRPVIZ48gvzJ6XkFlXadDcZHrEnqzoQO3jmAURRQGbUxNxOloM3No+ID
        3mZqcWXCtgoEqZwX/wJq4nnXvotIOEVtMvAuf8kDMwP8G5fez/PP6aAd0wMwaJqLSRea+aWF1DVTN
        gI31lC36w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5OSN-0004zx-6Q; Wed, 04 Sep 2019 06:07:51 +0000
Date:   Tue, 3 Sep 2019 23:07:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: fix missed wakeup on l_flush_wait
Message-ID: <20190904060751.GB12591@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-3-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good.  I vaguely remember reviewing this before, though.
