Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFA2C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3786C20B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g/Dcn2EK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfJIPEV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:04:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56808 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIPEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1Tl6j31xxo/KnQrHWYh44uW90pFZtzXOwGnNqyejp2k=; b=g/Dcn2EKN5e12be0cU6LBU/dv
        MA9zAE94FpmW7AybY30xXn7fDoCz2BXD4CLEgOzKG2m70KSMIdbi0FfFSCt6o794TxGiX41gs9pqA
        3zPk99PI5H97HVkUtXseyvchAKm9dspt0PzTATBuD3DjsDBrlv3mmhlkbLLrRRoG8mCCmdxXgUoyz
        BdE2k0V8EKkgtZ4o8uqgx4JP5X1No46figdlgJ1Wx6w2ahmhFyPzb+KdEad6flAwf0zGDEr666yTU
        w6Es7caMBaxt3N3RaA+jGZIsjklYtVaWPQCD4slIAjJdk6mlvsMUWVgbsWsvqoNpD0XdHXPBrNyLw
        /1YnePWWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDVl-0008MY-HV; Wed, 09 Oct 2019 15:04:21 +0000
Date:   Wed, 9 Oct 2019 08:04:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 10/17] xfs: mount-api - add xfs_get_tree()
Message-ID: <20191009150421.GH10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062066316.32346.11258138585168789863.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062066316.32346.11258138585168789863.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/*
> +	 * set up the mount name first so all the errors will refer to the
> +	 * correct device.
> +	 */
> +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> +	if (!mp->m_fsname)
> +		goto out_error;
> +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;

m_fsname_len is entirelt unused.  m_fsname just has a few users, so
maybe in a prep patch just kill both of them and use sb->s_id instead.
