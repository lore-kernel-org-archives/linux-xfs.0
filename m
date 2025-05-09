Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0062C7E1
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 11:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746791001; cv=none; b=j3G+vy/DpYvA0A3Xs7YY/l6nCrzLMrBKa5KcsWdPFkK6VI6lN7m2h8AMV+yqGLXSDMDTtJXtlSJEYlKkWWTwnMbULP/jKbvU8ROCpJhxfwQZ7pGW5NudPaux3aN2w9omYhD60qLoankjBusfOJmSaTd8Ni0ZkvDHin3SjUB9vF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746791001; c=relaxed/simple;
	bh=zzORZuEM5zFYqjd6nnmqGwFuyPC0dgY3nXb89mWPtAM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=POFv2GVJE5VLlnYSCc9DXvNHNiXmK5VcmRHIzQSor9oRIkOC5fcN10u386Pt+hoG9qrK5tl7us+/ajRA9W2Gf6pWGT3BOmOHiBhlWBfVNy2jS9XeA+c2VOvqMnMxc7EVS8PrmEaD023rfC5aGKYNjMp6Q7M8tnYW9aCtpMo59jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2iKrUd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2iKrUd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC36C4CEE4;
	Fri,  9 May 2025 11:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746791000;
	bh=zzORZuEM5zFYqjd6nnmqGwFuyPC0dgY3nXb89mWPtAM=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=J2iKrUd4bTZe1p+557+g8BQ8nHCE3/8cnT3WmPOpibOmW8ANv++8v3kp/D05kf8Fq
	 ZcsfMJn7xjsRsT7SIuEFZfZ006bOiTCXOCIO9k5hh87xBGjNJkrF10zrDtkqAYQi3R
	 ku0syN7lSh1yIzdNhOTb8/O9w8x9RcPdIat0elGIeH7ew4wGYUYEqO/dSM3yEcoUAM
	 C+/dNXDD0kiezv+d7BwHDN+lPJ7kFNtsJHOe6vssB9uYwqUM4VPsAdrxg9f+TxC76b
	 czjrB8IVa2CrS3K31NEaFBvV0pzu+l3ZL4l9DNFyRiEGO5jtZPoVhjAsksRt0VRQdH
	 ZyKG+/sDZffFA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
In-Reply-To: <20250430232724.475092-1-david@fromorbit.com>
References: <20250430232724.475092-1-david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't assume perags are initialised when trimming
 AGs
Message-Id: <174679099987.556944.7308027774684699629.b4-ty@kernel.org>
Date: Fri, 09 May 2025 13:43:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 01 May 2025 09:27:24 +1000, Dave Chinner wrote:
> When running fstrim immediately after mounting a V4 filesystem,
> the fstrim fails to trim all the free space in the filesystem. It
> only trims the first extent in the by-size free space tree in each
> AG and then returns. If a second fstrim is then run, it runs
> correctly and the entire free space in the filesystem is iterated
> and discarded correctly.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: don't assume perags are initialised when trimming AGs
      commit: 23be716b1c4f3f3a6c00ee38d51a57ef7db9ef7d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

