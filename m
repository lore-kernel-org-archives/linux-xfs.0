Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F71F3FF1;
	Tue,  9 Sep 2025 00:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376590; cv=none; b=ovBBWa/tvokWPb8U3Oe4fopT8NGlYbHLHOhlt+eWixDHk8whzYiAbpaA52mhtk2gzYtWNeuMbBY8PeVOp8nn2F6iESfz/oyQB8HCz19A5JkPhOsCdZL5Zh9KGjB99qovae3mtEau5BcS6u5GSgupogLvdRoPmiNA11a80v2GU6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376590; c=relaxed/simple;
	bh=5qpzHAydp4S62bjrHIGSyXRzDlpY/6DVN+NDlvT5Qgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQe0y1yU+Cyq2aAf+8+WMDhZy9hrUjLicb0tvtgG2U4lselM1PDmC4BmBOvI7W5DIZE20XKHWER6er83QCVwqrpKphM1CHENe9gWN9m6OH4GfvmEJ3ZrkVGzX7ESec6yVyxmQksJeRNVD9m6XdUxPs1w92ALTD6j8rB41nRnJhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sXirqhJ4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sXirqhJ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=h+aHil78/hTdwjpWRSPDg1emSIIAI5nuEm6ueMcFToY=; b=sXirqhJ4n5HkOTVMRcikBf7NRc
	aqaNhA6/Qoonqz0DAQiGkZldSu4Ij+ekM0/7lvPwoo8ODOE9v29gYE1eGZvJAUSMGtoqcY9uoeFH1
	w6S7/u4x+0zu/36b/W5ygfpKH1HfkyAipWD4+bVhrR3K15lMaXT2oMq250TBNkLOnCTR0lhnvMLMN
	fWCTcF95La/IhcVLiDeCVUj6bprXpxhqFD7uEa0tFgPkxQZ3BYuHgN2IT/po23LTYALYs9SghQkvx
	N4bxxIYIkDii/5DIyJccPb35tB4rCwFwVDekp7aRoGS5TmpHDdjTgbR6zx8BeaeWAsG0t/0EbvbwA
	71XZkbwA==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvlvc-00000003A8Z-1GYt;
	Tue, 09 Sep 2025 00:09:44 +0000
Message-ID: <0f68d783-27e9-4150-804b-d5cb7bee57ba@infradead.org>
Date: Mon, 8 Sep 2025 17:09:43 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: extend removed sysctls table
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux XFS <linux-xfs@vger.kernel.org>
Cc: David Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, "Darrick J. Wong" <djwong@kernel.org>,
 Charles Han <hanchunchao@inspur.com>, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20250909000431.7474-1-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250909000431.7474-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/8/25 5:04 PM, Bagas Sanjaya wrote:
> Commit 21d59d00221e4e ("xfs: remove deprecated sysctl knobs") moves
> recently-removed sysctls to the removed sysctls table but fails to
> extend the table, hence triggering Sphinx warning:
> 
> Documentation/admin-guide/xfs.rst:365: ERROR: Malformed table.
> Text in column margin in table line 8.
> 
> =============================   =======
>   Name                          Removed
> =============================   =======
>   fs.xfs.xfsbufd_centisec       v4.0
>   fs.xfs.age_buffer_centisecs   v4.0
>   fs.xfs.irix_symlink_mode      v6.18
>   fs.xfs.irix_sgid_inherit      v6.18
>   fs.xfs.speculative_cow_prealloc_lifetime      v6.18
> =============================   ======= [docutils]
> 
> Extend "Name" column of the table to fit the now-longest sysctl, which
> is fs.xfs.speculative_cow_prealloc_lifetime.
> 
> Fixes: 21d59d00221e ("xfs: remove deprecated sysctl knobs")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20250908180406.32124fb7@canb.auug.org.au/
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  Documentation/admin-guide/xfs.rst | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index d6f531f2c0e694..c85cd327af284d 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -355,15 +355,15 @@ None currently.
>  Removed Sysctls
>  ===============
>  
> -=============================	=======
> -  Name				Removed
> -=============================	=======
> -  fs.xfs.xfsbufd_centisec	v4.0
> -  fs.xfs.age_buffer_centisecs	v4.0
> -  fs.xfs.irix_symlink_mode      v6.18
> -  fs.xfs.irix_sgid_inherit      v6.18
> -  fs.xfs.speculative_cow_prealloc_lifetime      v6.18
> -=============================	=======
> +==========================================   =======
> +  Name                                       Removed
> +==========================================   =======
> +  fs.xfs.xfsbufd_centisec                    v4.0
> +  fs.xfs.age_buffer_centisecs                v4.0
> +  fs.xfs.irix_symlink_mode                   v6.18
> +  fs.xfs.irix_sgid_inherit                   v6.18
> +  fs.xfs.speculative_cow_prealloc_lifetime   v6.18
> +==========================================   =======
>  
>  Error handling
>  ==============
> 
> base-commit: e90dcba0a350836a5e1a1ac0f65f9e74644d7d3b

-- 
~Randy
