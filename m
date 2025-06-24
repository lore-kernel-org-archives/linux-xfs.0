Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233E61BC07A
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 14:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774073; cv=none; b=ftpuO5zKdHiu0QA8mFxl3Sp2RVTIuuc10l/xMO8kwBg2Kf6qfgV5F7MACD9bV7PS3zg3j673U+Ynljz9s6HOLA3CG4U6RO29krnVvIUjyh2vBDobEcFMgpjKngKHMRSPoSJlBX6V7X/wgFGF+Xm6biPxpNvApSYZlGPwFqlj9yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774073; c=relaxed/simple;
	bh=1q1CosiPw4hKgwDgyeWSuGs5aTloPr+X5l34aF9l0ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DhW1xY0GcoZ5V2mE1jG6gFve8DzUcnBJcPSI6pqhD85lAqhRaPq4FAn836gwgaPd4kzoPAoe/zFthf6B7ppShAdoVFP0BJsdgvXE2sij0SRBSDVPfhcrsRBU3Bkj1oLm104dZTlKcQNogXAoLaiFWQUJEN1mvgbSVVXuQL/GA/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EEC3C68AFE; Tue, 24 Jun 2025 16:07:46 +0200 (CEST)
Date: Tue, 24 Jun 2025 16:07:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: remove the call to sync_blockdev in
 xfs_configure_buftarg
Message-ID: <20250624140746.GD24420@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-3-hch@lst.de> <a9a266b8-526d-4aac-aad5-503a05911df7@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9a266b8-526d-4aac-aad5-503a05911df7@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 17, 2025 at 01:09:43PM +0100, John Garry wrote:
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 8af83bd161f9..91647a43e1b2 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -1744,8 +1744,7 @@ xfs_configure_buftarg(
>>   	 */
>>   	if (bdev_can_atomic_write(btp->bt_bdev))
>>   		xfs_configure_buftarg_atomic_writes(btp);
>> -
>> -	return sync_blockdev(btp->bt_bdev);
>> +	return 0;
>
> we only ever return 0 now, so we can get rid of the return code

The call to bdev_validate_blocksize above the diff context can still
return an error.

