Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02FBC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6947B20828
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WQviwaHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfH2H04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 03:26:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfH2H0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9ogpNk9DMEALe7V2/9b+SPF9lZWRgW9aEQ9LVRiB+60=; b=WQviwaHet1i0mI64BB0l5sCar
        CPZPxtHmfn/nCMI5VVyr+3cquCmZ84eXRIoq87V/amYmPFs3lGatfnqkQUhNFxRkPUa38SJbjnT4w
        ztTxVrUCRw+rWU8hMK1jLYWCwzr0XDj65x1Bh5uqXKp1fg3vjmtO8JDKs5cdgbBiKIBoHjx396AC6
        GLnvO6XTo6FvxzgiBY/dnUFVLnQt2PmFLfvv+FjS+KILBGJ3c6fVFVvLwrssR6luj77rMpvly6/bx
        tz6vhlPIfAW52DpLLeql48OnbfP0ep55ILrphwmpnegG8JAwfQ1BBnQILaiNlNLz6irDm18jVLV31
        G9Ey17isg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Epb-0001sL-3S; Thu, 29 Aug 2019 07:26:55 +0000
Date:   Thu, 29 Aug 2019 00:26:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove unnecessary int returns from deferred
 refcount functions
Message-ID: <20190829072655.GD18102@infradead.org>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
 <156685617388.2853674.17040064326231302107.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685617388.2853674.17040064326231302107.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:49:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the return value from the functions that schedule deferred
> refcount operations since they never fail and do not return status.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
