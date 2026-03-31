Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9328F3EC2C7
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774948913; cv=none; b=NsygTIPwbljMGWV65afI5BAfs9G0sUj74bG4YHqvH6ULbPfYbWyldOjDOVcNZANtH8xJpG5HXQeI0EqAmj0ihTgrjAhX7KKsx3Z/oeVGdFKeD4XhyUUw+107LEbrPp85uXmH7vCPkSc5/Ngh1fMVB2g9VKMjxVDTGxNNQHOFgQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774948913; c=relaxed/simple;
	bh=v/6xSnRWxJVROez1p8aLL3Ndq/BlDhrw1mS2bmpX3KQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=edhoryEUlCaHQuk11igCblI+1THPbw+RYOMiL6LA7I5rYWyLyuomBy6xchbcZl/XGYdQ5qR/Gn9Ydkn9Rb4bUtnsPB9l3yvhw5pAA83J8Wzb59nIUjmIj4PcnyXfrsj+1L+L+gsJcQ/nOzqUgEgJPVW8PJngew3kt8u23QOUaYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FT7IQRBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FT7IQRBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86495C19423;
	Tue, 31 Mar 2026 09:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774948913;
	bh=v/6xSnRWxJVROez1p8aLL3Ndq/BlDhrw1mS2bmpX3KQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FT7IQRBVobiKxpLT4VRbuzZUEuXJG/Y+5OYMRGbCGeFwWd2sVWfkAxLiNo9LbH0XY
	 e8BHTZnR1asuyYrjerWHlEW42wfHKfCZTXra2L4smpKzoh3EQ9+9CB05A/Jx8arkX4
	 neKSMKdeyyFE32BkNJbPyElL/MqQuqEocrZmUI/rpfC5M0zHVwIIbN4NEAYIhQIgME
	 5BZ84pjs4hNZ5U9OQ/Boklupdy34ddbk/85t21DIW/SvqVeXxuJACyDacO2RvVStXW
	 6Sv4SXmYqbjOx15ko90UZCifZdIoNP1JVRSwoUYx72lb2JFJvq1qFKlhAZVg8ggY1B
	 nP9c3KLekn8ig==
Message-ID: <ca081b37-4913-4a71-b6c8-d8e6c42a2147@kernel.org>
Date: Tue, 31 Mar 2026 18:21:50 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] xfs: refactor xfs_mount_zones
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054111.3855818-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:40, Christoph Hellwig wrote:
> xfs_mount_zones has grown a bit too big and unorganized.  Split the
> zone reporting loop into a separate helper, hiding the rtg variable
> there.  Print the mount message last, and also keep the VFS writeback
> chunk size last instead of in the middle of the logic to calculate
> the free/available blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
