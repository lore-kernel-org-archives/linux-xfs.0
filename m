Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7429946A
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062218; cv=none; b=fvfnHNrPw5bFfO9lktVKFsl1dYMY3BX16w2f4D+f445clROmsE/VKhxEsjmY/nVIlz+xHqdbC6YZE5iHu/xcmVpOkctN328LO2LlUnd7mczJiDtLOD1DasqEH9OYJKjNhiadkYkJpZKkg/8KmfwnAbSKMono26MxTwmgmd52I+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062218; c=relaxed/simple;
	bh=tOf9gQePZ0UVmsLN3t39DXKtuU7OH6/ONqo1jSysdus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwqyTjQUOFqgYhdt5O42AKa/UoovC6Lv32aDveV5Mwu11jo3uixNKTZpbJcaLIPnsywheV3YZFodEdsFjrXrXzGBN05UxDEee33Z67lloyUocD+vD9hxeZpjHUwN0FzUS5Pv3aV5wRsvEm2q7LeBekTsE6NLYiAFiNngOzhYm3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tb37ygaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tb37ygaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65572C4CEF1;
	Tue, 21 Oct 2025 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761062218;
	bh=tOf9gQePZ0UVmsLN3t39DXKtuU7OH6/ONqo1jSysdus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tb37ygaUqU100FN3hTNyjR0kGSgKgBUTanQNwKUH04p2Kc1oXKd1+xGDDYJU/7wQT
	 sUHtyjan+j4C5cZDt8Ev47thaWd2R/PjvfblgooUH7kTXzWJDwlC9HsiSFKSnbN1PJ
	 7f/3xYc70hUYS5XycwZlR26VZNYjVfpbBvukxXc01yeZK+ig6MemfK7WOsWRHfF0pG
	 33+47c4nWHQb64A1IjZxSOTH/rKJ0v9O2WwIFd2On6VGgEvcguDj1/PsJW1iRp1bpW
	 p3yRcoUapB+YcRsvXJA2PGg8kWxXOLm3MLM0gyxME94SOYELRiZoouh0c2zyobyMtq
	 TxrbOoBl3ZZow==
Date: Tue, 21 Oct 2025 08:56:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Remove WARN_ONCE if xfs_uuid_table grows over
 2x PAGE_SIZE.
Message-ID: <20251021155657.GA4015566@frogsfrogsfrogs>
References: <20251021141744.1375627-1-lukas@herbolt.com>
 <20251021141744.1375627-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021141744.1375627-4-lukas@herbolt.com>

On Tue, Oct 21, 2025 at 04:17:45PM +0200, Lukas Herbolt wrote:
> The krealloc prints out warning if allocation is bigger than 2x PAGE_SIZE,
> lets use kvrealloc for the memory allocation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_mount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index dc32c5e34d817..e728e61c9325a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -89,7 +89,7 @@ xfs_uuid_mount(
>  	}
>  
>  	if (hole < 0) {
> -		xfs_uuid_table = krealloc(xfs_uuid_table,
> +		xfs_uuid_table = kvrealloc(xfs_uuid_table,

Doesn't the table need to be kvfree'd if you make this change?

--D

>  			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
>  			GFP_KERNEL | __GFP_NOFAIL);
>  		hole = xfs_uuid_table_size++;
> -- 
> 2.51.0
> 
