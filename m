Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0D354AE1
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 11:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762858818; cv=none; b=Ka8Uy4zsrJb6lWYCn9pMRvWKnEPfP+khNKjcUljENenxc+HvgYodx3EVzVBgRtpgztSX1e7KCZ5s6RA4ndAUNO6IOlOX83K1CuDRSF/+M36Mq1llvVm8GxoSZgePCPgC+dpgWfITiKRIKc2/2ZyM9SeNUlq1k0XHXrqkcQbsTI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762858818; c=relaxed/simple;
	bh=ZI9H7SOoHctyoRzzMW4qYeQQ/YHj3P2qEYsaUA30GMA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tPL3604gTBWmBZtjANp2SztW0ZuJ8kol26BvWMmGIwdQs8gOHKvjTaY8p8QN6F+PgOv+EELQGfhAnZZMup+ZqnO0qDihjUFHwZQ2eoSIhnhL1kp1Ps9lz77v4iqHho37AZUv5/LnJRbb8Oe19CJ2O0CfADRACX/Ru1pXdfjp3/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjeQ+Mh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjeQ+Mh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EF8C4CEF7;
	Tue, 11 Nov 2025 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762858817;
	bh=ZI9H7SOoHctyoRzzMW4qYeQQ/YHj3P2qEYsaUA30GMA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=AjeQ+Mh2nmpTMSyroSLqvtnwhUmxlxsHP/Z54o9JUd9nBi6h/inJujUCELPl1vCN6
	 zD3s+ebP5oyQkfQkKWI5znohD+gZEFlEAn9wojTmh/QYRwm4/07s1RKGV7QMb9wPJ3
	 RiQa8zbUsRG5kW6Loy22CwqDo1El/4lLmMSFx6/zG5LW4uG7B5/vbTBcw0leGD5PMQ
	 PGJQyyRLjtiiuCsOLk6asl1IKBfMoNa8cNuzMkUG4AP3EtlZuF7FgVKg/M7XbEhzGk
	 8QoyiiQadtIAwvSfZpEY1Xb2M82DBPyOe6PM3HAmy4ttvaHWqnw90B+W3UUSKM9Bcv
	 njBTdhMjPfviw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20251110132335.409466-1-hch@lst.de>
References: <20251110132335.409466-1-hch@lst.de>
Subject: Re: cleanup quota locking v2
Message-Id: <176285881685.619206.6020641166927868145.b4-ty@kernel.org>
Date: Tue, 11 Nov 2025 12:00:16 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 10 Nov 2025 14:22:52 +0100, Christoph Hellwig wrote:
> this series cleans up the xfs quota locking, but splitting the
> synchronization of the quota refcount from the protection of the data
> in the object, and then leveraging that to push down the content locking
> only into the places that need it.
> 
> Changes since v1:
>  - use min instead of the incorrect max for s_incoredqs
>  - add a patch to fix a pre-existing leak identified by the build bot
>  - fix a new locking issue identified by the buildbot
>  - reorder patches a bit to avoid inconsistent intermediate states
>  - add a patch to not retry non-EEXIST errors from radix_tree_insert
> 
> [...]

Applied to for-next, thanks!

[01/18] xfs: don't leak a locked dquot when xfs_dquot_attach_buf fails
        commit: 204c8f77e8d4a3006f8abe40331f221a597ce608
[02/18] xfs: make qi_dquots a 64-bit value
        commit: 005d5ae0c585e11d31df1e721c04f113a8281443
[03/18] xfs: don't treat all radix_tree_insert errors as -EEXIST
        commit: 36cebabde7866c30b71ecd074e3773dbd768a1d9
[04/18] xfs: remove xfs_dqunlock and friends
        commit: 6129b088e1f10938b86f44948ad698b39dd19faa
[05/18] xfs: use a lockref for the xfs_dquot reference count
        commit: 0c5e80bd579f7bec3704bad6c1f72b13b0d73b53
[06/18] xfs: remove xfs_qm_dqput and optimize dropping dquot references
        commit: 6b6e6e75211687c61c5660f65b4155cd0eb7e187
[07/18] xfs: consolidate q_qlock locking in xfs_qm_dqget and xfs_qm_dqget_inode
        commit: 0494f04643de72e13acd556e402cc4edc6169950
[08/18] xfs: xfs_qm_dqattach_one is never called with a non-NULL *IO_idqpp
        commit: d0f93c0d7c9dc8f7fdbd1ce3f5d3bfd8e109da65
[09/18] xfs: fold xfs_qm_dqattach_one into xfs_qm_dqget_inode
        commit: bf5066e169eed0b7b705e3261a05db80f1b8358e
[10/18] xfs: return the dquot unlocked from xfs_qm_dqget
        commit: 55c1bc3eb9d0f39ea4c078b339a6228f5f62584b
[11/18] xfs: remove q_qlock locking in xfs_qm_scall_setqlim
        commit: e85e74e4c9a64993ec5f296719705a32feca93c9
[12/18] xfs: push q_qlock acquisition from xchk_dquot_iter to the callers.
        commit: a536bf9bec6ac461ec48bc8627545d56e4e71e9c
[13/18] xfs: move q_qlock locking into xchk_quota_item
        commit: bfca8760f47ecda61441950babbea6f79a51b377
[14/18] xfs: move q_qlock locking into xqcheck_compare_dquot
        commit: 7dd30acb4b3724ec4ecad1a6e2e19a33c0f0ace4
[15/18] xfs: move quota locking into xqcheck_commit_dquot
        commit: a2ebb21f8ae1a8cc9414677ac7ddbf5c7cc6f48d
[16/18] xfs: move quota locking into xrep_quota_item
        commit: b6d2ab27cc84b19afdf72eac1361fb343c4e0186
[17/18] xfs: move xfs_dquot_tree calls into xfs_qm_dqget_cache_{lookup,insert}
        commit: 13d3c1a045628e8453c31bd49578053c093e7a02
[18/18] xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc
        commit: 6a7bb6ccd00580461f01e86f592c7d8c7bb54793

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

