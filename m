Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE5DC4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2B52173B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oKTZxHAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfJHHBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:01:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbfJHHBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 03:01:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iiZKXuwHGk1VxEtKt8qd3j65zdKvnRN55Tud9jm6pqo=; b=oKTZxHAXdJiy5LuG9Xe83Djfk
        bBKFK2dp/+H9uSWtW7trj2SLMlt+2zcowydQSHebenZ6qX0ecM7sTr1zVvdS+6gFn0mi0Z2v4DNTU
        EWp8PFCYKuiqlXbLE5Z1lTv392JwtHSz4/D4z33EtNdr0VdoqseA1zDWK8pBq0ugB4qtkIexwJZC/
        mvjUgkIbl9NQhwrhSaNqBAXT19kxIc2Zq1AdvJeRffnul4HUoB3lGnyj5zvtmmRZka8ohaFUIwuaM
        7hrtdA2bfMMpZl5ecw/YUD+ZSXmHwDQa1zwj33S0iDDoj+uhX4nklW/jYG0tfYwPLjMIqz7/Zt3C4
        yQUJedpLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHjVF-00075n-Ut; Tue, 08 Oct 2019 07:01:49 +0000
Date:   Tue, 8 Oct 2019 00:01:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs/{088, 089, 091}: redirect stderr when writing to
 corrupt fs
Message-ID: <20191008070149.GE21805@infradead.org>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
 <157049659754.2397321.4949328613812405852.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157049659754.2397321.4949328613812405852.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 06:03:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> These tests primarily check that writes to a corrupt fs don't take down
> the system, and that running repair will fix them.  Therefore, redirect
> stderr to seqres.full so that we don't fail these tests in DAX mode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
