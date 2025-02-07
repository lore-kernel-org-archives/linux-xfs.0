Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B4232780
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902706; cv=none; b=s2NLcGMgavAvX82HMc5+0O6zqZG+1G6VzMxlvQ+ZGbP851bNBmbv3iIyquulMdn5Z+zNkrXjQdNMGPSUnTMFwD/TiLcO1BzzMPFXQ5VMLUyg9cGB+MJWefnquy9mcSC1YI+XhJXvIYNw/NGIY07lKkvW9kyErRzk47wAw+DkC4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902706; c=relaxed/simple;
	bh=nz7Y2BhM2GWsqCXyz5VdJ8SzwFOIQvwZGZb+hsmfEo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tj8IEIm32m/MwT4PL/04KCN2W7YuGPTJLw0lg4yEViwJfEUQiqLqK0DbMBXL8hFG9UBnDGdYcbPsJh87tzU7WLGdfUkaLXX6krNcc/kZf1q9QiOWWk0ipno073M31KXznRld+AfJhgq973C+bPvYhfD51vv5xTKw7aOKIkiPvd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mn2SVqWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mn2SVqWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7373BC4CED1;
	Fri,  7 Feb 2025 04:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902704;
	bh=nz7Y2BhM2GWsqCXyz5VdJ8SzwFOIQvwZGZb+hsmfEo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mn2SVqWwi6x+ifbci/I+XtepmMYODlxZwVWLT89k6I8KL++mca89ZP4pP6Qmob8ED
	 Z2Qzvz9P53H7RlH7eiUXIQtGz5cY+zKzPl1G2NVPSCtfzV2ubKUvp/eNZQ1PBu9xx8
	 PkXCyaO9RoJh2CoZE0QqTQsjlXcyl58klBqgvvpvSeTlRL+ut5APXRlGXP5as39XWP
	 sclyGFk65glHTNPmG7vhu6hZhnO0Cgmmu8B/3bDCtHVAIyPwxEhhKGMRtsJpksUvpM
	 svQ101EF9Sxn71Z6zIYyyVe5UCC2wCi7W34lW84mOpHoARLKdkCJU6htigsT4zbh7R
	 +sWPt5CJR/m1w==
Date: Thu, 6 Feb 2025 20:31:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/43] xfs: disable rt quotas for zoned file systems
Message-ID: <20250207043143.GN21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-36-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-36-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:51AM +0100, Christoph Hellwig wrote:
> They'll need a little more work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reluctantly,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index e1ba5af6250f..417439b58785 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1711,7 +1711,8 @@ xfs_qm_mount_quotas(
>  	 * immediately.  We only support rtquota if rtgroups are enabled to
>  	 * avoid problems with older kernels.
>  	 */
> -	if (mp->m_sb.sb_rextents && !xfs_has_rtgroups(mp)) {
> +	if (mp->m_sb.sb_rextents &&
> +	    (!xfs_has_rtgroups(mp) || xfs_has_zoned(mp))) {
>  		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
>  		mp->m_qflags = 0;
>  		goto write_changes;
> -- 
> 2.45.2
> 
> 
