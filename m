Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801511;
	b=z8nSpDG6EsUSjLlsprwRUTEFUSqzLOjlD1s/fQvkfhsl7dTAT39131TUFQjFX/KEkiLS
	 zLTEVluBxZ5eF3762ONobGT6gfTmDof57h+3Aswyil0qvttKTj7cu752VjVi8PSxvVgLX
	 jj+Rb3KOm1ybQisBLJYpxsSE5oNWJyh2/2mZ+IfhwAmjQUoUcp5RlFQBHX7SzLrxQMD4+
	 KLF21XBiu/2/vYMJuq2D6YMYVqZiPDt7hmMbbTPiWBF9Qqa3c77O3HhxhVsm2yvDGphsd
	 B9DdkO44U9EEG4k/gSIalYuTC1YD4WZO/rg91aCKq5+fKQGSq4CIHqxQ0Q01tcU1e5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801511;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=d1PpzXU8mrjP7OFzeevpUh8xy9cWgUX+wwF4PCP//LE=;
	b=qAgvLvkO4U0hZ3r4S8KTvLqwGoBoymCIaCMzx3ejFimWti02C4tdESMPN5UZ/tMPEToa
	 Ze13odEhuG+gXoDbc9AuqmZEuPiIgtK3PA7RS/x7RVmuE2N+NsdnXLf5tuxorbFpgz7aa
	 e+IstKTCOVQLz4AMdb8qv9yzA0ivwmleJPR5OhSv3HGHoaASaXrUp5m2MWmE7tjPfCB32
	 LuBjxYbJ9q21xtmUpeEhnVsK6nTxmotFK+89p7ha8gGygArjCyT01RQTUqUGFeGtetaGz
	 EYC+Wr7yodFzcE0o5IY82FmfxXjqKq/5geykTp2DYdumUcea0dhQAg1+WjP5NxvmATg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UI1BmNdM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D051606EE89
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 14:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UI1BmNdM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015871F00A02;
	Wed,  4 Nov 2026 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793801510;
	bh=d1PpzXU8mrjP7OFzeevpUh8xy9cWgUX+wwF4PCP//LE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UI1BmNdM3KnDg/5LeNGdnUFkXJJz4ukOXPjQt9LotSA7fw2xWUd8hq1bxv8XEThoo
	 SVH5tw/MlIEinw4Kvdlmw0TRJjHMmieAMU4sH5hNr10dgErloAq+9oMuOQHzNk3oLN
	 CrZErcfhyB23+ud/+Qbqk+Xcy41fd3uT5usC0eVeCI6YU5z0hAtJHE92UYFY21WGbw
	 TBbYUh/YuEO/XF+cp790VJ7xCCS/2MT57hJHlPC8qpzmZaYpJrx2EThYqJQTKhEV5R
	 vVx3lraNRvlUB2y7KIu9Qecl0ATNzQWRK4/Jq6T526azdmKgbG75AFsSqOdMCUme6v
	 oqMGZKL47ps3A==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brian Foster <bfoster@redhat.com>, 
 "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20261103105654.3129688-1-wangkefeng.wang@huawei.com>
References: <20261103105654.3129688-1-wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2] xfs: kill xfs_trans_set/clear_context() helpers
Message-Id: <179380150972.5728.15418976397607956894.b4-ty@kernel.org>
Date: Wed, 04 Nov 2026 15:11:49 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 03 Nov 2026 18:56:54 +0800, Kefeng Wang wrote:
> Open code the helpers so that tp->t_pflags access is explicit, reducing
> the risk of misusing them outside the transaction owner thread as seen
> in xfs_btree_split_worker().
> 
> 

Applied to for-next, thanks!

[1/1] xfs: kill xfs_trans_set/clear_context() helpers
      commit: 7ba9663607b31108b4350b604a3c85ae86c67c19

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

