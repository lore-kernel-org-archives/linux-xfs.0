Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC67B2137B
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 21:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAkMOlvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182CEC433C8;
	Mon, 11 Dec 2023 21:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702330935;
	bh=A4MPNCSUfYsNthRFqpm3PluzJBXPSxeny6aH2+L6v/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZAkMOlvZDGb2i9tlqceo7JsAUeMA6m3IMA71N9b58vCNwPkqrBtWv2qCBPRZj2kIh
	 T6BOOD9VTpToqK8YG7bnK3GZtusJYJl6Wuwm3/vy/W/Vq5Gd0Geaf291YnHPWFR5Uo
	 FDbXy9ADolBMYMaMiw3Kkg2oUZRyAo3uUd2ZddgYWzb+h7i3Q4Sh47xaRNgSEEsWsG
	 A2vZY5Z01XIIZS8QJRqfqcWrbmfNT86FgTjtxI0kLzt4WEMUZgkZKyCdIyQ86oNna8
	 MMLa5pE67UhS1RUKGduZyeebsTcfJ+XeInaqko4pytxJe9H2lIUY0eE9LcrOSakgxj
	 7Ki5S5jk4gPBQ==
Date: Mon, 11 Dec 2023 13:42:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 2/3] xfs: don't assert perag when free perag
Message-ID: <20231211214214.GV361584@frogsfrogsfrogs>
References: <20231209122107.2422441-1-leo.lilong@huawei.com>
 <20231209122107.2422441-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231209122107.2422441-2-leo.lilong@huawei.com>

On Sat, Dec 09, 2023 at 08:21:06PM +0800, Long Li wrote:
> When releasing the perag in xfs_free_perag(), the assertion that the
> perag in readix tree is correct in most cases. However, there is one
> corner case where the assertion is not true. During log recovery, the
> AGs become visible(that is included in mp->m_sb.sb_agcount) first, and
> then the perag is initialized. If the initialization of the perag fails,
> the assertion will be triggered. Worse yet, null pointer dereferencing
> can occur.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index cc10a3ca052f..11ed048c350c 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -258,7 +258,8 @@ xfs_free_perag(
>  		spin_lock(&mp->m_perag_lock);
>  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
>  		spin_unlock(&mp->m_perag_lock);
> -		ASSERT(pag);
> +		if (!pag)
> +			break;

Why wouldn't you continue to the next agnumber?

--D

>  		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
>  		xfs_defer_drain_free(&pag->pag_intents_drain);
>  
> -- 
> 2.31.1
> 
> 
