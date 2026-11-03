Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700159;
	b=ux+AUeyX9RLPS2RaYBWLu4fuaFWaiflb3ZO7MGpD5cqR8YDdjqkT2NGdQJvKpmgyaCkF
	 F9yv6nN+UaJ6fOvjYB7wZY4ayR635x+t/2OXq8XwyqUtgKWBpaL+UeSnJboDsFHfuz4Ts
	 UtCMLbLwWxNe5o6l48sC1XTKUvLXySfFcZjr7OSEbU1lZOg5rui7UnvXJ76TR3x1bpV57
	 O2ftd0rBdDgY7ZEm17XcOR/kiw78+xQfunQKZyyOuWN7kBJ0Q0jb3Smr3GnExG23TEZMs
	 dKt4xIevL5LzSm2gOY7BlOpSozZBIKDA+isuSLUrD2Tji34x/As8DYLnxRI6FWjDsIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700159;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=kK7XpNqxG62m/TpkL4tKDvMu3ybSBpgtB4KwbYycrl4=;
	b=PRg1ODb3bZcLt90bgcWrleZDqab21cuBtiwuAwnxrN99dH0P72sMrC+7nTv4+aNkxTOz
	 xy136ca0JtxW6C0Co3SWHnYBXQdFXjMQzcyVVaqdq9sTEw2dzbcca2rN1qLR8gSFV3XVU
	 nLM0QF5rxza+bN4e3L7XIsBUtwkydLSV+sPYwOR9KF3pNtq+rZh7ec4zYLGuhmdGPpNM/
	 14Y2wDkh0SavG7zj5kfg+r6KfXB4lRWGJQB7LoIr03IQxwKFz/7dGYTl8vlH59vIw4fam
	 w+i3zGxxTxMXR367oapFom9MTqy9nZDkWdlTkYWWjOgmmWu0aB/oGbxi4cOkFMSlO8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I5t7PIYa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B4D606D83C;
	Tue,  3 Nov 2026 10:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I5t7PIYa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3209F1F00A02;
	Tue,  3 Nov 2026 10:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700158;
	bh=kK7XpNqxG62m/TpkL4tKDvMu3ybSBpgtB4KwbYycrl4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=I5t7PIYanTLoYeFgjHWPgXrpIDDuN9eaK9KjbAookoeRSJRZXrsE5N1WEdH3fdREM
	 dJ5sUg9+Oxc3LUMzuf1HAYYrHXMS58r8xSYRnYd6L+N7qWfqz/XKbuWtddSMJjTBZ1
	 lfx1awQy5qt4eGBjhiPyTvCY5Wh60Gl2LBGucONi0bJxkNcKiZStuSHYZ6z9TJtfwJ
	 xj8gE+/cKAaesOzUZtGdFvX79u7QwzGVhUsliwyqp6HoTIUS+VEp+V7qVICqy8zPmE
	 kC6T/2ophnU8zutF3m8uBpATs4C6pSY7WFKWZZ50WqiNO1Cl8591hyDQk2VgWkhuD2
	 XizjVVbAEz20g==
From: Carlos Maiolino <cem@kernel.org>
To: linux-kernel@vger.kernel.org, jianyungao89@gmail.com
Cc: stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, 
 Kefeng Wang <wangkefeng.wang@huawei.com>, Viktor Malik <vmalik@redhat.com>, 
 Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>, 
 Bill O'Donnell <billodo@sgi.com>, David Chinner <david@fromorbit.com>, 
 Lachlan McIlroy <lachlan@sgi.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20261102150146.19777-1-jianyungao89@gmail.com>
References: <20261102150146.19777-1-jianyungao89@gmail.com>
Subject: Re: [PATCH] xfs: fix temporary cursor leak in btree shift
 corruption paths
Message-Id: <179370015592.413123.10191493207403501135.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:35 +0100
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

On Mon, 02 Nov 2026 23:01:41 +0800, jianyungao89@gmail.com wrote:
> In xfs_btree_lshift and xfs_btree_rshift, when XFS_IS_CORRUPT detects
> an invalid firstrec/lastrec result after xfs_btree_dup_cursor has
> successfully allocated a temporary cursor, the error path jumps to
> error0 which returns without freeing tcur.  This leaks the cursor
> memory, the xfs_group reference, and the per-level buffer references
> held by the duplicated cursor.  Jump to error1 instead, which calls
> xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
> resources.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix temporary cursor leak in btree shift corruption paths
      commit: 2bbca049deeb1699cafd966cb2793fee576ee409

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

