Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C5536A02F;
	Wed, 16 Sep 2026 12:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560421; cv=none; b=CSnqczL17PYfVP4WvvQBZM+l/O0fDu+Tm7qEc3+mF11rG8GGH5NNlhhM0EJY5NP7g2LCjwtg6WHMBF1Pc2lwlC7NmMm/Wr6dBXsi/lUjYhdCPyhoHY9FDC/yWBtXFhLTJQYvqCHwj6nnEaT2nSbuPLziCk6oX6fe3wSDknsnD9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560421; c=relaxed/simple;
	bh=6Q8ZynN9Z8MCFE31qsehets/1gPdbyFkQ1IvqggL8Zg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OwXs1eqMVBrd7QrILH9tdTr6kKvi545NdtiKunhn01gXVoxNZzV/i3/tNHxhN6MNe7r0Moe7jADwmbyKzLMOi2lkepFSf1mjng+r0EGq3nUcfrWpi8G1204sd4rbrmYzOE2DYt3Sdw9wV43mqZA0nKsMfvjPZZ7hDj6Q1jxLypI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWFRxJHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWFRxJHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009451F0089E;
	Wed, 16 Sep 2026 12:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560411;
	bh=IG4/WBp8VdGaENMIv48NIp73xYCDx1hUQsKRMQooz7s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OWFRxJHrkTflD1P5IQiE3ZFeafY0ZyzgzMtE2P7+Cfp9ccTKG6kOYdp3LOOV1drgh
	 w1DxhBfrVVYgebhpjKLmApJyF95/WcAp/huTRMBvoeyNjfVh9xxmYZNujxtA5pDEMd
	 O2pi4t7GYcOQsJdJkcKUkiHUhivvXN3K7dy4QIsGs1NjLY5Uxxg/CMyFiibebFhS3o
	 zJruLSwXd1Couc3ulnLS2tam0KsSL5ctvWuO2AWrnpUxR21yXDYXTBJWOriS9ZtwJs
	 7vvk3vfKq+Lgs2nAT5YN25yLb9rrSeritzLgCIDl5yJWhgPn5nCo5fn5hxSaFti2Mj
	 XITg+Xtpy27BQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: LLM-inspired bug fixes, part 15
Message-Id: <178956041069.10466.8117121241382725467.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:50 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 14 Sep 2026 22:36:43 -0700, Darrick J. Wong wrote:
> Here's a fifteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
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

[01/11] xfs: always call xfs_qm_adjust_dqlimits during quotacheck repair
        (no commit info)
[02/11] xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits
        commit: cb2194c0d7b2b913e171df9601f3b7aba6337525
[03/11] xfs: fix rtgroup repair estimations
        commit: bfcb66fe0df3588614662d5e2172586e068ae812
[04/11] xfs: don't cross reference rmapbt with bitmaps if they're incomplete
        commit: 77b4ee1509046e772192d3955142c542aad023ce
[05/11] xfs: don't let memory failures leak blocks and kill repairs
        commit: 06f5d4c2be3b18b6a3eb5f0e1ff4c4a5b420171f
[06/11] xfs: don't merge different file IO error types
        commit: 509688570a42dd42a4eb656d55cf56c285621528
[07/11] xfs: fix blockgc group quota scanning when usrquota isn't enforced
        commit: 4e07c52ca4bd9191e3718bee30f1000333446217
[08/11] xfs: fix cursor and pointer handling when recovering iunlink buckets
        commit: d3bb71b6c6c249139215f2ee33120e2c8005f104
[09/11] xfs: drop dquot flush lock when we can't find a buffer to flush
        commit: 979dbd93efd51c12e386869e6db5df497656a60e
[10/11] xfs: don't let hidden_space go negative in xfs_metafile_resv_init
        commit: d2d0237773deda949c6cc02e001d5c7301214b86
[11/11] xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots
        commit: 407b04dca6614a77d3c867d5cc71c1ab31768444

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

