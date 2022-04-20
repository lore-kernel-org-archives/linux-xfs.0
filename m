Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DEBC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 17:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380963AbiDTRQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351668AbiDTRQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 13:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41FD4578F;
        Wed, 20 Apr 2022 10:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36A8561AAD;
        Wed, 20 Apr 2022 17:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D2FC385A0;
        Wed, 20 Apr 2022 17:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650474799;
        bh=UrSm3QqycrS0q641uRCqw8bVmvICs64KHxJFf/CZPS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dv1YpahZwJ6S8DsAgVY4guLOy/VKetfiAXuiof5BFlhaCMAqMNbLFUu2oUMN1vQwr
         lOW0maIhCbHWqvpS61DxGno5NOivIhJFdP6vcV1GW7GOsmz870ZBcEpzDa/dGrhyNb
         MQFp5QfgK54nzdpIW5lxff1gBCtsoQbccuj+SyrNP/bRbNAASjvA3GESOuyCpMkRpC
         HtZtMorqM4YRPEzj/nxKBQzqUKfHxk+OKAI/wNzjhdZGJtjL1CpR02KeFvaeOwG28n
         R5gq/nwIYDl029h1zYrwDZQdPomuekTGHsGh5SvRRIRtF7TjmbkHL5W0NDtA8b/qNA
         JKw04uGnWmwlw==
Date:   Wed, 20 Apr 2022 10:13:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] src/t_rename_overwrite: fsync to flush the rename
 operation result
Message-ID: <20220420171319.GP17025@magnolia>
References: <20220420083653.1031631-1-zlang@redhat.com>
 <20220420083653.1031631-2-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420083653.1031631-2-zlang@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:36:50PM +0800, Zorro Lang wrote:
> The generic/035 fails on glusterfs due to glusterfs (or others like
> it), the file state can't be updated in time in client side, there's
> time delay. So call fsync to get the right file state after rename.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  src/t_rename_overwrite.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/t_rename_overwrite.c b/src/t_rename_overwrite.c
> index c5cdd1db..8dcf8d46 100644
> --- a/src/t_rename_overwrite.c
> +++ b/src/t_rename_overwrite.c
> @@ -2,6 +2,7 @@
>  #include <fcntl.h>
>  #include <err.h>
>  #include <sys/stat.h>
> +#include <unistd.h>
>  
>  int main(int argc, char *argv[])
>  {
> @@ -25,6 +26,7 @@ int main(int argc, char *argv[])
>  	res = rename(path1, path2);
>  	if (res == -1)
>  		err(1, "rename(\"%s\", \"%s\")", path1, path2);
> +	fsync(fd);

The callsite needs error checking, right?

Also, what's going on with glusterfs?  We unlinked path2 from its parent
directory, which means that it's now an unlinked open file.  The next
code chunk in this file checks st_nlink != 0.  Does the fsync force the
operation to the server so that the fstat call pulls data from the
server?  Or put another way, does the fstat call return stale stat data
after a rename?

--D

>  
>  	res = fstat(fd, &stbuf);
>  	if (res == -1)
> -- 
> 2.31.1
> 
