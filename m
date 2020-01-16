Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD00C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 280AD2077C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F+ecHvmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgAPQRf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:17:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAPQRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9APlMuXveBHjBRzxCtchH2z4h9TukPVMHCUzDdKeiXU=; b=F+ecHvmOpAgVFz+Q+qKE6WS+j
        ABR4xpz8L+LdCmmGbOf51mNpiaD700EtinENYSi9V0BshgeH8y3+OifCHHsCBsWRQzpvsesEpWAVQ
        0yXM8pMA6xIVUSoUA50dW8+DiPjb6ENVL6bH9MvTf5Hu4WORsGHxlyOdSxpOY0FfaHrQhpVfoUkuy
        BO7H67fpwQKQMIvSbwz88+2ZgOt2BDbvni/VtGtH3uWdvTieGj+kNFK9sXE1J8E4lzKmhZlTY6ybz
        TiFDBujn5VyjMO83f4Uu1U8OGaoLVRN2IcQvhollqTujNBX+x9FcXu5bYiZtgXJNsyEBOsSgoTKGj
        KlxKOFgng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is7pv-0004Ee-69; Thu, 16 Jan 2020 16:17:35 +0000
Date:   Thu, 16 Jan 2020 08:17:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/9] xfs: make xfs_buf_get_uncached return an error code
Message-ID: <20200116161735.GD3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910784485.2028217.10962836272956021894.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910784485.2028217.10962836272956021894.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:04:04AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_get_uncached() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
