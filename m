Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C443E2E424C;
	Mon, 16 Jun 2025 12:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077108; cv=none; b=nseIjDNwyYetoL57m8fUU0Tkzrgpuu0CVasa3XD3wv6z+vSIP8KTZsVNQlgLlH4/X4wtoOzExkoTX65K2R71UGkagU19jc/zc+QxZOXC6PsXPRlvh64C8Nlb7vKScj4FXEw5UpDj46Ce0KYxqqCQS33q8Y3lVa2kOBh8TPYH5Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077108; c=relaxed/simple;
	bh=p+04Eu+Nr9aRnIFlQGRpbR1ZgismRDWRmiAreqV/CYQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EM0x9P+J2wTckeImAQqV+W+i68qI9jRV6TJ22Udup2vvWhE8nc2Po/cdya8TjMBs1BK+iuoZHxOGpiUE757qv0cgYRdW42bf1aTp+oEks7mkqqSULo7nlpGWFjWkySYCle/7Cfgkdvikd8Z2MSgVFe6tMDoavn78MshmzgX7vLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYSP4iXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYSP4iXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6E3C4CEED;
	Mon, 16 Jun 2025 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750077108;
	bh=p+04Eu+Nr9aRnIFlQGRpbR1ZgismRDWRmiAreqV/CYQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=fYSP4iXZrhxV3yp2pPav18pOZRwCKeVSMGD20WPndnTqJfReHjGjUayhJYY8xjYgA
	 8xYGacGgapuqRP/vV9zN4v2C5OsyBc7gqprVQObhy61GZL1wO4zVs7e3IGXQiuw6ss
	 ITJE/ImwBvBFxvDCHnYXJCPscknn95NJ602ivqUS8lhsUqD40WnZvb1KY2nJkdhK7k
	 x24JNsgD472IyxvyTDVzYG8Mx+hWUDK9QyLgCsNGbD3GgnSEB0cs85A55qKAx9rMVC
	 e9vA7AYsOOENm8qOdeeaTU85lZacIWObDY+TbEfmH7edKdCPDfx8Zp84ngoyrJQV3/
	 7vqOgjMbhuTYw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Markus Elfring <Markus.Elfring@web.de>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
In-Reply-To: <b182b740-e68d-4466-a10d-bcb8afb2453a@web.de>
References: <b182b740-e68d-4466-a10d-bcb8afb2453a@web.de>
Subject: Re: [PATCH] xfs: Improve error handling in xfs_mru_cache_create()
Message-Id: <175007710641.485207.1412440118102038042.b4-ty@kernel.org>
Date: Mon, 16 Jun 2025 14:31:46 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 10 Jun 2025 15:00:27 +0200, Markus Elfring wrote:
> Simplify error handling in this function implementation.
> 
> * Delete unnecessary pointer checks and variable assignments.
> 
> * Omit a redundant function call.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Improve error handling in xfs_mru_cache_create()
      commit: 19fa6e493a933c095f164230d3393d504216e052

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

