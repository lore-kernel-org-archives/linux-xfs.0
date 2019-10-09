Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57979ECE58E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24949218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qysQKFsc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfJIO4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:56:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIO4D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P9fKwfJOJc66WUvZJINwznOhQo/1DM4GXgd7eW+7yMM=; b=qysQKFscbRcAQWDOOSyqzpeHW
        Y785vf/wOaoy02msg1H6HK1NRXp/Tp/mhX/8FkTkuWoX2JQiQ290c6IWF0ZNDrwE7+VBIH4hrbbmK
        tWoM7MXPbGqsCchFrMM9mPn1G3hY2NlyrUa1rJwB1SibxXCk39/QjnTseVMPflXEZo8a6K1FFd4G7
        GeRXNLluV/K/uZ4EahZyi8H37EM5BDjs6t88lsSblZUkFsMlqG0gk4uXMA/xYvNei4ktfyXRhX6mw
        VBvfhFwRnFm/FPRVUKsRScrHeoanXk35hPrJax/4mJLkSfA1L2wDqfKX9NJxRXFgX5T5duyB/z4HP
        O6IucRo8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDNj-00063l-8s; Wed, 09 Oct 2019 14:56:03 +0000
Date:   Wed, 9 Oct 2019 07:56:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 06/17] xfs: mount-api - refactor xfs_parseags()
Message-ID: <20191009145603.GE10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062064203.32346.8541704132111024167.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062064203.32346.8541704132111024167.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:30:42PM +0800, Ian Kent wrote:
> Refactor xfs_parseags(), move the entire token case block to a
> separate function in an attempt to highlight the code that
> actually changes in converting to use the new mount api.
> 
> The only changes are what's needed to communicate the variables
> dsunit, dswidth and iosizelog back to xfs_parseags().

I think with just a little refactoring we can communicate those
through the mount structure, where we eventually asign them.  That
will just need a little extra code to clear m_dalign and m_swidth
in the XFS_MOUNT_NOALIGN case.

> +#ifdef CONFIG_FS_DAX
> +	case Opt_dax:
> +		mp->m_flags |= XFS_MOUNT_DAX;
> +		break;
> +#endif

This can be cleaned up a bit using IS_ENABLED().
