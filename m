Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EB0C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 21:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiBYVsu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 16:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiBYVsu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 16:48:50 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DE091704C7
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 13:48:17 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BECA215D7E;
        Fri, 25 Feb 2022 15:47:22 -0600 (CST)
Message-ID: <14ebf74f-18a6-1721-050a-25ce5575a02c@sandeen.net>
Date:   Fri, 25 Feb 2022 15:48:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263814439.863810.11076153423409347035.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 09/17] xfs_repair: explicitly cast directory inode numbers
 in do_warn
In-Reply-To: <164263814439.863810.11076153423409347035.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Explicitly cast the ondisk directory inode argument to do_warn when
> complaining about corrupt directories.  This avoids build warnings on
> armv7l.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

The fix is fine but there's no casting going on, you're using
PRIu64... *shrug* did you intend to cast it? Probably not since
every other instance uses PRIu64.

I'll fix up the commit log if I remember.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/dir2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index fdf91532..946e729e 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -1358,7 +1358,7 @@ _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
>  		}
>  		if (bp->b_error == -EFSCORRUPTED) {
>  			do_warn(
> -_("corrupt directory data block %lu for inode %" PRIu64 "\n"),
> +_("corrupt directory data block %" PRIu64 " for inode %" PRIu64 "\n"),
>  				dbno, ino);
>  			libxfs_buf_relse(bp);
>  			continue;
> 
