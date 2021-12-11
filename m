Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B32AC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 00:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhLKATA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 19:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240722AbhLKAS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 19:18:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37CDC061714
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 16:15:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41285CE2DE4
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 00:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57892C00446;
        Sat, 11 Dec 2021 00:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639181719;
        bh=ZyUlar95COHMX/xhxA/+vFQQ3mjb5UwNDNXHJUiVTdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NxicWQ9YtMVKyCVfL7r06QrDlRvp47oYhxTCVdcI+Uw52sq4ymF6vBQZ2wkazgm1M
         zD5vWkfIonGsX3pEjniVn6nJ70xIfgmkXvXbbqzFzCJEDSkJcS3XKVN5mahvjtE9Ko
         ssOfB5hbgPIbUWzoQzeayyB0XbywGtv6kjXWz2p8y+iufZr3bYmnOPuMfqnPYKZKon
         xe483ZI4atUFQAEGV6OuPidVK4pUmyiJOd8jL9AguZUF+4mB9QYxjrdXj1XpD5biWt
         wM8yFbudRMN/apoi6V6XZ96gCfNFfud2zxlfQe+Wp9V9/FHxb/IFnRCObaW6Cmb/fQ
         2Hb48WcipN+gA==
Date:   Fri, 10 Dec 2021 16:15:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_quota: document unit multipliers used in limit
 command
Message-ID: <20211211001518.GA1218082@magnolia>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-2-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639167697-15392-2-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 02:21:34PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> The units used to set limits are never specified in the xfs_quota
> man page, and in fact for block limits, the standard k/m/g/...
> units are accepted. Document all of this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  man/man8/xfs_quota.8 | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 59e603f..f841e3f 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -446,7 +446,13 @@ option reports state on all filesystems and not just the current path.
>  .I name
>  .br
>  Set quota block limits (bhard/bsoft), inode count limits (ihard/isoft)
> -and/or realtime block limits (rtbhard/rtbsoft). The
> +and/or realtime block limits (rtbhard/rtbsoft) to N, where N is a bare

What is a 'bare' number?

How about (shortened so I don't have to retype the whole thing):

"Set quota block limits...to N.  For block limits, N is a number
with a s/b/k/m/g/t/p/e multiplication suffix..."

"For inode limits, N is a bare number; no suffixes are allowed."

?

--D

> +number representing bytes or inodes.
> +For block limits, a number with a s/b/k/m/g/t/p/e multiplication suffix
> +as described in
> +.BR mkfs.xfs (8)
> +is also accepted.
> +The
>  .B \-d
>  option (defaults) can be used to set the default value
>  that will be used, otherwise a specific
> -- 
> 1.8.3.1
> 
