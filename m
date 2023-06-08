Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EACAC7EE23
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 14:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbjFHOq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 10:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbjFHOq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 10:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599A82136
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 07:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3A5160AFF
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 14:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA23C4339B;
        Thu,  8 Jun 2023 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686235585;
        bh=LoGB5DUoqXnxx/NNW/S9y5SDv6IVl+Gf8wcju1Zd+Jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0ap29/3kjKELlf5jpgcKJjfTkOjwPIrMeh7lUsLr5TyYR7MbUKQQqrmszSx8KRW9
         Tnbji3R5944GLTF9D6lKypCla9xtPN5VVz8KO7n4mfrlQQpQV/kaYKozWdbb0NfEzA
         Mjsrvuhuswd9yZ9BEai+FVvRO57uM0rQ6cw7hgvCk6+uZqeKQkvOZL5STrNXdKX8K7
         iyBTcHclVAPrmaGTAZXCcxS2fonrigkEsVt1+PKMqLskEtzTiJ50homMJfi+c12GQY
         O8ocnuajbT8NkXxm6hTOavdIfifR7Zk8oKNdtEkqEt+piPntimaFSaxRSlKOm/4qKV
         0VCoCioGsfEcA==
Date:   Thu, 8 Jun 2023 07:46:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Weifeng Su <suweifeng1@huawei.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, sandeen@sandeen.net,
        linfeilong@huawei.com, liuzhiqiang26@huawei.com
Subject: Re: [PATCH v2] libxcmd: add return value check for dynamic memory
 function
Message-ID: <20230608144624.GU1325469@frogsfrogsfrogs>
References: <20230608025146.64940-1-suweifeng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608025146.64940-1-suweifeng1@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2023 at 10:51:46AM +0800, Weifeng Su wrote:
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

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Changes since version 1:
> - Modify according to review opinions, Add more string 
> 
>  libxcmd/command.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/libxcmd/command.c b/libxcmd/command.c
> index a76d1515..e2603097 100644
> --- a/libxcmd/command.c
> +++ b/libxcmd/command.c
> @@ -34,6 +34,10 @@ add_command(
>  	const cmdinfo_t	*ci)
>  {
>  	cmdtab = realloc((void *)cmdtab, ++ncmds * sizeof(*cmdtab));
> +	if (!cmdtab) {
> +		perror(_("adding libxcmd command"));
> +		exit(1);
> +	}
>  	cmdtab[ncmds - 1] = *ci;
>  	qsort(cmdtab, ncmds, sizeof(*cmdtab), compare);
>  }
> -- 
> 2.18.0.windows.1
> 
