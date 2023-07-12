Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2990EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjGLRHB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbjGLRHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56691BE3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38EDD6182C
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F94C433C8;
        Wed, 12 Jul 2023 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689181617;
        bh=N0eOXVnzGaI0rdHJbYcqz3Lrc/3spIAxZxvB6jVbUxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NtEt3rr4DjlFsvHPaWyCy/ArGiwxUGkLqLGQA+kP/+9lUjgZTnwYMMxFYkTZuTC5l
         5cu/Dx3TfnAafv4ddqlKnrP/1jhMsrfFVJxV0/oQj8yg0kh3PNgzgP4ObG30LVYb7F
         3kvHRZlUb0CZre+RKBbaskb3BogJh0BIdOI7d54zZhRxmSwWq3VHGG+hhopPIBH1KX
         rZnbTjkLaFbH/0dUCv3pPpL0xTmlwWiqXosOJyghh6ClB+p8jVey//aAzn6cV9K9XG
         eqM8wX+S0jYXH1wi5LR7nOVkHBQMVQZ0tNEasZHiZD7DDFJaxj5i8dHQcfcDdwupCP
         A9bOXsaFDv/Hw==
Date:   Wed, 12 Jul 2023 10:06:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 07/23] metadump: Introduce struct metadump_ops
Message-ID: <20230712170656.GG108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-8-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-8-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:50PM +0530, Chandan Babu R wrote:
> We will need two sets of functions to implement two versions of metadump. This
> commit adds the definition for 'struct metadump_ops' to hold pointers to
> version specific metadump functions.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 91150664..266d3413 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -40,6 +40,30 @@ static const cmdinfo_t	metadump_cmd =
>  		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
>  		N_("dump metadata to a file"), metadump_help };
>  
> +struct metadump_ops {
> +	/*
> +	 * Initialize Metadump. This may perform actions such as
> +	 * 1. Allocating memory for structures required for dumping the
> +	 *    metadata.
> +	 * 2. Writing a header to the beginning of the metadump file.
> +	 */
> +	int (*init)(void);
> +	/*
> +	 * Write metadata to the metadump file along with the required ancillary
> +	 * data.
> +	 */
> +	int (*write)(enum typnm type, char *data, xfs_daddr_t off,
> +		int len);

Minor nits: const char *data (since the ->write function doesn't alter
the caller's buffer); and please document that @off and @len are both in
units of 512b blocks.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	/*
> +	 * Flush any in-memory remanents of metadata to the metadump file.
> +	 */
> +	int (*end_write)(void);
> +	/*
> +	 * Free resources allocated during metadump process.
> +	 */
> +	void (*release)(void);
> +};
> +
>  static struct metadump {
>  	int			version;
>  	bool			show_progress;
> @@ -54,6 +78,7 @@ static struct metadump {
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
