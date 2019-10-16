Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E295BECE588
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE02821848
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZzxQFcS6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfJPIbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:31:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbfJPIbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A+GrSjA8Vkl+cFhNnIf5YArn3BvNwbBWAZQ2WWqptoU=; b=ZzxQFcS6TawYStic/9fbeglpY
        DQsBBAgiltBu7N1Zi14k9+1jV/pu7CmkqsEr3nQBk4baChAulFk0Fdb2HQwlQn530nB5sNme9pYA/
        YsxGFhQnkQTCVTgrT3albzL+io6byP8O9UzjOJR2+wdgU1GlEU8MlJ/Jmj1yYrq2xOoI4x4mgf7Z9
        wv64bBlImgStzbnp3wh3KW5+Oq/C7gmlSolbhsGuaaIJeQmR+hXewwgA/aYowLIY0nH04N4e5YIra
        ws1QDMEk5hJ7jNhE+L2M0lVkXRGempM2O8Ttsn/8yh6MAJughfgFqcv0CHU+t5s2UmJ3ieDbXpyBt
        82TjKvqhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKeib-0003VW-Uv; Wed, 16 Oct 2019 08:31:41 +0000
Date:   Wed, 16 Oct 2019 01:31:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 07/12] xfs: add xfs_remount_ro() helper
Message-ID: <20191016083141.GF29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118648212.9678.8527671232668102210.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118648212.9678.8527671232668102210.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/*
> +	 * Cancel background eofb scanning so it cannot race with the
> +	 * final log force+buftarg wait and deadlock the remount.
> +	 */

> +	/*
> +	 * Before we sync the metadata, we need to free up the reserve
> +	 * block pool so that the used block count in the superblock on
> +	 * disk is correct at the end of the remount. Stash the current
> +	 * reserve pool size so that if we get remounted rw, we can
> +	 * return it to the same size.
> +	 */

Please use up the full 80 chars available for each line for comments.

Otherwise looks fine:


Reviewed-by: Christoph Hellwig <hch@lst.de>
