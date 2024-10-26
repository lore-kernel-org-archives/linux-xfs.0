Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014D070813
	for <linux-xfs@vger.kernel.org>; Sat, 26 Oct 2024 07:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729927645; cv=none; b=JhZ1J90G9gcmkt2SYCNeOu1I3cGhm0TaOomY0HXy5NQ4j04xZSE8KJVnEsTaf1xNUg4YrkxQJhZzVMQQXcEXoKYQpCRWtbVpgV36dc21aH7q+wpD86RGkO1RMeZfK6s03zE+9YH5BCstAWi5FslMY1pKFcIl/C1nMQXKfU/NE8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729927645; c=relaxed/simple;
	bh=uAghynI80UZUzdG448DsdD2z1mKymuaSb6RwRcfZ4aI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=O6fMbvocQPraVTh4C+9lVC+Rj0k1Nh3vsiCOZL42GNuh3YADadgYG4kI/HnFFmwd7Uc6IIU5fUqG+PyaoGWnZvGbbJwry2cw6hpktIzVfRyFlV1NYb5kyCg4qVBIX1vM8iL406+rc/v0Spc5ZT0FKBDHCxOK3TXHxoDNyMRVti4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPtfDPR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPtfDPR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A989C4CEC6;
	Sat, 26 Oct 2024 07:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729927644;
	bh=uAghynI80UZUzdG448DsdD2z1mKymuaSb6RwRcfZ4aI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=MPtfDPR/vmSsTqdIJ2VSzH5EXW8xjs+Tw4ihIkqq4racWgoF+165wobw1Tro0uwOo
	 WU6nORdJLmAz1v7IABayA4xcq1MqRxVwWkEfex7qrZKBe5bHA8EbjT5BzwbQI1C8l1
	 bbsIRMSwaWCVdNLphVnQnN7wPSQpBaYiyYnSeIofNtlOcpU96F3ECASUJgBvT9VJ8e
	 yrZo81Wwqc/hSCoGbYCza2SxhN0X+OE82WR0zA+gSuObJIJe/q8qrgUxmn/bRqxs3k
	 OufNkGl/cJbkuelXutO8pYf+uo1QFDBxHevIwbMXZTlLxoP+FMFaI+uwhI7orzR0xG
	 8Hip+GV6QvdDg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20241014060516.245606-1-hch@lst.de>
References: <20241014060516.245606-1-hch@lst.de>
Subject: Re: fix recovery of allocator ops after a growfs
Message-Id: <172992764309.265073.7942911120965053148.b4-ty@kernel.org>
Date: Sat, 26 Oct 2024 09:27:23 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 14 Oct 2024 08:04:49 +0200, Christoph Hellwig wrote:
> auditing the perag code for the generic groups feature found an issue
> where recovery of an extfree intent without a logged done entry will
> fail when the log also contained the transaction that added the AG
> to the extent is freed to because the file system geometry in the
> superblock is only updated updated and the perag structures are only
> created after log recovery has finished.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: pass the exact range to initialize to xfs_initialize_perag
      commit: 82742f8c3f1a93787a05a00aca50c2a565231f84
[2/6] xfs: merge the perag freeing helpers
      commit: aa67ec6a25617e36eba4fb28a88159f500a6cac6
[3/6] xfs: update the file system geometry after recoverying superblock buffers
      commit: 6a18765b54e2e52aebcdb84c3b4f4d1f7cb2c0ca
[4/6] xfs: error out when a superblock buffer update reduces the agcount
      commit: b882b0f8138ffa935834e775953f1630f89bbb62
[5/6] xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
      commit: 069cf5e32b700f94c6ac60f6171662bdfb04f325
[6/6] xfs: update the pag for the last AG at recovery time
      commit: 4a201dcfa1ff0dcfe4348c40f3ad8bd68b97eb6c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

