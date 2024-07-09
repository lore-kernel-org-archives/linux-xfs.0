Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9641F13B7BE
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 21:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720559129; cv=none; b=CkYc9kjK3H9P+FveP6ObdSLcOYLZciN3qpPgKwaeDh7XYhy9Erp/2CmOFEksfwLYrOlpe9DnegT+4WY8kpX8VzS/F1iGMFnjAa99og/HWm95n28fnjyT1mjWX6CEFuqntdZmWhKwK4ik4kdw3Acoz9oJ/3CQsqks6o3U35fwlTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720559129; c=relaxed/simple;
	bh=15iETTHMdHCx+J7DtBQgopK8UECjx7h5RirA0uXMdiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QsgYnT8fQ5XllydejlZGJg+sfWoeu52lHiXFdj83ktXW+uhLDfiPuLqqiQ90VTBUtaSFeeIifK6F5wH65zmrCsbe7ReI+frtElRSvgvL6UC/kb1R1Ngh/qMwaOw85HpTBqS/Dc8jGJ8EljwagqEieujjCh6cKZkJkYQVhMBNPok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8Cnnz/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8Cnnz/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3002AC3277B;
	Tue,  9 Jul 2024 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720559129;
	bh=15iETTHMdHCx+J7DtBQgopK8UECjx7h5RirA0uXMdiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T8Cnnz/+S/e4ziMySrDxiCo9TPyWnw1ZXO112A19dA4RovdjHuLB1FyscF6qnqAId
	 0pNU9UbNG2i/MBjGAaMGeieNoaKvuX4t/BL308QHJInqtjQmmGlW2+D/hQLV0S3Ja/
	 hJx9KCQA/YlK0R8WHLa/evqMr6y4Lr9WwGyvuLlH4DWga2rA4a09Rjex5Mt1f88F+E
	 V9w6dF1q8VU5q7iYvTnmgUsHuLNpKBjaPp6X8reBMZ0XgpxfksJnD0PdJSLpK6m1nV
	 xy/XDMDN8LH9qjSFqJfdjjIzewV2sHKsPLU0U6QpYco+KM6ob1TfrbEfC81obgbv/S
	 pRrEZ+JTg0vqA==
Date: Tue, 9 Jul 2024 14:05:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] spaceman/defrag: exclude shared segments on low free
 space
Message-ID: <20240709210528.GW612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-6-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-6-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:24PM -0700, Wengang Wang wrote:
> On some XFS, free blocks are over-committed to reflink copies.
> And those free blocks are not enough if CoW happens to all the shared blocks.

Hmmm.  I think what you're trying to do here is avoid running a
filesystem out of space because it defragmented files A, B, ... Z, each
of which previously shared the same chunk of storage but now they don't
because this defragger unshared them to reduce the extent count in those
files.  Right?

In that case, I wonder if it's a good idea to touch shared extents at
all?  Someone set those files to share space, that's probably a better
performance optimization than reducing extent count.

That said, you /could/ also use GETFSMAP to find all the other owners of
a shared extent.  Then you can reflink the same extent to a scratch
file, copy the contents to a new region in the scratch file, and use
FIEDEDUPERANGE on each of A..Z to remap the new region into those files.
Assuming the new region has fewer mappings than the old one it was
copied from, you'll defragment A..Z while preserving the sharing factor.

I say that because I've written such a thing before; look for
csp_evac_dedupe_fsmap in
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=defrag-freespace&id=785d2f024e31a0d0f52b04073a600f9139ef0b21

> This defrag tool would exclude shared segments when free space is under shrethold.

"threshold"

--D

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index 61e47a43..f8e6713c 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -304,6 +304,29 @@ void defrag_sigint_handler(int dummy)
>  	printf("Please wait until current segment is defragmented\n");
>  };
>  
> +/*
> + * limitation of filesystem free space in bytes.
> + * when filesystem has less free space than this number, segments which contain
> + * shared extents are skipped. 1GiB by default
> + */
> +static long	g_limit_free_bytes = 1024 * 1024 * 1024;
> +
> +/*
> + * check if the free space in the FS is less than the _limit_
> + * return true if so, false otherwise
> + */
> +static bool
> +defrag_fs_limit_hit(int fd)
> +{
> +	struct statfs statfs_s;
> +
> +	if (g_limit_free_bytes <= 0)
> +		return false;
> +
> +	fstatfs(fd, &statfs_s);
> +	return statfs_s.f_bsize * statfs_s.f_bavail < g_limit_free_bytes;
> +}
> +
>  /*
>   * defragment a file
>   * return 0 if successfully done, 1 otherwise
> @@ -377,6 +400,15 @@ defrag_xfs_defrag(char *file_path) {
>  		if (segment.ds_nr < 2)
>  			continue;
>  
> +		/*
> +		 * When the segment is (partially) shared, defrag would
> +		 * consume free blocks. We check the limit of FS free blocks
> +		 * and skip defragmenting this segment in case the limit is
> +		 * reached.
> +		 */
> +		if (segment.ds_shared && defrag_fs_limit_hit(defrag_fd))
> +			continue;
> +
>  		/* to bytes */
>  		seg_off = segment.ds_offset * 512;
>  		seg_size = segment.ds_length * 512;
> @@ -478,7 +510,11 @@ static void defrag_help(void)
>  "can be served durning the defragmentations.\n"
>  "\n"
>  " -s segment_size    -- specify the segment size in MiB, minmum value is 4 \n"
> -"                       default is 16\n"));
> +"                       default is 16\n"
> +" -f free_space      -- specify shrethod of the XFS free space in MiB, when\n"
> +"                       XFS free space is lower than that, shared segments \n"
> +"                       are excluded from defragmentation, 1024 by default\n"
> +	));
>  }
>  
>  static cmdinfo_t defrag_cmd;
> @@ -489,7 +525,7 @@ defrag_f(int argc, char **argv)
>  	int	i;
>  	int	c;
>  
> -	while ((c = getopt(argc, argv, "s:")) != EOF) {
> +	while ((c = getopt(argc, argv, "s:f:")) != EOF) {
>  		switch(c) {
>  		case 's':
>  			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
> @@ -499,6 +535,10 @@ defrag_f(int argc, char **argv)
>  					g_segment_size_lmt);
>  			}
>  			break;
> +		case 'f':
> +			g_limit_free_bytes = atol(optarg) * 1024 * 1024;
> +			break;
> +
>  		default:
>  			command_usage(&defrag_cmd);
>  			return 1;
> @@ -516,7 +556,7 @@ void defrag_init(void)
>  	defrag_cmd.cfunc	= defrag_f;
>  	defrag_cmd.argmin	= 0;
>  	defrag_cmd.argmax	= 4;
> -	defrag_cmd.args		= "[-s segment_size]";
> +	defrag_cmd.args		= "[-s segment_size] [-f free_space]";
>  	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
>  	defrag_cmd.oneline	= _("Defragment XFS files");
>  	defrag_cmd.help		= defrag_help;
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
