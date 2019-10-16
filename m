Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0894ECE588
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8353321928
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nCmTIpmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391621AbfJPI04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:26:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391619AbfJPI0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ovNpSy6S1CNF96WQw66tQbLdPndPYypUGKwqkCop4pc=; b=nCmTIpmOkxuFOaR1oGXGm2Nrp
        qE1+vNCKkZmvUO6ZL+h6wlfHqX7xrm5Z4J6Zx/R5oz0qcsOoJwMqV/kQbnq5gGRYW3yBsDn4rd+fS
        F7dt05fhOCOm2us/g/lS3c00sXNrhFhHkbszikAnYYTbtIk0Ta4J6hq2pPfHV9peG/FFxVSqTC85r
        hEEaPxduKC7Kqs04gv+x3wyH85iAC/xyokAm2gkDpWLMTXk50vkvWXUOhhJgYQ0xhOVjcIbPACxHy
        VpqT1lWcnDb/F9oPRUkbwc6LpY0QVrXBtkT5plVQ0XPcFhj/sChLXDlPKxSYSJ20DzgrCiQ8dUTPO
        NYLJGgLMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKedz-0001eT-K9; Wed, 16 Oct 2019 08:26:55 +0000
Date:   Wed, 16 Oct 2019 01:26:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 03/12] xfs: remove unused mount info field m_fsname_len
Message-ID: <20191016082655.GB29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118645790.9678.2717342742220454176.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118645790.9678.2717342742220454176.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

s/mount info/struct xfs_mount/g

in the subject and commit log (and various follow on patches).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
