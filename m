Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F45EC25B0E
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 15:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbiHPPUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 11:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbiHPPTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 11:19:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E245C883F3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 08:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CF0AB81A56
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 15:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CCEC433D6;
        Tue, 16 Aug 2022 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660663177;
        bh=eeegv2fDuV7zEvjlf0wuKsA5u6oOoMT2DOzCBr9yjAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A5MrN8BG/GcTAfmrmCjkJFbkFhijHSjc4fMIw0VBteSgQJlPz8R5Ns2wqzeyiUblH
         C8oLGEMf4/CV0CiZSm2A3rYUh8dIPPTixykuWZKJy8B6vXQxqijJH89xGFieBXw4un
         v+fPO+ZmXLlIwWdWL67fLdTKt6BUZoyQkWkoOexdjkGGJt4fbfRdNcdaVLmPeahXrr
         uuCAt3MZ9BNzJbCs7pcR9SYEkkrYOMj2OQpWf6zlAkvDbE9wfJT2LbVhm5ktw9H+2w
         ueG9vEx0kDvyfzzUijavNqXTC7H+niSy1gz9gKA2+HGRq88IvObuVjGU5supeHSZfm
         oW+MjlDRKFlfg==
Date:   Tue, 16 Aug 2022 08:19:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdump: Initialize getbmap structure in quantity2offset
Message-ID: <Yvu1h/dQi9CSft0X@magnolia>
References: <166063952935.40771.5357077583333371260.stgit@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166063952935.40771.5357077583333371260.stgit@orion>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 10:45:50AM +0200, Carlos Maiolino wrote:
> Prevent uninitialized data in the stack by initializing getbmap structure
> to zero.

The kernel should fill out all the bmap[1..BMAP_LEN-1] entries, right?

The only part of the array that's critical to initialize to a known
value is bmap[0], since that's what the kernel will read to decide what
to do, right?

Or, zooming out a bit, why did you decide to initialize the struct?  Was
it valgrind complaining about uninitialized ioctl memory, or did someone
report a bug?

(I'm actually fine with this change, I just want to know how you got
here. ;))

--D

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> There is already a patch on the list to remove remaining DMAPI stuff from
> xfsdump:
> xfsdump: remove BMV_IF_NO_DMAPI_READ flag
> 
> This patch though, does not initialize the getbmap structure, and although
> the
> first struct in the array is initialized, the remaining structures in the
> array are not, leaving garbage in the stack.
> 
> 
>  dump/inomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/dump/inomap.c b/dump/inomap.c
> index f3200be..c4ea21d 100644
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -1627,7 +1627,7 @@ static off64_t
>  quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
>  {
>  	int fd;
> -	struct getbmap bmap[BMAP_LEN];
> +	struct getbmap bmap[BMAP_LEN] = {0};
>  	off64_t offset;
>  	off64_t offset_next;
>  	off64_t qty_accum;
> 
> 
