Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCEA375F8A
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 19:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774985853; cv=none; b=gMqlCCXodlxF1yfBihaCpbqrXcF8xGMAefw6V4htuQYXm0768C9a/eOAMfdtVVYPzsgcriUVtkqD1vhiHb2qVy7mY5hKUrhrnDU6sQ13ogJN4TGGZGgTyY4r15UHIRPLfG4VAowWFRk2jYeeyMNbRIiTjTECcEIlw0J3qeWRbKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774985853; c=relaxed/simple;
	bh=7ZWovc9a75OxRo62UemcBHr5OcAULiu3RHUtivh3ay4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JB1gPw5pLo0jO97eEgwqbsrKKJsG2JywrxIUuzkzfhEqmS+cX/WMkD2tFTwKk8dJTkRpDDzIlXAXlMCmsS38SKGwtR3z+IiKwbAGyuIu/M+jCsotZbrNlk9VeWb0e2HlUlrwbac1qQp4q3/Xjtg/hIq5ehv4i4fRsG+5tGEFPH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MD1hK+X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MD1hK+X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F71AC19423;
	Tue, 31 Mar 2026 19:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774985852;
	bh=7ZWovc9a75OxRo62UemcBHr5OcAULiu3RHUtivh3ay4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MD1hK+X3kOJ1G2J5vJbrFlXL+kOW0CRQ/9NatIOSaWjoWnwsMOtwLBlbxMsLSdvof
	 5oAxO3tIK9VSoBO3LS4Q6ktW04KuP4kbMfhokNx87IslynepTx9dFiaAN3BDx7r+GK
	 km3Xox70j0zWLlkw0BwrdEZSKen++yWKUo5hKfdZDHc2bLX3esiNNaxXIA7Mxq8QwD
	 b28+aN9nPhTPNo95MqN+OpvPmo0+KtimiVl2LMKx1RysXeyqOQ1y3W76JtpZdDx9xv
	 brdKptF7VkG4OARhrNML5dF5dc6qc9m3uauCok9U6Zyy/V6n2NJsTjJtumobcVTPal
	 5f2kNW4QhaBAw==
Message-ID: <b928ee42-c9f9-4afe-9d9b-80830fef56c4@kernel.org>
Date: Wed, 1 Apr 2026 04:37:30 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: refactor xfs_mount_zones
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260331152617.4047908-1-hch@lst.de>
 <20260331152617.4047908-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260331152617.4047908-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/26 00:26, Christoph Hellwig wrote:
> xfs_mount_zones has grown a bit too big and unorganized.  Split the
> zone reporting loop into a separate helper, hiding the rtg variable
> there.  Print the mount message last, and also keep the VFS writeback
> chunk size last instead of in the middle of the logic to calculate
> the free/available blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
