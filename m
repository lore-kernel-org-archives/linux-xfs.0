Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA98CC4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE98320842
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vDLFk356"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfI3HmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:42:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37496 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfI3HmY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VfPDfHTrrqHmWXreHnVh2BstmzYp+Lf6xY507NqWWUg=; b=vDLFk356wbPoFQzcEGq7oIpBs
        w0oSISwf2jfcK+WFnFVCHAzJ1lTrdJYZ708lUuGDRpAyh/xJ1c8UdTjxRxHqfG1aO4w7+d9mDpL/e
        qlauju25TsoH0hEmsUoLMAnj7oH8kNRxJt5OolDPIlE6sIskNgENi90Vat7epRJB5Phn8Sl2dTnWi
        QnUOpdw+4Wej1ZC+5zP7Nvu+cU/oURxRwS1OTeELBILOK84IceFw7pB0paP6M8kW+vHBgubJtpcUH
        aO0cSmn3hlp8qq9Y37ifkg/Zl4CBmqV6YSI4dSiDSUo94k00QDTyIsrbEKYIAeX1W2qUyCLW4Xw8o
        XtU7FYFHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqK7-0007Gb-U5; Mon, 30 Sep 2019 07:42:23 +0000
Date:   Mon, 30 Sep 2019 00:42:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unused flags arg from xfs_get_aghdr_buf()
Message-ID: <20190930074223.GA27886@infradead.org>
References: <2f4d86a1-0cb9-f859-b120-34d1b511942f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f4d86a1-0cb9-f859-b120-34d1b511942f@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 10:46:42AM -0500, Eric Sandeen wrote:
> The flags op is always passed as zero, so remove it.
> 
> (xfs_buf_get_uncached takes flags to support XBF_NO_IOACCT for
> the sb, but that should never be relevant for xfs_get_aghdr_buf)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
