Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFEEC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60807218DE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BnHyddMy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbfJIPFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:05:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIPFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+239ZiTVp6w+QoXwDSyX4tsa+xBLxH3KiGN6KSazgbA=; b=BnHyddMyd//QXtqYgGHJKM3Ya
        Rjoi/twSUK4xL5wYymXeISkg3JtX71pmsQeItl5+5NE7294pLMBDO0eDd94uIcV4Q8vIKkk1dN0xc
        mcnVV36ojYaEXcOGynp0MHRjgF5dE/LhMxA8/3a3MGz8nQLZc8XUN9fjfyhvBBHpGO/KNrejVsSYV
        kL+F9Ix6L+hoHR4O0tf6b9h0Od8fOqQc0l+Dt87foL3m2vMRGNNGYu37kx/ljJOTmkUIO67TwJ6zQ
        JZ4HLu4Flm3OunY4Fz1khFveoKGDoJwcxOgWV3C9jzmHqgxsPgN/lUX8/IZ3kixo9P/70w2KeP1oC
        eVcPexMQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDWt-0001D1-So; Wed, 09 Oct 2019 15:05:31 +0000
Date:   Wed, 9 Oct 2019 08:05:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 13/17] xfs: mount api - add xfs_reconfigure()
Message-ID: <20191009150531.GI10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062067944.32346.8228418435930532076.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062067944.32346.8228418435930532076.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/*
> + * Logically we would return an error here to prevent users
> + * from believing they might have changed mount options using
> + * remount which can't be changed.
> + *
> + * But unfortunately mount(8) adds all options from mtab and
> + * fstab to the mount arguments in some cases so we can't
> + * blindly reject options, but have to check for each specified
> + * option if it actually differs from the currently set option
> + * and only reject it if that's the case.
> + *
> + * Until that is implemented we return success for every remount
> + * request, and silently ignore all options that we can't actually
> + * change.
> + */

Please use up all 80 chars available for your comments.
