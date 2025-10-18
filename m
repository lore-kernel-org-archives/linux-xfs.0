Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6259443
	for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 04:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760760564; cv=none; b=BgvNu2+MMEz35chOiseU2MkVz+uupADtTy44Fjl+nV/wSxCOsSi1twPMwadx2A7GplDbSSgm7aAXdAyf6yqZXfhvzZlUK3/RyftL55SEfUwrIW8JCEazar8LkuAwJF/MVRaI6fI0o6hlmDazfKk88YM6wunHxbXRZxuuTCLf7Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760760564; c=relaxed/simple;
	bh=sj8TDr4hTkJ9NVytHHwz/zoinIDZMRllu7xXLiGHfno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YF3RipCGr9c4mCakIBvfMO3bpRrRYsoSeoLvNWBORQBL57PQTJswww3MWKSuvwICOR/emVgIjM5AzLjmPXd7IiefTb/2gSLMtGWxVDWmb2EAywOd1C3FPhHeCMJrAbGZempWyRXF+KJ9STvj3M0uCTxea3gwOqgpcJm54reOky0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pX0pNvU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pX0pNvU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECA1C4CEF8;
	Sat, 18 Oct 2025 04:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760760563;
	bh=sj8TDr4hTkJ9NVytHHwz/zoinIDZMRllu7xXLiGHfno=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pX0pNvU1wCRPpEtUtHndRnnBjZza/TU65epdNzNJrpUuvNIP4XSKfZknZCINXJADx
	 kBshGdjwkpvRTO87x1V2nz9JLArzcNufYpD+orKL+qtCWDnTIUPsMQpy97cDFDRvH0
	 37b1ylIc7xH1VJkp5THe1+szSu5NWAQze+INdSmIE2CSwnyu+n3UNgDmw6DstB6IlC
	 o4H+xuOWEqAcDv0tFXmRrMkV3flbjVwX53/dqZn+tOD2S0BH2K4QqUWFV5kZgAorAq
	 rw9iRc82yd1P8+W6whTSNuYJHsQY4DTofvafOGMwnTjND7JxTsDf3ZXIOdrwebZrpX
	 ToWXo4yXYZ2eQ==
Message-ID: <14c499a6-3490-4c4f-a47a-ef33ff089233@kernel.org>
Date: Sat, 18 Oct 2025 13:09:21 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: document another racy GC case in
 xfs_zoned_map_extent
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20251017060710.696868-1-hch@lst.de>
 <20251017060710.696868-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251017060710.696868-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/25 15:07, Christoph Hellwig wrote:
> Besides blocks being invalidated, there is another case when the original
> mapping could have changed between querying the rmap for GC and calling
> xfs_zoned_map_extent.  Document it there as it took us quite some time
> to figure out what is going on while developing the multiple-GC
> protection fix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
