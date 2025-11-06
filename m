Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D59245006
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 04:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762402981; cv=none; b=rb3KiIKHKOOLKYpGPXs1WFL9kZDAp17YwDBg0m464PiuOGrHuIvMszZ+c/3L5PFN6roKfrDyIKmrd4yDGfng5M2E7sVaFz55GdBsbUVWu39MvxacOJpaFpN+s7DSvz5A3BGW5aQMSbRnOyJpcBQLgc8SR/Yh1q0PMCnm5S7wjE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762402981; c=relaxed/simple;
	bh=tukOjsDAdZrSsOVt0EB+0sLVbhItqLB3oecgf9mRbGw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=gKsjdX4xQOZiP2QwLw6pxdLInASNeDRRa8HFzNz5RVwtlYqXS5eKGkHESXV9z0i15tjudU61+tU1MZwl15Qmx11ckZ1Tlpe2v+r27MXHyzC81pLmJDW1r41zpMhw0wcAi+PREHHUKmMrjGCTraMuFn8zOhtmvKZJ5RZf/ofrf5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amjpQJ1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amjpQJ1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19907C4CEFB;
	Thu,  6 Nov 2025 04:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762402981;
	bh=tukOjsDAdZrSsOVt0EB+0sLVbhItqLB3oecgf9mRbGw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=amjpQJ1H7+hSksnAbJdCVbAvPKiEZWyoHzYmy5HEKUVtIC9OD2Vuox3iRGKqRGz97
	 Bf9WGKCxfVSA0jtCEtxAoHCOk5a7fSGXN++d6Lo+A0NWM16dC2s0YmXlQneOgE6P1O
	 XqOUBbhiK4GkUJep8QwIZ2pPNF7PKVo1XUKtY9+acCv2OoZ5hsFtlunaCoEwJ9Wi7x
	 GLmRwQb52xbpg3nfBQ5T84Suk8IiV1mBDvThupuXK5I2QnVo806wGkmOBvi/yGZgyz
	 seeo8hY5K7Q0+9UqsEphUEVGpQaERej+URYIg3Z3e61s1W5TD4MPfb8kGI8eO+UPr8
	 xLgA8WxX1M9PQ==
References: <20251104091439.1276907-1-chandanbabu@kernel.org>
 <20251104091439.1276907-2-chandanbabu@kernel.org>
 <20251104165534.GH196370@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 2/2] repair/prefetch.c: Create one workqueue with
 multiple workers
Date: Thu, 06 Nov 2025 09:31:44 +0530
In-reply-to: <20251104165534.GH196370@frogsfrogsfrogs>
Message-ID: <87v7jniyck.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Nov 04, 2025 at 08:55:34 AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 04, 2025 at 02:44:37PM +0530, Chandan Babu R wrote:
>> When xfs_repair is executed with a non-zero value for ag_stride,
>> do_inode_prefetch() create multiple workqueues with each of them having just
>> one worker thread.
>> 
>> Since commit 12838bda12e669 ("libfrog: fix overly sleep workqueues"), a
>> workqueue can process multiple work items concurrently. Hence, this commit
>> replaces the above logic with just one workqueue having multiple workers.
>> 
>> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
>
> Yeah, this also makes sense to me.  I wonder if this odd code was some
> sort of workaround for the pre-12838bd workqueue behavior?
>

The old implementation of workqueue which was present in repair/threads.c
would wakeup a worker thread only when inserting a new work item to an empty
work list. So, yes, this most likely is the reason for creating multiple
workqueues.

-- 
Chandan
