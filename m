Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE73624A5;
	Thu, 10 Sep 2026 09:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031468; cv=none; b=PWMgxuSZLcllD43vGdDU5zexAnMXRIiGN87YMyljhe6mL63d/GPICJSc7b3eMBIq0O6aqoxvM7DCi06CBNXcOVvyLlW+CZHZvgicrES1u+RRsjb/WTE3c9g55nMMZd14CNqCKXA5pBsGm0ujJ0tKxb/H3MZS9vayoqUmin+KaYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031468; c=relaxed/simple;
	bh=5DarmeF45ogQSoCBvBxDiAvhJIzo/8hqLc9B6h9Niog=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sW4LpJQBF4PH4vFB65snuUaxk8cePQY4IdcWr0kON8DH8Z6J6JieG4b60vgbI5Ps98uO8lnbNBLD2GRo+gwE4dZCvv7ew+jgDrCijQvNI6EpiuQcc9CHtxS3OLmjvt9yUiZrIDTAe6t6VxhNYlMbhMfoD6dVDY/nwLAV7u4UuHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJFp8GVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJFp8GVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5DC1F00893;
	Thu, 10 Sep 2026 09:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031464;
	bh=ScptD72IoeNXtFs2VrQ5uJU3pmKdEiwcfLthBLYS27s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KJFp8GVM7mZ8Kl6RfdLGlr8NP/648kIoKu/UR4YJ6VNvjaCuqHo8pDjW4EuXMSOd2
	 p89l3j0m4kBKxIg/Hf2eVXy+KOTi9tE25x2GygGGQG+N1EpJQTXXTdu6oDbWYFuSHX
	 4ORomevYck2KE8Z02tNpxdC3SXjwnOfi/A04o52zJkMJ6os5+Cffp6LZC247EH4csx
	 fyrcfOEkH32EdyPlP+JBrNOHKbYEwcihfP9jKcVOxm848kNVkZcRYnMh0AjdxXXJ/c
	 5XMlku8UBhPVhCwokXx4F73HlpVWyUPbjVTMMEepQBSTw/dAvyDedp82WYQcdti63O
	 hIBC1qD6Q7HvA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
In-Reply-To: <20260906144629.17009-1-kartikey406@gmail.com>
References: <20260906144629.17009-1-kartikey406@gmail.com>
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-Id: <178903146308.432315.2307204750064574435.b4-ty@kernel.org>
Date: Thu, 10 Sep 2026 11:11:03 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sun, 06 Sep 2026 20:16:29 +0530, Deepanshu Kartikey wrote:
> __xfs_healthmon_insert() asserts that hm->lock is held
> (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
> after allocating hm, before ever taking the lock, triggering a
> lockdep warning.
> 
> Take hm->lock around the call.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: take hm->lock in xfs_ioc_health_monitor() before insert
      commit: 4870da4f49ae2df4f804a6f770d56846e57495d7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

