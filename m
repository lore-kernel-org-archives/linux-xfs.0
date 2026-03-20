Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36BD23EA85
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 23:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774049331; cv=none; b=unEpiT9XsJKYawJaDiREkIWovrOq7lyfvd6lntcDOIHHyx0hEPQzcT6v9CVxXCzPV+onZP/SrS7Q/RITyTBM+EZh7vPXMdtXvqZUFGafZqihM4L1QKOf5kzoun0likYT49HYHpOX+HPpHKhQHX8eLBN2DYS185n0hHU2fn8Ekow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774049331; c=relaxed/simple;
	bh=U15qYnFKTZO7paZTSts0lP4MBjZ54ZT3V6O75Z+5TPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HYhU+wlqLXIEVbqKrvOYd0IGe3b2+FOuzTE3jPS7Hnw/55pVFs7KB0cXMuQlP3eSBbp4AsEhGVTvX+rn2rPelHkFDI9tPrsRACUng+OrEG89ue2WBPTGrNEUpg0HEt6+GzH+MQPpCNghkQU9niIJh6Lq8c2Jgo7+GNN3j9HDncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+dfANMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+dfANMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B21C4CEF7;
	Fri, 20 Mar 2026 23:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774049330;
	bh=U15qYnFKTZO7paZTSts0lP4MBjZ54ZT3V6O75Z+5TPk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h+dfANMnuuST0nQYnzvnRiQtMm2RlH3EC+niTRhpigVPx3UUvvH5QEVoVoPWPnKL6
	 EZIJoAGSsz4AzxOKYhOQ23F3Akj7S3mYfkU+7dDMfSSE/S9hNuJb3UZZZG1jzQs2RN
	 lNKJ3QcRsvBw79qJ2jTxnHw+x4Xfffk7r3e2gHbtSOLX3cLq3JuvGIFev5I3jLSKMI
	 ulOW1SAhjHpedg005Od7bqtisl7kbN0jDdfQYiwSOxf8pZXV4qlnBWeceOzPIViOcL
	 z4MbELL/s6TsPmCglMJp1WGiC6b7uz0FMhobv46gtsDtqu3nvaJPJP/9ydcGnnI7/+
	 3fwW6SYVajnog==
Message-ID: <31eb8a2a-498d-4897-bc13-9266f71589b9@kernel.org>
Date: Sat, 21 Mar 2026 08:28:48 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: start gc on zonegc_low_space attribute updates
To: Hans Holmberg <hans.holmberg@wdc.com>, Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
References: <20260320130256.35225-1-hans.holmberg@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260320130256.35225-1-hans.holmberg@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/26 22:02, Hans Holmberg wrote:
> Start gc if the agressiveness of zone garbage collection is changed
> by the user (if the file system is not read only).
> 
> Without this change, the new setting will not be taken into account
> until the gc thread is woken up by e.g. a write.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

And I agree with Darrick: a fixes tag and cc stable would be nice.

-- 
Damien Le Moal
Western Digital Research
