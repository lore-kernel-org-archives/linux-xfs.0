Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A22C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A620F206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:46:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GrdrQN4k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgGINqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 09:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgGINqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 09:46:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DF9C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 06:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=faGCveKz9VoF2EiogX0ByRM++EEFDIZxcOzi4Kft7hs=; b=GrdrQN4kZU8ZwqClmvMLrXSwSl
        p/hX5H9y0pMeRojPGZEfEDum+soV844EOkuYmzkBXcE1iUGzTXlZ2ijywCx8uin7hRDZPvEE7QdCt
        B5PZpFb8hOCMnSvSqSPH1ttkkljOWEB/gPHz5HqvYQXYiqpBRCfJ3kVVJuL/2+FqB3UHiQqQTpjG8
        uoU3W3yIUYvLPQLlFCbiQRqHAsVfGzOouCoUNxU34UKFAtN6XU0/bQEUJ1/jOxVn4SLislOAyqdX9
        Ena4KzqOjRH2SF5V0nLdOsANj9zb47yI6CNtQcxaHl6AY5GMiqdxsxkiK3nbncl1cHF296mJb53JE
        NX0QmCMw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWsL-0001Pf-Cv; Thu, 09 Jul 2020 13:46:09 +0000
Date:   Thu, 9 Jul 2020 14:46:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] xfs: split dquot flags
Message-ID: <20200709134609.GD3860@infradead.org>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
 <159398718001.425236.11382626384865972595.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159398718001.425236.11382626384865972595.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 05, 2020 at 03:13:00PM -0700, Darrick J. Wong wrote:
> +	dtype = ddq->d_flags & XFS_DDQFEAT_TYPE_MASK;
> +	if (type && dtype != type)
> +		return __this_address;
> +	if (dtype != XFS_DDQFEAT_USER &&
> +	    dtype != XFS_DDQFEAT_PROJ &&
> +	    dtype != XFS_DDQFEAT_GROUP)
>  		return __this_address;

Why not use hweight here?

>  	if (id != -1 && id != be32_to_cpu(ddq->d_id))
> @@ -123,7 +128,7 @@ xfs_dqblk_repair(
>  
>  	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
>  	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> -	dqb->dd_diskdq.d_flags = type;
> +	dqb->dd_diskdq.d_flags = type & XFS_DDQFEAT_TYPE_MASK;

And this still mixes up the on-disk and in-memory flags.  I think they
really need to be separated and kept entirely separate.

e.g. rename the d_flags field to d_type in both the on-disk and
in-core inode, rename the values to XFS_DQTYPE_*, and then have a
separate u8 d_flags just in the in-core inode for just the in-core
values.
