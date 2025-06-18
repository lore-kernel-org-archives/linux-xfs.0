Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198AE18FC86
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 05:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750223307; cv=none; b=JNlR9YXZiiaKbeN81EcuMwni5C9RNFbhQ33YYWjmprL6HU7ZSj/akeliGO7HBhmMPnxXMq9R3KAsvNm25Jl4D+1xKrBm8jyWNLilcPZh49PopT/fECcRGzL9djcKF+HRE9kOC708Mbp36MweukJfBvuaEjQOAXyTRwY5HD1jYb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750223307; c=relaxed/simple;
	bh=5EOh6z+VBQim6uZxRzytgdXEPnoktByZaBcj7jxmlr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3J8Cyga1wszXaJAlAYES6EFeLrtV4YpBaoORAcrpPglJIY96/XJW9XzOnPM1tbHpYVMK5bVybK+dUkWWF6tTFDBVT/PzEDNuIe0c/xz2dUQHRv4wZJYdTcAaUmmYTDK79Ugf5VZk5Vl8mMJF3ACUUJf0BDpGHlrwWDBpNzYCz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B86368D0E; Wed, 18 Jun 2025 07:08:21 +0200 (CEST)
Date: Wed, 18 Jun 2025 07:08:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: refactor xfs_calc_atomic_write_unit_max
Message-ID: <20250618050821.GC28260@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-5-hch@lst.de> <e8cf8a81-56c5-4279-8e19-d758543a4517@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8cf8a81-56c5-4279-8e19-d758543a4517@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 17, 2025 at 12:44:57PM +0100, John Garry wrote:
>> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
>> +	struct xfs_groups	*g = &mp->m_groups[type];
>> +	struct xfs_buftarg	*btp = type == XG_TYPE_RTG ?
>> +			mp->m_rtdev_targp : mp->m_ddev_targp;
>
> Could this be made a bit more readable?

Suggestions welcome.

>
>>   -	if (rgs->blocks == 0)
>> +	if (g->blocks == 0)
>>   		return 0;
>> -	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_bdev_awu_min > 0)
>> -		return max_pow_of_two_factor(rgs->blocks);
>> -	return rounddown_pow_of_two(rgs->blocks);
>> +	if (btp && btp->bt_bdev_awu_min > 0)
>
> Is it actually logically possible that g->blocks != 0 and btp == NULL? 
> That's really a comment on the current rt handling.

No.  For the data device btp is never NULL, and for the RT device we
reject the mount early on in this case, see xfs_rtmount_readsb and
xfs_rtmount_init.

