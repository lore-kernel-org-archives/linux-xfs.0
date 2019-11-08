Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79490C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 401482178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mv87oYbM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfKHHWw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:22:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKHHWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:22:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e6as8riiFi1+Bnbi+aOAnl8cQ1HAO03EFxv7KsYZT9k=; b=Mv87oYbM/U0uJKaCKAjDySX4h
        I8ZcIZdRiRRzA0NZydedTcxjbOdd9i5+Ot6zE5Spemh7TfTZ6YsAMzrrK+2Z86RRhcCdFFKZgBicR
        HatxzYMN8wbpAoqMFei8KDgzRx/jb1wRr1rwmMHh+IhjDn3LFsVfvHBCVX7zDXFj3faDZz/DX/iIH
        3znn6kq/3n5WSDd5JfvMI5I0TEKX+sm7mQ8Rsh4P6+Xhs1ZMeKtQOJPUtweZidJH4Ap2J69wda+sj
        OUzHKHS72BxifghTq51YDNY/qp4OeEQDHR6lJOj38fmbIyqpPSRmBkwhXxxP2cj2muZEPLm0JUyGd
        lRXa2G30Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSybc-0005Bm-A0; Fri, 08 Nov 2019 07:22:52 +0000
Date:   Thu, 7 Nov 2019 23:22:52 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: clean up weird while loop in
 xfs_alloc_ag_vextent_near
Message-ID: <20191108072252.GB14546@infradead.org>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319669798.834585.10287243947050889974.stgit@magnolia>
 <20191108071151.GA31526@infradead.org>
 <20191108072002.GO6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108072002.GO6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:20:02PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 07, 2019 at 11:11:51PM -0800, Christoph Hellwig wrote:
> > What tree is this supposed to apply to?  It fails against
> 
> Sorry, I've been reworking these patches against a branch that I hadn't
> yet pushed to xfs-linux.git (and won't until I can take one more look
> tomorrow with a fresh brain).
> 
> In the meantime, you can see my development branch on my personal git
> repo:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-5.5-dev
> 
> > xfs/for-next here.  Otherwise this looks fine to me.
> 
> Fine enough for an RVB provided the above? :D

Sure, it _looks_ good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I'd love to be able to at least do a quick xfstests run on
it..
