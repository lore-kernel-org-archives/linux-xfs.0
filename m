Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FC6C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0245521848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F8FRJofw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfJIOxL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:53:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIOxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OBr0ntmF5+w2g13H4A9PTtymxUgsxwwcadc2lMouGqA=; b=F8FRJofwGlYFXmNWL84qhzVoh
        P2jjiFuwo2Wa1mTLWsTZg80oTu6tFoIPhOEdvnPxPiVqheFCPEGJvz3vHl10INGQ96V7Pfq+Xqkl0
        W4klthGM7aIBL5SceIwbpA4k/eRQfu1Cl972Bh3Gz+fYQulvjVKAa/xvVu3gTQR5oWOpfINwDHIa0
        vCCh/j7Z87JFDs47FVJC+/0Du4R5TOf/0fdHwjtzuDzC9iIewXmHIVR6N0vzXmkKngDVKJdjbfIOM
        Po96IQSKzzH1yQ4CWeZo8q8mUc3bw5Zsfvh0TIx/FGokIUaUojlDRjKrIT9HJEhr3AMrEdPOiKBPL
        jGw2qQAow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDKx-0004iH-8Z; Wed, 09 Oct 2019 14:53:11 +0000
Date:   Wed, 9 Oct 2019 07:53:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 04/17] xfs: mount-api - add fs parameter description
Message-ID: <20191009145311.GD10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063161.32346.15357252773768069084.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062063161.32346.15357252773768069084.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:30:31PM +0800, Ian Kent wrote:
> +static const struct fs_parameter_description xfs_fs_parameters = {
> +	.name		= "XFS",
> +	.specs		= xfs_param_specs,
> +};

As this isn't used anywhere it will create a compiler warning and not
bisect cleanly.
