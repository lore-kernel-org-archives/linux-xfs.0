Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0B2C11D0B
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78B3624670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iB9RAeM1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgBTPoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:44:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgBTPoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:44:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jEHfBLX4PlxWx/IwzJG9P/DrN5rBsfx6J9yEeBiC2ak=; b=iB9RAeM1mu4RlsGt8RuwT6v360
        q17+mCb/f9RySyzi/55UV3BpPiMBHsiH2vNAE+3+f/KDZ1NzsolNmiiBoBfzGDT40dpFG+9/1mWEA
        GZEsgwG26Z6xrFB4ocn8U90Nvsd0Vd1GPXsAAYs3FYKnAiXcYlsbjTKdJd0TooanRP03BbqlrY4gT
        gsb6UG36OdBKLqaDS6GtqAR9356Tnkk0eXihMjsIlbMQBzwbyQWEmiM9ep4EdPM0oNrASBZRkR0lX
        HJz2GlFldOZxSSlAb6hCDhMUpfUdq0YR9VWr78ZcjMZ80yygilBdGeqggdjvbSfTKY8KZy4b6u7z1
        H+Sye1Ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4nzh-0003Ka-Hp; Thu, 20 Feb 2020 15:44:05 +0000
Date:   Thu, 20 Feb 2020 07:44:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Richard Haines <richard_c_haines@btinternet.com>
Cc:     darrick.wong@oracle.com, sds@tycho.nsa.gov, paul@paul-moore.com,
        linux-xfs@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 1/1] selinux: Add xfs quota command types
Message-ID: <20200220154405.GA12757@infradead.org>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
 <20200220153234.152426-2-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220153234.152426-2-richard_c_haines@btinternet.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 03:32:34PM +0000, Richard Haines wrote:
> Add Q_XQUOTAOFF, Q_XQUOTAON and Q_XSETQLIM to trigger filesystem quotamod
> permission check.
> 
> Add Q_XGETQUOTA, Q_XGETQSTAT, Q_XGETQSTATV and Q_XGETNEXTQUOTA to trigger
> filesystem quotaget permission check.
> 
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
