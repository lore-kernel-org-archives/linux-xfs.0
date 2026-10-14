Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABD1516177;
	Wed, 14 Oct 2026 16:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996810; cv=none; b=BE700rq3dvj80/3bz/WF1AyYacEUNublMDVBHIeRcWhmWIeM4Pp/j3iuqrHkBmJZWtO+whQxHh+CTUXQ16nP9iwkYcDCEwBt+k+fsqV1an+Ykj+73lxh9H2Eiuqn/xOJJKaz4zVsMX/+RvSLOjuwKm/sEX7q3qvWMCaNeEJz9A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996810; c=relaxed/simple;
	bh=yRKHWVknP+ngck4UNR2cDVxyXX5/3xcEUHNVjvExDGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZzElr5NPRfnZg1gOP2a0r8yIPa1zhmuz8Pu0J471f/qF4mxq6mLA2gV8yHwY0W9BneMUsG/YITHNyJRbmx6jFNGQTyYF7JWe4pmFbHV/6CsFHTsSbe/sBcWSArxGbTYJVcnQsSYXaXXlNycGirVqQOXvjsKrC0YY3iA19DLw6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Owyx0x/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Owyx0x/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99521F000C6;
	Wed, 14 Oct 2026 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791996809;
	bh=SxGO9z7tobaNiKFlT55/cwP9MR84qSaMj9vm0B9Wz4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Owyx0x/QHd6dqsJOQT0ySU1V128IokWBNQVubgG0z/P6ZRwcBUK4FAovDkgk4CeyI
	 9DNCZ76NQBMP4nHfMzBMo4u5/rz/Te8z79AQgn6ZvUaKrIBm7xgiCKYqMPGG9JB3L+
	 eI6r2eR6I5FcNyHtuQXNKYNLX1wEKt3w1VHn5ysGNlVTdUL75eJ32P0SXzY+aDFlZu
	 zIR2ASIEwrFmFM2e/zJemIystITH88he/ayRLBwm33WThXGWKuMi0MwpCBgtBAQ+r4
	 bhuDOi4EfauXlfBGOnuud8F0e0jMtPoerxdZvSFfTR+mgLAFWLufoDU37rGvE7yEw4
	 P4Yw5YfdO+/8A==
From: Sasha Levin <sashal@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: Re: [PATCH RESEND 6.12 v2 0/6] Backport of XFS umount hang fixes
Date: Wed, 14 Oct 2026 12:53:11 -0400
Message-ID: <2026-10-14-1-daily-reply-0008-xfs-umount-hang-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backport of this series:
> https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

Queued the series for 6.12, thanks.

-- 
Thanks,
Sasha
