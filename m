Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95110498B8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH462y2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E71C433C8;
	Mon, 18 Dec 2023 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702904131;
	bh=FnQBR3p8sSjxJ9XwkobVzhpzoL+n2HZsuQO+uPju1Hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kH462y2MiKNC+23aF4ZJNDuWFoZbgPo/3sNY9zVvICwo8l/Zy//FJI9bPM/UEUDPy
	 +Y6ObsdCnyRJEEHHx9PfZW28U12dCabdfmJu2bdb1+SSRzEWQOaTDWrdwxAPHa09S6
	 MWEPnqRU4Fzqp8AEBFHipohy7Fip6snSqOAhtVOUPpncop3Y7bK0YQSVeCbRMQnB8c
	 5M/tcC07HNZf2Jplw+hMOFu0daWCySoB9NjeI3cliBTBRSenY3+hsf0/Dv1FoXh27/
	 LbAfxMYARhHYWk8CMs8EHf03QT9ubL9gs0udf9JMCzimCJctuLSjJazdfZE4xexZUN
	 bJwEVZUrV05Ng==
Date: Mon, 18 Dec 2023 13:55:26 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/23] xfs_repair: remove various libxfs_device_to_fd
 calls
Message-ID: <5ozj53d2y3g72x5vwx54cuhwyyxzelsuwqpcsaggmixpj3pzir@fcepcmkqaowe>
References: <20231211163742.837427-1-hch@lst.de>
 <LERgCvAQ9taOydfPxsoF5h8b_MBW_yDs3-ag8zfO-j4u2IlYsineDGSD1liRcml8Z6xukPhLMQsTPYscDhatRQ==@protonmail.internalid>
 <20231211163742.837427-22-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-22-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:40PM +0100, Christoph Hellwig wrote:
> A few places in xfs_repair call libxfs_device_to_fd to get the data
> device fd from the data device dev_t stored in the libxfs_init
> structure.  Just use the file descriptor stored right there directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  repair/xfs_repair.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 8a6cf31b4..cdbdbe855 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -724,13 +724,11 @@ static void
>  check_fs_vs_host_sectsize(
>  	struct xfs_sb	*sb)
>  {
> -	int	fd, ret;
> +	int	ret;
>  	long	old_flags;
>  	struct xfs_fsop_geom	geom = { 0 };
> 
> -	fd = libxfs_device_to_fd(x.ddev);
> -
> -	ret = -xfrog_geometry(fd, &geom);
> +	ret = -xfrog_geometry(x.dfd, &geom);
>  	if (ret) {
>  		do_log(_("Cannot get host filesystem geometry.\n"
>  	"Repair may fail if there is a sector size mismatch between\n"
> @@ -739,8 +737,8 @@ check_fs_vs_host_sectsize(
>  	}
> 
>  	if (sb->sb_sectsize < geom.sectsize) {
> -		old_flags = fcntl(fd, F_GETFL, 0);
> -		if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
> +		old_flags = fcntl(x.dfd, F_GETFL, 0);
> +		if (fcntl(x.dfd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
>  			do_warn(_(
>  	"Sector size on host filesystem larger than image sector size.\n"
>  	"Cannot turn off direct IO, so exiting.\n"));
> @@ -986,10 +984,9 @@ main(int argc, char **argv)
> 
>  	/* -f forces this, but let's be nice and autodetect it, as well. */
>  	if (!isa_file) {
> -		int		fd = libxfs_device_to_fd(x.ddev);
>  		struct stat	statbuf;
> 
> -		if (fstat(fd, &statbuf) < 0)
> +		if (fstat(x.dfd, &statbuf) < 0)
>  			do_warn(_("%s: couldn't stat \"%s\"\n"),
>  				progname, fs_name);
>  		else if (S_ISREG(statbuf.st_mode))
> --
> 2.39.2
> 
