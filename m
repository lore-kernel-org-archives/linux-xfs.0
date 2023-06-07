Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87475C7EE25
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 14:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240634AbjFGOWe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 10:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241112AbjFGOWa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 10:22:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F69B1FC4
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 07:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3233561BFA
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 14:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B61CC433EF;
        Wed,  7 Jun 2023 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686147743;
        bh=eLJ53iSpj2umYGC199Mz/64ggkPXwQpEKuY4KvKWs9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lhxYbRgcbubD0IBSJcyCmDkT7r/7Yq92p0j0LwM2J4lFdUfTIG7nGMJI5WX70c6bt
         JzgfXHTHCl3GaRBJ6uo/2xK9TRds4sULNiKFdpmXg4GdThIzU8FnLJTNLO0ZGaps4d
         pjRSd5oL428UyPMxIsRnRym0TtNRJ1vxwEIHcKa6sQc+BhfWmYRwflLYS+V0oAHLD2
         65Obq4+Anw9OCEm4NHjGACA8Yb9kV9OYE4DfTwuxd7Rrhdr1V8ANXEC//KJDesZlAQ
         3x2sb0VM7j3IVPYXUgjvd81kZNCqPu/6MTtS3HGFbB9DTN7PuAf1XcyXC1G9jBmeQ2
         G7yxD55WdEKlQ==
Date:   Wed, 7 Jun 2023 07:22:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Weifeng Su <suweifeng1@huawei.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, sandeen@sandeen.net,
        linfeilong@huawei.com, liuzhiqiang26@huawei.com
Subject: Re: [PATCH] libxcmd: add return value check for dynamic memory
 function
Message-ID: <20230607142223.GQ1325469@frogsfrogsfrogs>
References: <20230607093018.61752-1-suweifeng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607093018.61752-1-suweifeng1@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 05:30:18PM +0800, Weifeng Su wrote:
> The result check was missed and It cause the coredump like:
> 0x00005589f3e358dd in add_command (ci=0x5589f3e3f020 <health_cmd>) at command.c:37
> 0x00005589f3e337d8 in init_commands () at init.c:37
> init (argc=<optimized out>, argv=0x7ffecfb0cd28) at init.c:102
> 0x00005589f3e33399 in main (argc=<optimized out>, argv=<optimized out>) at init.c:112
> 
> Add check for realloc function to ignore this coredump and exit with
> error output
> 
> Signed-off-by: Weifeng Su <suweifeng1@huawei.com>
> ---
>  libxcmd/command.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/libxcmd/command.c b/libxcmd/command.c
> index a76d1515..47d050c3 100644
> --- a/libxcmd/command.c
> +++ b/libxcmd/command.c
> @@ -34,6 +34,10 @@ add_command(
>  	const cmdinfo_t	*ci)
>  {
>  	cmdtab = realloc((void *)cmdtab, ++ncmds * sizeof(*cmdtab));
> +	if (!cmdtab) {
> +		perror("realloc");

The string argument should be more descriptive of /where/ we failed.

	"realloc: Out of memory"

Tells us what failed, but not where; and we could probably figure that
out from strace data.

	if (!cmdtab)
		perror("add_command");

	"add_command: Out of memory"

is better at implying that the triager should look for a function named
add_command and start there.  You could even go as far as:

	if (!cmdtab)
		perror(_("adding libxcmd command"));

	"adding libxcmd command: Out of memory"

which gives us a nice long string to grep.

--D

> +		exit(1);
> +	}
>  	cmdtab[ncmds - 1] = *ci;
>  	qsort(cmdtab, ncmds, sizeof(*cmdtab), compare);
>  }
> -- 
> 2.18.0.windows.1
> 
