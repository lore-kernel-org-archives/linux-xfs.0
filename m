Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0161253B3
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 09:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SoYUYKwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C2AC433C7;
	Fri, 24 Nov 2023 09:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700817393;
	bh=4rsAAkxi3CfaH/XBQkhGguZZMM9qt5c3r7zISrY8X00=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=SoYUYKwCOgP0pjWKEKjT6zlx6Va9kjapOxAl4EoPMTl52Sz8O6lZ66rq3m4Vu2ZRF
	 vEtEU6aYnw6TapTY4hPPxZrhLabkPOKt3y1PHRNCSXmcsK8AQaPizjutmOGoUD32de
	 jgENWi4KIpRuATyvoqZt/xYw0ZueDpi5c5KA3E/4bftGWyaGf60faJNGls4aRiprG7
	 Jja4c+caTPJGfm6Xs6QaPgXAW9iCqJG6yIeLF6uOHOV+xyYt+gi/IRGA93iVEeg4E8
	 FkdeSD0yVhaw7e9RX/b/6HS3Lh6bsGLGwxjnxBkqfVgQRB8Z891OClXcO0ydPL+kej
	 8G/TOKIPq/+GA==
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445938.1865809.2272471874760042809.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs_mdrestore: fix missed progress reporting
Date: Fri, 24 Nov 2023 14:44:31 +0530
In-reply-to: <170069445938.1865809.2272471874760042809.stgit@frogsfrogsfrogs>
Message-ID: <874jhbwlxs.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 22, 2023 at 03:07:39 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Currently, the progress reporting only triggers when the number of bytes
> read is exactly a multiple of a megabyte.  This isn't always guaranteed,
> since AG headers can be 512 bytes in size.  Fix the algorithm by
> recording the number of megabytes we've reported as being read, and emit
> a new report any time the bytes_read count, once converted to megabytes,
> doesn't match.
>
> Fix the v2 code to emit one final status message in case the last
> extent restored is more than a megabyte.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

Thanks especially for fixing all the bugs in metadump & mdrestore.

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mdrestore/xfs_mdrestore.c |   25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
>
>
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 3f761e8fe8d..ab9a44d2118 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -7,6 +7,7 @@
>  #include "libxfs.h"
>  #include "xfs_metadump.h"
>  #include <libfrog/platform.h>
> +#include "libfrog/div64.h"
>  
>  union mdrestore_headers {
>  	__be32				magic;
> @@ -160,6 +161,7 @@ restore_v1(
>  	int			mb_count;
>  	xfs_sb_t		sb;
>  	int64_t			bytes_read;
> +	int64_t			mb_read = 0;
>  
>  	block_size = 1 << h->v1.mb_blocklog;
>  	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
> @@ -208,9 +210,14 @@ restore_v1(
>  	bytes_read = 0;
>  
>  	for (;;) {
> -		if (mdrestore.show_progress &&
> -		    (bytes_read & ((1 << 20) - 1)) == 0)
> -			print_progress("%lld MB read", bytes_read >> 20);
> +		if (mdrestore.show_progress) {
> +			int64_t		mb_now = bytes_read >> 20;
> +
> +			if (mb_now != mb_read) {
> +				print_progress("%lld MB read", mb_now);
> +				mb_read = mb_now;
> +			}
> +		}
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
>  			if (pwrite(ddev_fd, &block_buffer[cur_index <<
> @@ -240,6 +247,9 @@ restore_v1(
>  		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
>  	}
>  
> +	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
> +		print_progress("%lld MB read", howmany_64(bytes_read, 1U << 20));
> +
>  	if (mdrestore.progress_since_warning)
>  		putchar('\n');
>  
> @@ -340,6 +350,7 @@ restore_v2(
>  	struct xfs_sb		sb;
>  	struct xfs_meta_extent	xme;
>  	char			*block_buffer;
> +	int64_t			mb_read = 0;
>  	int64_t			bytes_read;
>  	uint64_t		offset;
>  	int			len;
> @@ -416,16 +427,18 @@ restore_v2(
>  		bytes_read += len;
>  
>  		if (mdrestore.show_progress) {
> -			static int64_t mb_read;
> -			int64_t mb_now = bytes_read >> 20;
> +			int64_t	mb_now = bytes_read >> 20;
>  
>  			if (mb_now != mb_read) {
> -				print_progress("%lld MB read", mb_now);
> +				print_progress("%lld mb read", mb_now);
>  				mb_read = mb_now;
>  			}
>  		}
>  	} while (1);
>  
> +	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
> +		print_progress("%lld mb read", howmany_64(bytes_read, 1U << 20));
> +
>  	if (mdrestore.progress_since_warning)
>  		putchar('\n');
>  


-- 
Chandan
