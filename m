Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716FF182A63
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 20:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720556824; cv=none; b=Tfn+/kx6F2D4Fg3HCww317IK3wjbCv4dinRMpZK0xVihCbfa9CNABkdvO8Dlmfdhl6eev4T+f64nXqZk+eeylkLeDRsff3kLPjtHsoEgD5ZL/W0v5ITL0esCwfjst/kiiZUajL1lqCOW7bBQtLBY1GXSYpMRkc9OFCDH7E8hNBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720556824; c=relaxed/simple;
	bh=/SGgnxBEmySCzNHA/DvdREmjSR8jJ6/d/TJgbPiFvVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLlLcD48h2u6SC0YAImXjUF0RvBdfhfFUm7cvI3JbLn6oJSWyTsqydGihwbet4QnzTBQSoxklDuv8atJPPqLgB4kwMnh6w02ihL1XAJxuREW0Q5c65hANcIzOa7BOEP4/QWM+zNQKTbv2FNgWDUS/JIwPELK64qhD4szchf8hcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2ANeR5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2ANeR5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39792C32786;
	Tue,  9 Jul 2024 20:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720556824;
	bh=/SGgnxBEmySCzNHA/DvdREmjSR8jJ6/d/TJgbPiFvVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d2ANeR5kEJSxVHkMTaBFFpr8cxI8HAyuynDA9PvBDRso3dAsbRmtKkQU6kZHp0ZvI
	 4+F4ivZSTldH6d3n8nmjvvm4hhO03glXesDeNopF+6GFvLHLuCZ4GdRwiC6OV56lNe
	 JsPUyGoWYqTXe4PCIF+7eIh5hmOE8ArVSoQzpYEaPSaB02zu8OxWmszOKY6HOAcZRd
	 SmwkD9NCe73/AMDjdNFXHMoOMe2ZBLcT1oWRgaZF8Q7u35v31lQCMhtvMfEvWCAGyb
	 94n6yTfdYwZ8z5gW6iI9MZCwE7upqGSGfLIYM5q2A84HoLJW+ecnyCwWrIt3SBu0I4
	 VA1PegN95zHig==
Date: Tue, 9 Jul 2024 13:27:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] spaceman/defrag: readahead for better performance
Message-ID: <20240709202703.GT612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-9-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-9-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:27PM -0700, Wengang Wang wrote:
> Reading ahead take less lock on file compared to "unshare" the file via ioctl.
> Do readahead when defrag sleeps for better defrag performace and thus more
> file IO time.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index 415fe9c2..ab8508bb 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -331,6 +331,18 @@ defrag_fs_limit_hit(int fd)
>  }
>  
>  static bool g_enable_first_ext_share = true;
> +static bool g_readahead = false;
> +
> +static void defrag_readahead(int defrag_fd, off64_t offset, size_t count)
> +{
> +	if (!g_readahead || g_idle_time <= 0)
> +		return;
> +
> +	if (readahead(defrag_fd, offset, count) < 0) {
> +		fprintf(stderr, "readahead failed: %s, errno=%d\n",
> +			strerror(errno), errno);

Why is it worth reporting if readahead fails?  Won't the unshare also
fail?  I'm also wondering why we wouldn't want readahead all the time?

--D

> +	}
> +}
>  
>  static int
>  defrag_get_first_real_ext(int fd, struct getbmapx *mapx)
> @@ -578,6 +590,8 @@ defrag_xfs_defrag(char *file_path) {
>  
>  		/* checks for EoF and fix up clone */
>  		stop = defrag_clone_eof(&clone);
> +		defrag_readahead(defrag_fd, seg_off, seg_size);
> +
>  		if (sleep_time_us > 0)
>  			usleep(sleep_time_us);
>  
> @@ -698,6 +712,7 @@ static void defrag_help(void)
>  " -i idle_time       -- time in ms to be idle between segments, 250ms by default\n"
>  " -n                 -- disable the \"share first extent\" featue, it's\n"
>  "                       enabled by default to speed up\n"
> +" -a                 -- do readahead to speed up defrag, disabled by default\n"
>  	));
>  }
>  
> @@ -709,7 +724,7 @@ defrag_f(int argc, char **argv)
>  	int	i;
>  	int	c;
>  
> -	while ((c = getopt(argc, argv, "s:f:ni")) != EOF) {
> +	while ((c = getopt(argc, argv, "s:f:nia")) != EOF) {
>  		switch(c) {
>  		case 's':
>  			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
> @@ -731,6 +746,10 @@ defrag_f(int argc, char **argv)
>  			g_idle_time = atoi(optarg) * 1000;
>  			break;
>  
> +		case 'a':
> +			g_readahead = true;
> +			break;
> +
>  		default:
>  			command_usage(&defrag_cmd);
>  			return 1;
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
