Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689A781838
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lESuGVML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FD9C433C9;
	Mon, 18 Dec 2023 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702903444;
	bh=Lm9wf+Cbdp93HzvB1oaTkNHqeu2TQT26eL8BBuqB014=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lESuGVMLdST3MeFvHW7JUbF5p5btRQfvtz88eG+8ubmqhXvRvb43o5FEE2Iti+UrP
	 j1qqesiJHed2Eilk9F9Xge+yCUCv3PrUxaGUSpchshsA7vuOg/J0EdEzLlPpHiRpUX
	 x0zgevA92P1sxwAGkH8HIcEMXNTGRd3sN0+khW7J4B8f7OH54zledKqMhIshktUwAH
	 kioTsV1NFqzIVE5lO8GTX0xh5WB2jHDGsdO0Yk6JNZ5kqMDii/HZIBf8QrisD15rIY
	 KoaCOSE9f3b9T8xXjVeTCClpa4CXorgjf/DgtNtWddDJVNxhLvC+y94dKg1/D+6Olv
	 XPRdL4J21ldog==
Date: Mon, 18 Dec 2023 13:44:00 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/23] libxfs: remove the setblksize == 1 case in
 libxfs_device_open
Message-ID: <gldm6wgidqpzsstgi7uoghaqfvlidct5tilffao225ctenrj5d@tsixwszghqzz>
References: <20231211163742.837427-1-hch@lst.de>
 <LfVlF5eqA8_4dyzA4qZGXYKjT-7jDzPsK2FRnArwO5vLWnBO-2pCTyggf7iMCJZZMJ_BsiXzWg_XJWvAVkKM7Q==@protonmail.internalid>
 <20231211163742.837427-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-16-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:34PM +0100, Christoph Hellwig wrote:
> All callers of libxfs_init always pass an actual sector size or zero in
> the setblksize member.  Remove the unreachable setblksize == 1 case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/init.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index de1e588f1..6570c595a 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -125,10 +125,7 @@ retry:
>  	}
> 
>  	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
> -		if (setblksize == 1) {
> -			/* use the default blocksize */
> -			(void)platform_set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
> -		} else if (dio) {
> +		if (dio) {
>  			/* try to use the given explicit blocksize */
>  			(void)platform_set_blocksize(fd, path, statb.st_rdev,
>  					setblksize, 0);
> --
> 2.39.2
> 
