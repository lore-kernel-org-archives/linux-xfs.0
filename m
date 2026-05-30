Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F5A37EFEE;
	Sat, 30 May 2026 06:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780123241; cv=none; b=jbiVgr7awng/7y3yOkQ8jx1zVbZEUzYY/13mZ5kBMINX0aQlwoZ8e284c5V1m9FqeIvkuahf9LNRgKldVNydZ5UWx1Kw/CSkwn3H6uJDFwWvp/cuLr3yvTi67NCimaZ+8jztIbhQ9FtKVDslERVYgXBsbw3e7RopJB3bbTzVav4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780123241; c=relaxed/simple;
	bh=UlZeNrn57zD0qGBSF0tnp14lOjPzd28B5uQ5BqhVM6g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LdzK/kO8+Mes7OWGgTGGZCWkm81gDbhWJrfuYrSsKL7KFUP25tRiChOPlghqq38gLrFM1DSQAqBSaMpS3e5K8xQl6XrH/wGwMN3XLtmTDuQ0UjGQSfoUNjM7HChhp3+De4zaUv3Q0saXQgJtdHXwx0I072f1+UpPk2UkLhADciQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8LxdfV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8LxdfV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EAD1F00893;
	Sat, 30 May 2026 06:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780123239;
	bh=K5oJh5vZYo+ZnA8FEvO/ur5FgVQSgPYDDDrVI1e3Uhg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=F8LxdfV9K3traIjdqI4baMiaO3zQWCwndIu6QyCYG6YJhJkacaK3MgbBV4nY6zfDP
	 kAGZMOlkS0Bt/ton+LjN406zQHKqrFVInI7TczpqMzJuMvOdk2ZDdbXnd/q01lSBLf
	 c8mPpOHWOlfcOjgcz4T1aG1EZM2f+knTSxacthuLY6g263XXzbRPZhEahdHbnB62Je
	 hq5MkejnB1nCMhMBE5eNVrz5CNAgU3LlVFwkmyWty5mecEWPflOBEuQkReTbHvWmmW
	 XYy9/Js/otjNV8jdThGNCDxoaNXfni9mWeQeSWie464StcyiMLMFqKmIbmfm/iKOV7
	 MBYR30WtR03ng==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Yingjie Gao <gaoyingjie@uniontech.com>
Cc: djwong@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260527043134.1550710-1-gaoyingjie@uniontech.com>
References: <20260527043134.1550710-1-gaoyingjie@uniontech.com>
Subject: Re: [PATCH v3 0/2] xfs: fix CoW fork repair error handling
Message-Id: <178012323788.23341.1909140292468084007.b4-ty@b4>
Date: Sat, 30 May 2026 08:40:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 27 May 2026 12:31:32 +0800, Yingjie Gao wrote:
> Fix two error handling paths in CoW fork repair.
> 
> Patch 1 makes xrep_cow_find_bad() return saved errors after cleanup.
> It also lets a force-rebuild bitmap error fall through to the cleanup
> labels instead of returning directly.
> 
> Patch 2 applies the same fall-through pattern to the realtime helper
> so that scrub rtgroup state is released before returning.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fix error returns in CoW fork repair
      commit: fcf4faba9f986b3bb528da11913c9ec5d6e8f689
[2/2] xfs: fix rtgroup cleanup in CoW fork repair
      commit: c3e073894379532c00cca7ba5762e18fafe29da8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

