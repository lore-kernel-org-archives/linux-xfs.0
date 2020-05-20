Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C475EC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91297206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VAK8/qMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgETHRR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 03:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgETHRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 03:17:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDFEC061A0E
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 00:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aP6IOpykMLVFcHdHtiLrwTT9mVr/mE4Txb+ouYXPWvo=; b=VAK8/qMmRhv9vz729RpH2vJn+R
        dvlgGUzQIn2WIvv56QIZNS/L619l3JrOtohhIMsbcVgxc9hkAOZRb1j0AvQv1wv84iJWpESRepJYQ
        f5dZTfijE2pWdSTEsURrJ29wPts7vby+C0wNaJR17Y5w0mkqBCKKs1dyzHrJwFvoIKH3cGSdH3D0O
        jrAy3WNSfTRCutLZnuFqffY0TbIPIsa5kAZXlzHBK1kyZF8x7l5jp2nqPa2wfGk6LgI8ELhpXKaJB
        z8nkjbjUykddo0MOLTOV1TCFHiUPVacRkaQMV4lOCtgxFk8czkKDNd7atijqHWhgPgk0btBiPotO/
        etLsryHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbIyW-0001RN-Bf; Wed, 20 May 2020 07:17:12 +0000
Date:   Wed, 20 May 2020 00:17:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove the m_active_trans counter
Message-ID: <20200520071712.GB7008@infradead.org>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-3-david@fromorbit.com>
 <20200520070152.GD25811@infradead.org>
 <20200520071339.GW2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520071339.GW2040@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 05:13:39PM +1000, Dave Chinner wrote:
> > > @@ -883,9 +885,7 @@ xfs_quiesce_attr(
> > >  {
> > >  	int	error = 0;
> > >  
> > > -	/* wait for all modifications to complete */
> > > -	while (atomic_read(&mp->m_active_trans) > 0)
> > > -		delay(100);
> > > +	cancel_delayed_work_sync(&mp->m_log->l_work);
> > 
> > Shouldn't the cancel_delayed_work_sync for l_work in xfs_log_quiesce
> > be removed now given that we've already cancelled it here?
> 
> No, because every other caller of xfs_log_quiesce() requires the
> work to be cancelled before the log is quiesced.

The only other caller is xfs_log_unmount, which could grow it.  But
I guess an extra cancel isn't harmful in the end.
