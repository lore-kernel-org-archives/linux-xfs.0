Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA0D2EAB71;
	Fri, 30 Jan 2026 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766727; cv=none; b=B2x/ZNgt+fg7odMDZFo7Yv2BSvFt4p0PeWw6DI5CdHScrGsB/3y5aGVDWb9VXvwEiM/+CU/Yu+Bjhj1jVt+rSse4PKRQg/VgAZ2B5Ltz77FsoPxSgtjAUrCQHJJGIZPZA93Fvr2IPoUPJoDIER+bavu09A2CIvHEDZOCoRtWiCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766727; c=relaxed/simple;
	bh=QzRHMDkMfe6hwfcVW7glQ6TNVlACTNNmHj8snGT82Ps=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EMkG3q0DNh7/+MYTvfB1XIQL3bZw2b895Sa8fkgDQCG4BLRav7Jey0YTHeOuM8ceu4XR5gPTrQvcXS1R4fAxHhq5NZBXcX92g9tGEZU1Tay7scJdpBuTUmospVV2a6Nwu1RpX/lRg9zsKChqaVKti8hW/FwdSPCKLR5LVqnyo+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jP2BB6jv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jP2BB6jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235FEC19421;
	Fri, 30 Jan 2026 09:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769766727;
	bh=QzRHMDkMfe6hwfcVW7glQ6TNVlACTNNmHj8snGT82Ps=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jP2BB6jvZYMu3FBfBxZo+0NGr03Kt/T7wyY5cHxKPofbYYvRq3cllb0Y+qPps4vmo
	 +3XiUH+4p4Zed4wHE/7RUZ1BWPjov5Vywi4RXnUksypIDJPdOTYocgrb2Xu50A3Z4k
	 XY5DkFwUTNf38JEbu3AMpolD2V0+14yMka1/rsSKYVXp9G8ESvuDnJXlSmh98AH7cY
	 TKvH1qcCJnGfyHrpquCYByBaPZo7qzoS6SbYTnhjqwtAqS2V3AvlVy55WoIq0JLgoE
	 t28Tr4aPAXtKqIJYTaMnIZaJJ42c1wItwj8tbo9Y2o9lcdo8gOfhyQMs70CIfWWUAF
	 vnz/z0g8Fnbtg==
From: Carlos Maiolino <cem@kernel.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: chandanbabu@kernel.org, djwong@kernel.org, bfoster@redhat.com, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com, 
 Christoph Hellwig <hch@lst.de>
In-Reply-To: <20260129185020.679674-2-rpthibeault@gmail.com>
References: <20260129185020.679674-2-rpthibeault@gmail.com>
Subject: Re: [PATCH v6] xfs: validate log record version against superblock
 log version
Message-Id: <176976672483.101188.14038361815799165327.b4-ty@kernel.org>
Date: Fri, 30 Jan 2026 10:52:04 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 29 Jan 2026 13:50:21 -0500, Raphael Pinsonneault-Thibeault wrote:
> Syzbot creates a fuzzed record where xfs_has_logv2() but the
> xlog_rec_header h_version != XLOG_VERSION_2. This causes a
> KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by adding a check to xlog_valid_rec_header() to abort journal
> recovery if the xlog_rec_header h_version does not match the super
> block log version.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: validate log record version against superblock log version
      commit: 44b9553c3dd043f14903d8ae5d4e7a9797c6d92e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

