Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1553CC7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbjEWRPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236371AbjEWRPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E369118D
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B7D3634F7
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE7EC433EF;
        Tue, 23 May 2023 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684862125;
        bh=fe3S72VzYlY6dWnfZolhpJTIEL/gedcVNzeik+kWDz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYsuFWzUVFzWIvC74ewJZPhQXhD/rEosj+9Ogib+jZ8y6Dy4qoBWmtA28z6OlESsi
         Cw1JXtxnPS6tAjMHHHV8gaxa2/GyrUHU6Cw65D+jHdsapaNaGvGYWHPS8HzLeDzUuZ
         vrDEDEi/psqd62WfzV020KCVBWRU57QSGCm3K+omM9npml/iGk36JWL3nYZAP9f6C7
         DzgMLc0UfQv5lGjSMsNCSl3cGsJtOkQozt9MMxUumEUCXjxSCyWoo+QZv1EpbvTvE4
         4leYheoYPg0n+lm0NwMfHqo8Y2CrjypTX4rTyQFIUstkZPIIBsgIwGgvgWsI/rbuRt
         7wEemmuHGv4WQ==
Date:   Tue, 23 May 2023 10:15:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/24] metadump: Introduce struct metadump_ops
Message-ID: <20230523171525.GO11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-9-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-9-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:34PM +0530, Chandan Babu R wrote:
> We will need two sets of functions to implement two versions of metadump. This
> commit adds the definition for 'struct metadump_ops' to hold pointers to
> version specific metadump functions.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 212b484a2..56d8c3bdf 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -40,6 +40,14 @@ static const cmdinfo_t	metadump_cmd =
>  		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
>  		N_("dump metadata to a file"), metadump_help };
>  
> +struct metadump_ops {
> +	int (*init_metadump)(void);
> +	int (*write_metadump)(enum typnm type, char *data, int64_t off,
> +		int len);
> +	int (*end_write_metadump)(void);
> +	void (*release_metadump)(void);

Needs comments describing what each of these do.  Does each
->write_metadump have to have a ->end_write_metadump?

You could probably remove the _metadump suffix too.

--D

> +};
> +
>  static struct metadump {
>  	int			version;
>  	int			show_progress;
> @@ -54,6 +62,7 @@ static struct metadump {
>  	xfs_ino_t		cur_ino;
>  	/* Metadump file */
>  	FILE			*outf;
> +	struct metadump_ops	*mdops;
>  	/* header + index + buffers */
>  	struct xfs_metablock	*metablock;
>  	__be64			*block_index;
> -- 
> 2.39.1
> 
