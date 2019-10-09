Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58EAC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F62F20B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:10:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="frmDNTpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfJIPKc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:10:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58398 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIPKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rWnEiYcXpR7wcjre/SL24EQB/9+iDHfKCzMYhEL9HQE=; b=frmDNTpEPGMGy+9JxIWbXrOG/
        X0HQeFWDpZloF/LnksAfxE3QiPuuI0426LFT/oiJOwDEIMTIZy39Ga4Nfm24Q2tHotLVlaijxWcf8
        Nrxse+NbcSUGIs8VIq/noPklUtk557d/xZGUUtpdLWx9oFN5ceve3x2p2llHHwht6lartWQyL9Es+
        kaSVQagOlYMqnn1hrM3AoHXD7jR4aB+MJgA0ZoHZ5e6U7pfcm7Relkae+yPpv9O4gMkKH7mQZ0INq
        R9qtnsRb0dVVLWF6B5v0uU+noCUYL/F87uESvX2zuhtOGH9gq5dIH00Ha07HPRj/OYYS60MS4KsSe
        NO3YxhcLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDbj-0002zI-RW; Wed, 09 Oct 2019 15:10:31 +0000
Date:   Wed, 9 Oct 2019 08:10:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 17/17] xfs: mount-api - remove remaining legacy mount
 code
Message-ID: <20191009151031.GK10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062070050.32346.18387589090342427440.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062070050.32346.18387589090342427440.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:31:40PM +0800, Ian Kent wrote:
> Now that the new mount api is being used the remaining old mount
> code can be removed.

Needs to be folded into the previous patch instead of leaving dead code
around there.
