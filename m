Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19CBC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6996F214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jW3SRZhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfKGSQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:16:07 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42316 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfKGSQG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:16:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gigk+8q1pK59HcU4WOshUtg8qAglWxfLi67IF8PNwdY=; b=jW3SRZhPSdPAEqLnTBDc7QpA4
        AxtV/vXh0tmetxXWRfFQ16fb1R6AvIztrwAXwv9INysodY6rZyEWuY8Z1PiuzllOWybRlUPnKVGkm
        ABGFOXZl2XD4eJckwbJxytGiy75CTKAAhg+fYRZv5ElEyAwv7fwDr1/RsUNBDVLwoiXpVVX0wkKf/
        m560nQcWO8PXDeWzvr5Eh/buVTE39cXGm24PbOsFrqhgUStOk8441HrPP2lrTzXwUFilU5TVUoK6p
        m3sRbjfEHKkoykylxDlCXSKpRKDPC+SG8usdZARKROlm8K4t8GdT2ma5jHSwAJ3bCR1qZGTiJWHgQ
        mQmQMBtiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmKE-0000km-N0; Thu, 07 Nov 2019 18:16:06 +0000
Date:   Thu, 7 Nov 2019 10:16:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/4] xfs: add a XFS_IS_CORRUPT macro
Message-ID: <20191107181606.GA2682@infradead.org>
References: <157309570855.45542.14663613458519550414.stgit@magnolia>
 <157309571493.45542.17191993682067205278.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309571493.45542.17191993682067205278.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:01:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new macro, XFS_IS_CORRUPT, which we will use to integrate some
> corruption reporting when the corruption test expression is true.  This
> will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
> macros.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
