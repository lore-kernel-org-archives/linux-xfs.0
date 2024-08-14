Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AB61EF1D;
	Wed, 14 Aug 2024 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646786; cv=none; b=khMOyApTADHc9xM+snmVGVU9wVZ+GxdOh7QKvzbykhmaKUmGqHuOP+30hM8QpBftAI7nGqP/JjjBD22Wcf+mVag+nFpuwI9fxKEwz8QoSIcNSg4v5SyhNB7pM5pM1K0SIqfg+ES/FXC4zmWqhdG2tI6t6DmuwtoqZLZSw34DZ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646786; c=relaxed/simple;
	bh=aekBnxAOUFjKnS5qZoBh7M6hqiZXVA2N3rrRXQzWOKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HboVeJKLyMxCXRyUFFxc1qE0QH2E7aT08HafDGjwW3p0MBbJrw/Kqe3mcC5V0hmE04NxjOOPLZQPv6PXZLWxl+uoWu6U8at1aCs6uPTzcEPsyvU7D/bNAapDJxLHMwhoogRdWGSolK3wyJTpLeuyAXh8C2jAfaqvys3wRLDTdO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDX0TjBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDX0TjBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818CDC116B1;
	Wed, 14 Aug 2024 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723646786;
	bh=aekBnxAOUFjKnS5qZoBh7M6hqiZXVA2N3rrRXQzWOKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LDX0TjBBxYeATLANwPSRZCtru+eWvLik4svydIREbMswGSP0M3LU2aU7NZA+VhBWA
	 UmG5GZ2rfTCXnA3bztn6wAryKIYvL1IJpfX0TP3PDh5DZhKnVoWOjV68oAJ298+Thi
	 3QexoQhYcHAsyUWGwq2S/G7+Q9TTRg1C97WkrG3yjn1z168o2i+3lkl6MIfasZ/hL2
	 42AY1rkFi0jdEazCPMOqQo23piFmyZQsT7kMdgXTlgBFu4Kdet997alinMP+xNjoQt
	 ZhJmdjMw3RoZ9ebBypGow8G8nsDnwXaaNPgwfXVADjihy3GqUm5cA72Zk0owpqY81/
	 tUIby0ySibKBA==
Date: Wed, 14 Aug 2024 08:46:23 -0600
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
	axboe@kernel.dk, martin.petersen@oracle.com
Subject: Re: [bug report] raid0 array mkfs.xfs hang
Message-ID: <ZrzDP5c7bRyh7UnE@kbusch-mbp>
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
 <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com>
 <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>

On Wed, Aug 14, 2024 at 03:00:06PM +0100, John Garry wrote:
> 
> The value max write zeroes value is changing in raid0_map_submit_bio() ->
> mddev_check_write_zeroes()

Your change looks fine, though it sounds odd that md raid is changing
queue_limit values outside the limits_lock. The stacking limits should
have set the md device to 0 if one of the member drives doesn't support
write_zeroes, right?
