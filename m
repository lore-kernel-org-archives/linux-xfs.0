Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A82DC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 263D521848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JuCb/7ag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfJIOsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:48:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIOsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=i21QDrqD88XCvaeBrWGKeM4eLjZBxbnVJZxZIfq1qVc=; b=JuCb/7agpH/Y+3hkJfnzVkE1J
        rzL2GEeilVnOpD5V4EeHeuxz3ef+bGwJHE7NQcrw3+LCbg62+27WsHuJDLUpnT45jVQi1v4byfJt/
        xUqU927QYs296YQUE/mZgI0KZ7HvZEEHtA8Lfm5NzTJMoE5lbS5u5Ki5SBJpqhA544Q5W5fgAVq6R
        Eu9LochmfxUKps/B/hxmxKJLxtMqwhraF+pBZNcSkwd1ejEMkRD2F7aoYKpqUlD+WDnZfEQMx6RJp
        P9Uxp4bWClLdcgXAqHuYlavktbuj8mTk8B9Fz7jj6QVYfu3qu2LwS84vsJwiphCv3/ePIsQD+/c5j
        DwdTqtRrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDGD-0002u8-OW; Wed, 09 Oct 2019 14:48:17 +0000
Date:   Wed, 9 Oct 2019 07:48:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 04/17] xfs: mount-api - add fs parameter description
Message-ID: <20191009144817.GA10349@infradead.org>
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
> +static const struct fs_parameter_spec xfs_param_specs[] = {
> + fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS log buffers */
> + fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log buffers */

This has really weird indentation, and a couple overly long lines below.
I'm also not really sure the comments are all that useful here vs in
the actual parser.

Why not:

static const struct fs_parameter_spec xfs_param_specs[] = {
	fsparam_u32("logbufs", Opt_logbufs),
	fsparam_string("logbsize", Opt_logbsize),
	..
};

?
