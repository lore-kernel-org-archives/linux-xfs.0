Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDF3CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E264E20869
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XWmdvB4X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfKDTZt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 14:25:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfKDTZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 14:25:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OHxasUpDpCdqolyUrfOi3LgXqBE0B+CXxwl6TrD1kPI=; b=XWmdvB4XukAmKTGD3H3OAkRbQ
        RUdbR8K2INOr0xW33ZOv36STAQgS7foIlebxDBRs3mVbGqFYlaefMLmVLE/Alj++FTcOOxamK4Kdv
        3tFdMzUVuKQMqZV3tn0T8Tj+Vdbn8nLeVDaFWG2DbgYFkG6POzWfGW5NTE+Jxqv56tyx89upM0EYa
        vfaAX6tC4z4126PQMKgjIW1NBEJmleNxCddwsNo8Xl88M/7p+YUF1DkUE10QRgQ8KWFOhqbeT0JLh
        7HVEW5diUKAKLjk/vyveuhewRcT5IbmRT3qnAaZAeSxNu/HVNZhXGJn9QcAuSrIaya2qx28Ud/c1/
        BXeGJ4H4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRhz2-0000Ti-TC; Mon, 04 Nov 2019 19:25:48 +0000
Date:   Mon, 4 Nov 2019 11:25:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: constify the buffer pointer arguments to error
 functions
Message-ID: <20191104192548.GB25903@infradead.org>
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
 <157281983593.4150947.13692433066759624464.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281983593.4150947.13692433066759624464.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:23:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Some of the xfs error message functions take a pointer to a buffer that
> will be dumped to the system log.  The logging functions don't change
> the contents, so constify all the parameters.  This enables the next
> patch to ensure that we log bad metadata when we encounter it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
