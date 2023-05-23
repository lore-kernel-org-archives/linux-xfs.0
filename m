Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69C5C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 18:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbjEWSLi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 14:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjEWSLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 14:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5690097
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 11:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7372611B2
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 18:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52605C433D2;
        Tue, 23 May 2023 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684865496;
        bh=si4NgT/BCUtKYJl9TG2RnaZn8hTAi6WpcsSUZ7b1WPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l4zvtByQ0A3V4omJDrrYwiQdS9qzh56C2IZ+NjgCUV+irw799ACBSblsq3f/xwcOa
         KhmZwW4DHH9b3O4tomplERPLsAuJ5BC5rq+cxhIuDxpiYfF/MgChsxh27ZiZqPbNRb
         qJ62pQ6miDsr6Dzn4nNIa37uSXge2reoGjAsiEw1ozBu2KU8SoZe9bu58x3QvXQh2D
         7wCAHxRGbPQMyNaNZQfTGFHhO7qU2JEQiBOh7akUOPcYCB0N1iPo3ljnEClatXq6NA
         qXKLONcEaaGLvpgcvKWLO6im8CIvanD31iHC4ZQPNYSjeru8Cygs3W15PQ8Mx6hyfK
         WC2QZYpS5KHlQ==
Date:   Tue, 23 May 2023 11:11:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/24] mdrestore: Detect metadump version from metadump
 image
Message-ID: <20230523181134.GE11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-21-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-21-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:46PM +0530, Chandan Babu R wrote:

I'll have more to say about this in patch 22.

--D

> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 5ec1a47b0..52081a6ca 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -8,7 +8,7 @@
>  #include "xfs_metadump.h"
>  
>  struct mdrestore_ops {
> -	void (*read_header)(void *header, FILE *mdfp);
> +	int (*read_header)(void *header, FILE *mdfp);
>  	void (*show_info)(void *header, const char *mdfile);
>  	void (*restore)(void *header, FILE *mdfp, int data_fd,
>  			bool is_target_file);
> @@ -86,7 +86,7 @@ open_device(
>  	return fd;
>  }
>  
> -static void
> +static int
>  read_header_v1(
>  	void			*header,
>  	FILE			*mdfp)
> @@ -96,7 +96,9 @@ read_header_v1(
>  	if (fread(mb, sizeof(*mb), 1, mdfp) != 1)
>  		fatal("error reading from metadump file\n");
>  	if (mb->mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
> -		fatal("specified file is not a metadata dump\n");
> +		return -1;
> +
> +	return 0;
>  }
>  
>  static void
> @@ -316,9 +318,10 @@ main(
>  			fatal("cannot open source dump file\n");
>  	}
>  
> -	mdrestore.mdrops = &mdrestore_ops_v1;
> -
> -	mdrestore.mdrops->read_header(&mb, src_f);
> +	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0)
> +		mdrestore.mdrops = &mdrestore_ops_v1;
> +	else
> +		fatal("Invalid metadump format\n");
>  
>  	if (mdrestore.show_info) {
>  		mdrestore.mdrops->show_info(&mb, argv[optind]);
> -- 
> 2.39.1
> 
