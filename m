Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5734B4CE67B
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223594; cv=none; b=qvEYq98i+5m8bKG+nM1Ry7TUm86Z6qtK3rSEhBMtdZueQ/i82J5jd+UcF56/JmQonyLbQAyY9L3yI7EokGoS0fz3LFY3AzcQ/kMwmOan/ykjtPYbSoRDhH8CciiG7jJOAdt47xU98H/oH92Ei5a3fAEb/dVfBGEDQogNj3XDFeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223594; c=relaxed/simple;
	bh=eHpjtsFvuU1CVXgYaWXwNBVg9FtYfU7irC7TUL2o0nk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ledg2ANbhbsahbg0lppt9jLTgRmbw2UZYCwUpeBnrSdLMXBSeNX1vxthnmh2kiouZuWNehAjUQsSxPLNj8Xvkd9JNs1Ad58y5HAwkMu9TPOeeo/dOHMHWmZ6gkGu7Sq+6bVx+1YzgzrbOdOlh9qCdc3NLpGTjy9lGYie8hMurkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQy+8LIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQy+8LIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087C91F000FF;
	Mon,  5 Oct 2026 18:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223592;
	bh=hvC5IehUql2r3kfhr5NhRuxsuN2H+7CxnmHYos+IDUE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KQy+8LISlABUKygeJU09KqA3BtUYia4URiAqTzwXyIZZxVdXUJo0KneZyzY/yxZR7
	 Yr2iRNjV3RpyB8M9uSOSFZj056mxSsdMYAbMUbiRN47t4PptLYp2eltFzAL/U6e3oQ
	 ZsuEIAAqkojkRErq6K4oLivkfswFkY7cmo5WLbu7UfDtr+6kAscDCdXhz4X9bTBnwK
	 Qs5CO9TMtg3oES7UbhUBLwVF6sSzHJ3nsPyVBndfopZM9UGfhhq5ME2JwOd8IeOXJo
	 bDjD7QspCG31QRalOh8MrOMhLMb9NcbF6Ub6A2EOgsG8UhkA+ZaApAsbpqGJ0JRWJU
	 B5Oq5RuBDTrHg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <dchinner@redhat.com>, 
 Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
In-Reply-To: <20260921071030.3214538-1-wangkefeng.wang@huawei.com>
References: <20260921071030.3214538-1-wangkefeng.wang@huawei.com>
Subject: Re: [PATCH for-next v3] xfs: fix NOFS state corruption in btree
 split worker
Message-Id: <179122359071.102066.15509293508787425638.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:30 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 21 Sep 2026 15:10:30 +0800, Kefeng Wang wrote:
> xfs_btree_split_worker() calls xfs_trans_set_context() and
> xfs_trans_clear_context() on the caller's transaction, overwriting
> tp->t_pflags with the worker's NOFS state. When the caller already has
> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> the caller's NOFS protection.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix NOFS state corruption in btree split worker
      commit: 23f91a51425ed3d4a5c42978fc25f1087611e4ba

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

