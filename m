Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DF5C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB4A206D5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:16:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SbdlBx5P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgAPQQm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:16:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgAPQQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MipJCbdfKiSepXLCs6FlQd99vKYELZhN5lajzrlXaR8=; b=SbdlBx5PvwVCJ29ZlmO5iiiva
        z25jjygdY+7cINus2WCVzY/7jz5eeSGV6vtonCZR1QdRIlVebKVdf2Hrf0vuYqZJo3vT1r53oIQUl
        E4bnFrj2QOgzr30sZGlQ6z9po4MQIKGEbEpV7pp9wDqKVHWtnM62RDyT0znUQShaaL2kd0GkG1pDJ
        nXuJES8zvbKFEHOTpGtjmAR64uSVXFODp6ymb34DlXzJ8IX9nq8c5hcptztUWeV0cYH00tqdAL3lX
        Dv2BNOKGf+Tmx2zoIOdXsqLtrEELaSSvlF9fKEgr4o09PSgVeW4kd7YAZPu76dRIDRi3w8ba9rQxc
        jv/66WR1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is7p4-00049t-82; Thu, 16 Jan 2020 16:16:42 +0000
Date:   Thu, 16 Jan 2020 08:16:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/9] xfs: make xfs_buf_get return an error code
Message-ID: <20200116161642.GC3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910783855.2028217.9100808565121356587.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910783855.2028217.9100808565121356587.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:03:58AM -0800, Darrick J. Wong wrote:
> -				 XFS_FSS_TO_BB(mp, 1));
> +				 XFS_FSS_TO_BB(mp, 1),
> +				 &bp);

Do we need the extra line here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
