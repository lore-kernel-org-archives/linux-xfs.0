Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD422CA49
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 09:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4U8Fc+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFB3C433C8;
	Fri, 24 Nov 2023 09:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700817365;
	bh=Z7VSf/ZbMzO/xb0oFbhDHxjs7zX8zp2CBaWTtOMQ7O4=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=S4U8Fc+ZAqu+1O0wHRL+zd1JAdzNSUWRiSg9ubBIjdtUvTmJPzcrOOL0y2QtwFnDV
	 btUPxJ3VkBzRi49dnuCSHm8ArTLnssHyUXtmCzM1KKx7/mR73H4rqgycQQ9urCC/Rp
	 2VmdU7KeYL7pZD6L/YkCHNLKHmaCErLAot1sBTOqAoOcLwjXBhVS4V7O16wmsi7pHo
	 kCK53T9K120XVzIh/HYwbzQjqwskhIQ3u21R6LG7hguGMMoR9PqevqvchjP4mI+ky0
	 Wh9ZMGyYq4gQn5r2sxhYi+h7LF2XiwttMHtroRAwXkZcnnEpodwDDzMm816mmxve+b
	 XN/pjKlVC+VjQ==
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069444236.1865809.11643710907133041679.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs_mdrestore: fix uninitialized variables in
 mdrestore main
Date: Fri, 24 Nov 2023 14:41:58 +0530
In-reply-to: <170069444236.1865809.11643710907133041679.stgit@frogsfrogsfrogs>
Message-ID: <87h6lbwlyl.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 22, 2023 at 03:07:22 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Coverity complained about the "is fd a file?" flags being uninitialized.
> Clean this up.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

> Coverity-id: 1554270
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mdrestore/xfs_mdrestore.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
>
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 2de177c6e3f..5dfc423493e 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -472,11 +472,11 @@ main(
>  	union mdrestore_headers	headers;
>  	FILE			*src_f;
>  	char			*logdev = NULL;
> -	int			data_dev_fd;
> -	int			log_dev_fd;
> +	int			data_dev_fd = -1;
> +	int			log_dev_fd = -1;
>  	int			c;
> -	bool			is_data_dev_file;
> -	bool			is_log_dev_file;
> +	bool			is_data_dev_file = false;
> +	bool			is_log_dev_file = false;
>  
>  	mdrestore.show_progress = false;
>  	mdrestore.show_info = false;
> @@ -561,7 +561,6 @@ main(
>  	/* check and open data device */
>  	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
>  
> -	log_dev_fd = -1;
>  	if (mdrestore.external_log)
>  		/* check and open log device */
>  		log_dev_fd = open_device(logdev, &is_log_dev_file);


-- 
Chandan
