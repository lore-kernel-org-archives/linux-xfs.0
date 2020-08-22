Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE29BC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6B320724
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RpldNtNj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHVHMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgHVHMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:12:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CBDC061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nUVs025qavQ1HTc0Jsv6n6l1/exeEER1mZEGj9eKrHk=; b=RpldNtNj+NhjDU83PqQ7NeFe7M
        FiByuxVdbDYOlFUG+pRWhMUXcA3PzNWhV8ffKT3CE8aTNzGv9nA5pK9bszgiDAzg3h2wQJ0Dnsyfl
        FhlC/atJxBktdapJwr+Kx66GN8sUeC+1pm+PFy0Oh9ncFhORoVWIeH9mnaFfMnX8Fr2aoxpPD9ilH
        nP7QPvuoXFDy1suetlEtAcWCw+UVwmhzEnl0qZXpzkuZEa0CoVQme1A3Q3qLZfXlF3clCIzHDQzS7
        DHbWwQqv0fQpGJbML0ySeejkEr9DP2rQ428OIvwK/2hyibXvh28IqLOu9PfRGgZFL8Up7G00dnFBP
        5VRSb1nA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9NhK-0000U2-Ss; Sat, 22 Aug 2020 07:12:18 +0000
Date:   Sat, 22 Aug 2020 08:12:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
Message-ID: <20200822071218.GA1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797589388.965217.3068074933916806311.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797589388.965217.3068074933916806311.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index acb9b737fe6b..48a64fa49f91 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -15,6 +15,18 @@
>  		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
>  		"expected " #off)
>  
> +#define XFS_CHECK_VALUE(value, expected) \
> +	BUILD_BUG_ON_MSG((value) != (expected), \
> +		"XFS: value of " #value " is wrong, expected " #expected)
> +
> +static inline void __init
> +xfs_check_limits(void)
> +{
> +	/* make sure timestamp limits are correct */
> +	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
> +	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);

I have to admit I don't get why you'd define a constant and then
check that it has the value you defined it to.  Seems a little cargo
cult.
