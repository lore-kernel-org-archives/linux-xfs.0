Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4493BB110;
	Thu, 10 Sep 2026 05:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019525; cv=none; b=rcfyS0j4L9SUPRZA2hC6o1Oe4q6LUOmZJ9owCuAIWtoAJZaEdqvpKnzQFSDBeWpM2kz1mp3KvlSdV4B4I/y2i3gFFYd6cXKw4i9/fWyr2MJZhd7iO16/mB3uCcXK72hakk1OlnuRgLAWuVQKX255QZrDuQw4k9Ueuvx0ddtC7Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019525; c=relaxed/simple;
	bh=UhW180dA12tPRUBRPjV6IIm+7+EC76P+6MoJwyAryug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdiKo8dwbsLnnpbvav43cme4b7Y8puepBowoGrIKo6DfgF6i9Hgd3de2fadoe1NpTcd6KyNcdppFE276yDtjiCVeizg9/i56F0v2Hbo0DiUzJlyvhIG76Qt0V47sqdf46X9pzw+aRU8kQlTGBKj5tc3cB/0ZkUYWOuy41Pl69pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nth0jdys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nth0jdys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC991F000FF;
	Thu, 10 Sep 2026 05:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789019523;
	bh=+HP1WKODdJHWLa5/U+FaZfR2U3PLFaGuLN6HzsglwPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nth0jdyscrbkeX8sKKrZkDVmC/eb5VvJs6m+uOD655SxiFm5+2Qpjth0v9kiLpCpf
	 tVxAysa4b8OJHSLmjXFQkrfFN4Iv5YdFXkMtpDXR9r0ZLw0wLlSdbIUR/MsX6zwXFo
	 07C/T00Hdz8mgIU4EmHW+tO/jtXM4Q1qWJUUQRHcImN10LTu/6WKZu7fhsn67sNL/B
	 IYPTNhE38aL49ihK21UwNwyDLg7ynixkJ+kZysFzCD4satVsWRIFe+LG7LO8iSgde2
	 KGOiilY4mFUjiDbKNM0BiunYhcUQYFXIs88/3sAw3sGXizCDUJOYVX/qXvvYZV3i+i
	 6faJHYeyDJIWw==
Date: Thu, 10 Sep 2026 07:51:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: fix replaying dirent removals into the
 temporary directory
Message-ID: <aqJFemuEB7uUyXRL@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936728.4057962.9945119784451295166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936728.4057962.9945119784451295166.stgit@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 11:05:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xrep_dir_replay_removename is the function that replays a directory
> entry removal from sc->ip into the temporary directory so that when we
> swap the contents of sc->tempip and sc->ip, the directory is correct.
> LOLLM noticed that we were passing the wrong inode pointer into
> xrep_dir_init_args.  It doesn't make sense to set rd->args.dp to
> rd->args.dp so let's fix this.
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/dir_repair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 0a3d02d8f04153..82ec5cfad63c59 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -727,7 +727,7 @@ xrep_dir_replay_removename(
>  	const struct xfs_name	*name,
>  	xfs_extlen_t		total)
>  {
> -	struct xfs_inode	*dp = rd->args.dp;
> +	struct xfs_inode	*dp = rd->sc->tempip;
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  
> 
> 
