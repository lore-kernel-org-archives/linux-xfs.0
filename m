Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9D5CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68EA205ED
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="an3yhLxN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440484AbfJYOmv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:42:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440461AbfJYOmv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 10:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Y0JXFEIl0+IqYrk7ZO37aZ1HKW/RaAANLoYANBHkjbE=; b=an3yhLxNge9Bxwruu0XuIEJch
        bTtzxIhrYrHYvMpiEoArEqmlIlctneKZHZ9E9S/R3J0IGpfReo6ng87WX/uFHc/TBs9oG3oGSjhVe
        3sJqZoEY4dk6xVXwzoyiCISfviCrEW7TdqcK1nD+qCMLYnKhksG6+7FcaDTwYpmVd3a806jiri+jz
        HaxoRU3/w43khX2Dj+LZMl1jcR1iobGOU5Z1wFOvRWe/RcAfDjXSnxi46504pTXLJdQRCEI+BREVg
        /rbCwuN00VULAavFeA6b+i/TB+hdtPoZLgM0kYkB0cEXDkb5qsPE3l7M1VKVzaC8FLS5z/VWBUhH1
        MurOBdUqw==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO0nh-00068M-3Z; Fri, 25 Oct 2019 14:42:50 +0000
Date:   Fri, 25 Oct 2019 16:42:41 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 12/17] xfs: avoid redundant checks when options is
 empty
Message-ID: <20191025144241.GF22076@infradead.org>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190349799.27074.795104447849311945.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190349799.27074.795104447849311945.stgit@fedora-28>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:38PM +0800, Ian Kent wrote:
> When options passed to xfs_parseargs() is NULL the checks performed
> after taking the branch are made with the initial values of dsunit,
> dswidth and iosizelog. But all the checks do nothing in this case
> so return immediately instead.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
