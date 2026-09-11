Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777D44F56E;
	Fri, 11 Sep 2026 07:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111746; cv=none; b=cQDojyVOGUZi7FU9EC6PplBCjCz+O65WPvsfeGob94EKvRjKX4Yu8VgNpFf9nejKnF/0pn/tZuLr37zoeoAWSpid/HhiSr4GJR6LgZCWhfve9R2ENEyWvt/JYN1eU+7B3ruifr1k6PigaTEabt1nbwwE4UA/xt4KBz4lCNzX+tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111746; c=relaxed/simple;
	bh=LLeopuchSu6Fs+Ym+7R3u9a4TLh/uZHWUq6heCvUmTs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V4T/ozUQ7h4AqgXhNTwbhZb1orKssgmuBpArkAvcSJy0yISFKrvnLboGc22C3Le+Jzi2cmHkr4PK2Wh9Sl6G8sqL+14pd2rILA17GGYvme7c7oELGluE4yKI3VPfgU2G+iPeK3ggGkYETlRYNe9xFc/Mow4CPdZGA6FYWvr6SWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLcC3Gsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLcC3Gsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960101F00893;
	Fri, 11 Sep 2026 07:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111742;
	bh=jPO3YZjp0NTneOto/PGhZ/C6mLSbEUhY1NbbRXSGup8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MLcC3Gsp8utfdxpOruqmKmlRfetED0D4iDHba2uv+STeeenVBpWK+Fy9sfJVb+1Rn
	 3iejQSBUCoCAcF8Mzk3arcCa/FT0NqgWV4GZrwBtQvNNOYeQLKUridfKg/245MABR4
	 xgAs19D0mG8btyPzZPwVJrOBiq4GCDberSqhvN1kVgDAi6EojMUR9LKROsP29mHbsG
	 XnwPKHAr4nOYQgGq69hmecNCL0sAscWAzrrhEF5GFp05j8hxiK1PE9WRvR4/kVGavy
	 +e7DXzrXh+4mcKEuTmTqeBIktTdr9rOoEC8d5pNNF4DEW1U9Vx6BI8aMQ3+dgyWmmq
	 IzUAXDgPteE1A==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
In-Reply-To: <20260906144629.17009-1-kartikey406@gmail.com>
References: <20260906144629.17009-1-kartikey406@gmail.com>
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-Id: <178911174131.25328.11347565991995752423.b4-ty@kernel.org>
Date: Fri, 11 Sep 2026 09:29:01 +0200
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
      commit: e240919ca727776f16a468d3d90686dc82cfe9cb

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

