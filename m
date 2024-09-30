Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C0193418
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715077; cv=none; b=KiuUaUIpfSA4c+7pZQjdpuwbPVe3X4gum6PSLM2llJgqtDrIHsLbf65hym/25dRgTwwwhNWcgui49+yWvbb5sCBIzjjsfDi6HT5IhvnveG60LXwSsY4RE8oHcBOj+fK2kGOzNlD5sGTchlC4n14Pwc1QKnlg2p+tbMBP4KCDSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715077; c=relaxed/simple;
	bh=Hvs3pVdQEBGfL0GysHBesaXeuDAjMCIYOe6H5217c6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLoD/5MKfOu2+pPP2tCn2aSayKzShKTn+vL5Uwppxnvjl3rBfgnMSAmqoUbuM91hqV7huCJFU/vwuBtCGfUVJNLdMCfMDrS2Fy0odCtg4PJF77fWvFTw9W23Z2U/MzVPuIE4UJF8Fdp7zoxMdN22Aj9Wdpzq0ANPmyUf2WxZF+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lC8NKqqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lC8NKqqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D802AC4CEC7;
	Mon, 30 Sep 2024 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727715076;
	bh=Hvs3pVdQEBGfL0GysHBesaXeuDAjMCIYOe6H5217c6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lC8NKqqMz9R7FKckbfrZEQBiVrB5PAHOP/ILl5MmJN0JXchfYBEuM+6mQ+p1KQ8i+
	 xtMIF1w+3nUsTBLv+DcUtdPGOETl09tLpmxFAk6vkLPY4kr5wNg15WzEsk8KJmWsWI
	 jU2xL+1eVHxxeiayI8F7Gg4ia8b0ePcBz8qn7Mb2GMWiMYt/4eYu8DsJhye+nCUwGr
	 E3gedUjkRTmBDMtJyLvN3RdZidEyenvNi3fokFx179hrwr+zvA0Ves4jx5RbkI5x0d
	 Bjs5QoRvtTdNqYg+jF2gyh1/GLyF/sq+arPwv1O5RiKO178nlCm0ZVF5CWleu43Znl
	 tWDSAtR/1RVLA==
Date: Mon, 30 Sep 2024 09:51:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: error out when a superblock buffer updates
 reduces the agcount
Message-ID: <20240930165116.GT21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-5-hch@lst.de>

On Mon, Sep 30, 2024 at 06:41:45PM +0200, Christoph Hellwig wrote:
> XFS currently does not support reducing the agcount, so error out if
> a logged sb buffer tries to shrink the agcount.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

/me notes that cem is the release manager now, not chandan.  Patches
should go to him.

/me updates his scripts

--D

> ---
>  fs/xfs/xfs_log_recover.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 03701409c7dcd6..3b5cd240bb62ef 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3343,6 +3343,10 @@ xlog_recover_update_agcount(
>  	int				error;
>  
>  	xfs_sb_from_disk(&mp->m_sb, dsb);
> +	if (mp->m_sb.sb_agcount < old_agcount) {
> +		xfs_alert(mp, "Shrinking AG count in log recovery");
> +		return -EFSCORRUPTED;
> +	}
>  	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
>  			mp->m_sb.sb_dblocks, &mp->m_maxagi);
>  	if (error) {
> -- 
> 2.45.2
> 
> 
