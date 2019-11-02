Return-Path: <SRS0=21/y=Y2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945ABCA9EC7
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 16:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681F8218AC
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 16:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uf3Eg+Z/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKBQS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Nov 2019 12:18:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfKBQS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Nov 2019 12:18:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=g+twjkN+2/8/+C8lMHC8oMEPhPe5l9c6pHBKW279iUQ=; b=Uf3Eg+Z/bRnsI4FgPR7GYIR4r
        n+cKDYDgetsKDrih68RLt8YIqMQ+EQmeBDMxEhHIYR4HodQ8FACslESqHcYn/BRGDQK/7oSbc5fzC
        CRpHcVp1yPwV3Vd6AAds7xG3pG/zqAdNggpOJorF/os55YywsFNg8JNDZHUVqQQPGx0hAXm5j/MsW
        waC+IWGE0URzClLlpXbYlFKAMr05d85WjeKCns5QE5OwRxHxHiMxpQBd5GDUjj869+RcGWq+Bgu7e
        Vz9EZ2lC81tWUVTjIMrdTl1ZZ2NEky5o0NfwlMDup/vAcVY2Dbj+IKdHrzFBcbzh/fNUcADSo7lJp
        g92rtVZGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQw75-0007sA-PN; Sat, 02 Nov 2019 16:18:55 +0000
Date:   Sat, 2 Nov 2019 09:18:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 13/16] xfs: switch to use the new mount-api
Message-ID: <20191102161855.GA23954@infradead.org>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259467145.28278.2633846461195808611.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259467145.28278.2633846461195808611.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static int
> +xfs_fc_reconfigure(
> +	struct fs_context *fc)
>  {
> -	struct xfs_mount	*mp = XFS_M(sb);
> +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);

Nit: please align the argument to the same level as the local variables
below

> +	sync_filesystem(mp->m_super);
> +
> +	error = xfs_fc_validate_params(new_mp);
>  	if (error)
>  		return error;

> -	sync_filesystem(sb);

I don't think there is any good reason to call sync_filesystem if
the validation failed.

> +static void xfs_fc_free(struct fs_context *fc)

This should use the normal XFS prototype style.

> +static int xfs_init_fs_context(struct fs_context *fc)

Same here.

Btw, I think we can just fold xfs_mount_alloc into xfs_init_fs_context
now.

Except for these nitpicks this looks fine to me now.
