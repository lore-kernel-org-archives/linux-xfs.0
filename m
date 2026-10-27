Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793122369;
	b=YaXRykatL0Q0rqWK7oma4pyuUU2BKlI0Arvg+igbZzu7pyXHdNB0LUv4ALUG1kkzq64Q
	 mfTbHsCMFVnSVtXIV+n3fflz/dv+VUtHzIUMMN1mt6fvj00GAiR/xGkYS6qn0fQXNfONT
	 kMkJuvXBWsspq1K89Pz77jhOOiDYjoaWXQOPkuynm/6uXLkoN78SGGCpkLu+Zc5gl/hHs
	 kLQjylBeKlQbArgul0AfTbMHyIXcG68E3AH9C8YyYzX9fjvKuPiJWyrAK3HTeoNKpDwaV
	 ZEOXtzFZPPg5Lf8PGRy9LOEHS39a+7CoyVefFOSDliG2UqTX1J5jLe677B9wu7irqwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122369;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=6Xd2ly1e8z0I0jLbX7WVjieXV2n1cRhJ5Aee9Uv3YD0=;
	b=JOK3G60AEJzG2z4UoWi17p3g8msE6kFsTF+9x0yMaxaCHHOOhwarM7JTq5iesB/ECh1b
	 JMZx3pUDCi5FunGfk4kvqCUmF1M75SWPixsFxsKxvpuB0WWG8VOjKrjT9C2oTKrdQgZ17
	 Y4r8WNO4dc4RPATVbOkde1aF6WThp4fIN6Ldimq7Sn37m+gPJQEKeBZTRvFI28UMdPMJH
	 6LPaLfHhrt4NfUNCccv7s0czs1fQ7YU3dcWGWyRzfmbKHagke8qy4ZaxEz0ONuoZc6tR1
	 wDEi3SBy3G01DXyjGxwH2qJmYgsigO2aekA/1YCmKHfjm89fqh7l4kQs9pFa3Hqnqag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXn51sg+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E43606A31F;
	Tue, 27 Oct 2026 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXn51sg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5CE1F01829;
	Tue, 27 Oct 2026 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793122368;
	bh=6Xd2ly1e8z0I0jLbX7WVjieXV2n1cRhJ5Aee9Uv3YD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MXn51sg+AdbRulkJpvXCM/YdzW38DZeqJ+b3DEnSEWYiRvlL7h+4kchhcZBe3A/6g
	 2kDK5ZtkQJigr4YLMOsQmjFN/QTdXEoe+wC0wo0e9jJiPg98deDonwrHPbO0WD6EnG
	 zStTZJmh4/PueAXTE+kzxb/ycurer22YUmQLjwC+fMYQmoLyqWvgSYF+0Wt2XT0SaZ
	 Sj0F1d9Z1a4YGx+nwddgGQAm1zHQRw9vn7AnMboUWpbj1qWGMN+N1Caj/VclHTK3Ga
	 GyHQduAJ+zgbVTdQiZdORIkckQOgtbizLlXXoVntyRIePg/UePOj+N0DeiM+01Az7F
	 pi7RsoT68GY3w==
Date: Tue, 27 Oct 2026 18:32:44 +0100
From: Carlos Maiolino <cem@kernel.org>
To: =?utf-8?B?6ZOu?= <fengaojigui88@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] xfs: undersized log triggers assertion in xfs_log_mount()
Message-ID: <auDbrRoBQaxWnsE9@cronus.toxiclabs.cc>
References: <CAO-4RZ25PZ5BM+83Vk8t5NUY3ksLGz5nzONrncipu2_MZhFSsg@mail.gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO-4RZ25PZ5BM+83Vk8t5NUY3ksLGz5nzONrncipu2_MZhFSsg@mail.gmail.com>

On Wed, Oct 28, 2026 at 01:00:54AM +0800, 铮 wrote:
> Hi Carlos,
> 
> Executing the stored syzkaller testcases on Linux 7.3.0 ultimately triggers
> an assertion in xfs_log_mount():
> 
>   XFS (loop0): AAIEEE! Log failed size checks. Abort!
>   XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 597
>   kernel BUG at fs/xfs/xfs_message.c:102!
>   ...
>   xfs_log_mount+0x4e3/0x590
>   xfs_mountfs+0x10b9/0x2270
>   xfs_fs_fill_super+0x15cc/0x20b0
>   ...
>   Kernel panic - not syncing: Fatal exception
> 
> The log size check reports 516 blocks, below the required minimum of
> 636 blocks.
> 
> Is this an expected assertion with my XFS debug configuration, or should
> this malformed image be rejected without triggering a kernel BUG?

You have bug_on_assert set on your system, so yes, this is intended. If
you don't want to panic() the machine there, you need to disable it on
sysfs, but...

> Questions
> ---------
> - Is triggering a fatal assertion for an undersized V5 log intentional
>   with CONFIG_XFS_DEBUG=y and CONFIG_XFS_ASSERT_FATAL=y, or should this
>   case return -EINVAL without triggering a BUG?

The config you have enable explicitly says asserts are fatal. I'm not
sure if I misunderstood you or you misunderstood the configuration
option.


> - If a diagnostic dump would help, what state should be printed before the
>   assertion so the malformed image/log geometry can be identified?

You are running a kernel configured with debug configuration that are
meant to crash the system when some issue is found. Those are
configuration settings used for development and debug purposes, not to
use on a production or semi-production system.

Cheers,
Carlos
