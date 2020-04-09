Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E648C2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01748206F7
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pn6Q6MgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgDIHiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 03:38:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51520 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgDIHiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sPEdemIc39ToBVwKG/L4gBdLzhTYw5W3DC4Tnc03+tw=; b=pn6Q6MgDtcwD91leMHauXlYe8V
        POfAM8TFNNRnM3oHV0pPFDTr+ar8qEdsGSum+m5+65d7yiWrjrgk+x9CHOySF4OSUz6T/3HCBS5cx
        cfEWMG8g5nO3bdIDNOCQXRYOYfWZ8Vs1dmaBvNw6HvQgq28xTFxoS4agQCRZKy2cJ+H46AnBMxCa7
        vaPFRm9m6Zl4vh1QXfKQQI9x8m4zwEVdWXAqVHI7pswfhEytz0oMRDOSw+A9BBw393aYPbsukKDeA
        9JiMY5LMqFRVsexz8KLZPUFVzf2nRvLeVbHtJ3MmZPoRZGn8RQ135umrGvuJNFbPsAinY197e3KZ1
        IlLvvUeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRl8-0005UD-Fp; Thu, 09 Apr 2020 07:37:58 +0000
Date:   Thu, 9 Apr 2020 00:37:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove unnecessary variable udqp from
 xfs_ioctl_setattr
Message-ID: <20200409073758.GA21033@infradead.org>
References: <1586407403-32567-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586407403-32567-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 09, 2020 at 12:43:23PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The initial value of variable udqp is NULL, and we only set the
> flag XFS_QMOPT_PQUOTA in xfs_qm_vop_dqalloc() function, so only
> the pdqp value is initialized and the udqp value is still NULL.
> Since the udqp value is NULL in the rest part of xfs_ioctl_setattr()
> function, it is meaningless and do nothing. So remove it from
> xfs_ioctl_setattr().
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
