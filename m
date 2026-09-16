Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCF248D86B;
	Wed, 16 Sep 2026 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560414; cv=none; b=uqS5Q62qSFFFwwLK3+Ezy8WekB+3dSUbgJsB0pC6FMNZMht3hOC2/6+Z/VQeuId5pbmUMgKiEOPOWsr8f9lQAufrpr2+1s2yA6CMUp3HZ16Elp9S9ckuXIv2hQSxq3CE5LzfWTG0LJJvvO8sLg49ysrL5r9HpazE0RqEZFM/0co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560414; c=relaxed/simple;
	bh=sJfyPSRSCi921XUibwlhn86EDykFnPLqnQGQUoDbv+I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NTb29ObLmjky6PNnbx7fQyH7NJOBfz3rrJF9tN/Efo0BjIjMRPvE7vv3JfCj4dKMaUQyOOYvk9UaK/JROkqQD+GTgvMMKEAcg6k3D1k1P2Amfz2K7y0h6Uz7zjghBon8nc+G430CEoS9E3vPVGPdi2FwukYbq4A4hNHfiIsU9S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqVNqZrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqVNqZrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70FC1F00893;
	Wed, 16 Sep 2026 12:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560401;
	bh=NDbZ5oWYDY4NfdAdp/cW4oV3ub4ZSbhVmR5rxE1rXvE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XqVNqZrcnE0mY2UvqTGPqle38MpkSihI2b/xUj8mqTZwZ7tDCBu9kvs8wKr8eLSSa
	 hBOXWKEaCEHJuHA5h7gJ7lrNP/DPqVwzMzRExD7POxYhkpVmpyqb5JxlVw0Q9DRED/
	 wJTtU4kKXz1siuND4rxtrIpdyhOsXNWED1S2aWrjmPSXcLgTxXM62k/rwa2aiOnzjo
	 0pc4UkZdRqJvCcnyIdG7DRlrFexZFqSnbo4DoaO6coYR1nIjiqOd/gw1lMGUQ4gqLu
	 Mlaqf8kL82Uigt9FDsvcOxmQLJbsi1M6nM3ZNF/5/8eUsRd4Epnz1j8yCCJ0Ve5OYs
	 NQonjeP7NOdng==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: LLM-inspired bug fixes, part 14
Message-Id: <178956040056.10466.14255436339615019963.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 10 Sep 2026 22:53:34 -0700, Darrick J. Wong wrote:
> Here's a fourteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: check padding field in xfs_ioc_commit_range
      commit: 3083ba8dde765a9ab2337f3db68d00724a6b1202
[2/6] xfs: don't call xfs_exchange_range_finish for a dry run
      commit: 8fc18580ec17f90beac4c933fbe4c74dcd3b7f36
[3/6] xfs: use the correct reservations for rtrmap/refcount recovery
      commit: 471e0b6e2ddac9e16b8dc2153d6e5575fefb8a2f
[4/6] xfs: fix integer overflows in xbitmap set functions
      commit: 46c1b6674a7b3a8385e7fa27f4efc6f45eddf967
[5/6] xfs: only flag zero padding for dir3 data blocks, not dir3 block blocks
      commit: c54110d814c3e8ed6bbbb5e02874994ed9f668ac
[6/6] xfs: check di_forkoff correctly in scrub
      commit: e9193f2f1ce32d02b9230094ffdbfab715ab6137

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

