Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC74BA27
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584145; cv=none; b=ZhFsAJbduliV+jO0+Q4+4IlD7zKBuVthObRzJSgWbwqKzNvECkI093/Bm4XEj70sSIrSppNfgc/2y7tQVYA4wkN6SpXac77b0ISi+s36Z7z7dzw4bY3kiZE1/OVecAj8jrDqhMMGHUpY8VYifABc+UYPDRqbX4Flq6QBzFQHk/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584145; c=relaxed/simple;
	bh=YE2PJSwR3MzlpFt993hmmYDnKm5WIHyWIyBDxspAAVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jT1C09RKXjOlK/Rk0zk0r6fzhZf8xltkEqMZ2qh9gJa8xfe9yLeAB5E5ZtsbRv3FkjJo/VnJXp/n18Huy2HEid3wa6f45RuPwCf+JPfs7C6sRRI+rLEK8YjRk7Y/3M2Z8t35eXCRbo75f/XnGiybmScJ4KdbD4cZav8fsDwCM0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5zo+st/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5zo+st/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE70EC4CECE;
	Tue, 26 Nov 2024 01:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584144;
	bh=YE2PJSwR3MzlpFt993hmmYDnKm5WIHyWIyBDxspAAVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a5zo+st/job3C3ZRjcEqXySkSYPtW39okrGp+QvQjB1ETVR30Vwh/oYpltRwReAxp
	 u76s0mw4i9fAV8Qmw2U5/pZROBhbs1oPLIw1zIdNMFzvRNaQs2nznmS0rgK0g6mb48
	 qnGR7OROupvIcLcNzxovOuyN8kQu0WjANmaFPr99xjz2Nlj3B7uO94k8LjoirLvq8X
	 XmIdqRxJ11m6Rh/AQHsiE+WzawofbgniJzrW/Wpv3agInAf9yMKmlzt/t8hNiOl4H7
	 mM+wPw5X4M5XSnxe+iaAz1O+za815pol9zi8R2l58UbSbuAlE1KET00biD0I/C2QLM
	 Zqv5iIEYVMOnw==
Date: Mon, 25 Nov 2024 17:22:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: linux-xfs@vger.kernel.org, mmayer@broadcom.com,
	justin.chen@broadcom.com, catherine.hoang@oracle.com
Subject: Re: [PATCH] xfs_io: Avoid using __kernel_rwf_t for older kernels
Message-ID: <20241126012224.GJ9438@frogsfrogsfrogs>
References: <20241125222618.1276708-1-florian.fainelli@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125222618.1276708-1-florian.fainelli@broadcom.com>

On Mon, Nov 25, 2024 at 02:26:18PM -0800, Florian Fainelli wrote:
> __kernel_rwf_t was defined with upstream Linux commit
> ddef7ed2b5cbafae692d1d580bb5a07808926a9c ("annotate RWF_... flags")
> which has been included in Linux v4.14 and newer. When building xfsprogs

/methinks you should upgrade your kernel, 4.14 is quite dead now, and
you're not even running something /that/ new.

> against older kernel headers, this type is not defined, leading to the
> following build error:
> 
> pwrite.c: In function 'pwrite_f':
> ../include/xfs/linux.h:236:22: error: '__kernel_rwf_t' undeclared (first use in this function); did you mean '__kernel_off_t'?
>  #define RWF_ATOMIC ((__kernel_rwf_t)0x00000040)
>                       ^~~~~~~~~~~~~~
> pwrite.c:329:22: note: in expansion of macro 'RWF_ATOMIC'
>     pwritev2_flags |= RWF_ATOMIC;
> 
> Fixes: ee6c5941352a ("xfs_io: add RWF_ATOMIC support to pwrite")
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>

That said, if this doesn't break anything with a ~2020s distro then I
don't have any objections to this, so:

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/linux.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index e9eb7bfb26a1..68b43393aad7 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -233,7 +233,7 @@ struct fsxattr {
>  
>  /* Atomic Write */
>  #ifndef RWF_ATOMIC
> -#define RWF_ATOMIC	((__kernel_rwf_t)0x00000040)
> +#define RWF_ATOMIC	(0x00000040)
>  #endif
>  
>  /*
> -- 
> 2.34.1
> 
> 
