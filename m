Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4A8C4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00A6121848
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tTI8vlr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388852AbfJPIeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:34:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50514 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388921AbfJPIeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:34:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P2mFbLzUzm+snbOe0ehKwNL+XZ2MJ+bHxmr90tRgCCg=; b=tTI8vlr3I/10kpKqLEVgySzh2
        1Yp1wt9awFBpHyNvwCm6dCAl32W+YMQb81BjBEuwNi4cfcqw2HepmRnzaKsWnIsyie7tzrp44+7FQ
        vNkBjE2LGZ58xYiSCHE8qz1PUWq7S0frB2Bk50vhQR3fdPAmI7FSw+6qF5p8HAEpb61ff7HFPcycz
        hIiSKVZMLsQRlpGFDU0bWBV40pMzJOEy/tWZle79i2RqgBFSK19kt/RTtVgEPNxXMLmDGLxwA8DTg
        ulzUpjajvx75AsigDX0M8/VxEDFH58JwnfmfqYd1Zx5zpzS0iS7o0O74erPYuydQt/WLc9KJ/XWAn
        Le33V8GUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKelA-0004Dk-RW; Wed, 16 Oct 2019 08:34:20 +0000
Date:   Wed, 16 Oct 2019 01:34:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 08/12] xfs: refactor suffix_kstrtoint()
Message-ID: <20191016083420.GG29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118648744.9678.4128365130843690618.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118648744.9678.4128365130843690618.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:27AM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so
> the options that have values like "10k" etc. still need to
> be converted by the fs.
> 
> But the value comes to the fs as a string (not a substring_t
> type) so there's a need to change the conversion function to
> take a character string instead.
> 
> When xfs is switched to use the new mount-api match_kstrtoint()
> will no longer be used and will be removed.

Please use up the full 72 chars available for the commit log.

> +STATIC int
> +match_kstrtoint(const substring_t *s, unsigned int base, int *res)

No need for static on new/heavily modified functions, just use static.

Note that both this and suffix_kstrtoint don't really follow the
normal XFS prototype formatting style either.

> +	const char	*value;
> +	int ret;

Similarly here - either you follow the XFS style of tab alignining
the variable names for all variables, or for none, but a mix is very
odd.
