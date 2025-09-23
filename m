Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A8F1FF1B4
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758635511; cv=none; b=e2z9jSzAjIPqVTV93Ss01AmyiaDXRZwWyPqcn6okbxPn8RhKtBSUHAlsNp+e3CW5vFx2rCM4yIO755pKibD6A83gaImoeszN/B3OglY0C3o49DyXIW3DxNNhYAcdbtSG9NYuRYCRN3sLXguF3pEI/eeUHc7RQ4pI+eBi7QqGF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758635511; c=relaxed/simple;
	bh=z+TjVg1Lok/mIJub0r1sz+WQYBQbe06hSW6LAxhf0GI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Qo4li4tTcriRKS/1o8jJ5whlDL6tNwaqUaj3bWXuCJuxzQXjR7v/HWLBkK2BoNGxHiQqUuMw7d3LErdJU6b6G65LTFGNaN09AE3crJuSrCTDiZx0EXO6F3IPT/bn74hZNInkTtnA9J4HZdiL9ubRFWlS7hM2wMUnukIAn9bvpDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UR03+NO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UR03+NO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27EDC113CF;
	Tue, 23 Sep 2025 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758635510;
	bh=z+TjVg1Lok/mIJub0r1sz+WQYBQbe06hSW6LAxhf0GI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=UR03+NO4YyrAp20QdJ7A++yRBig5ogbEIYzS7LLT4QlfEPvxKyCmma1OSRwbAhLDE
	 TOoN6ZlJ3iatSy6l2hgINgtymYaoHh3MgCAF4o5cEkxte9ZmBs+ZaoXIo1V7lkTau8
	 DtLehUZgUPc5MzhUm2y6p4FuSPbMMNXO+44E3RJwhtfOD6LNFH7pWDYUQvwDZh+dXf
	 OoXROGxZM3le7o1pYYezobmy6pEFbNGeet8nsIleWq5RPmuIjayRzIIbKHXxycLaJy
	 XTyV3/ErPwloBTxwnQsxnz66ZoKN+T09RacG3Ojs0adNyaCFvwqZLb3vbhsZkUi8sY
	 CjkbLMqeTF1bg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, lherbolt@redhat.com
In-Reply-To: <20250917222446.1329304-1-david@fromorbit.com>
References: <20250917222446.1329304-1-david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: reduce ILOCK contention on O_DSYNC DIO
Message-Id: <175863550953.58540.16793449440330359951.b4-ty@kernel.org>
Date: Tue, 23 Sep 2025 15:51:49 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 18 Sep 2025 08:12:52 +1000, Dave Chinner wrote:
> This is the changes I came up with in the course of the discussion
> with Jan about the fallocate+DIO+O_DSYNC performance improvement
> thread here:
> 
> https://lore.kernel.org/linux-xfs/CAM4Jq_71gxMcnOdgqWhKEa53sr9r57Qpi0hc5bs3NgtnNOGwtg@mail.gmail.com/T/#
> 
> The first patch is moves a little bit of code around to ensure
> that xfs_inode_item_precommit() always calculates all the changes
> before it starts manipulating the dirty and fsync flags on the inode
> log item. Whilst technically it could be considered a bug fix, the
> bug it fixes requires an inconsistency in the on disk format to
> exist first, so it likely won't ever be an issue in normal
> production systems. It also requires an application to run a
> fdatasync and then have a system crash just after the
> inconsistency is addressed to expose it. So the likelihood of it
> ever being triggered as a data integrity issue is -extremely- tiny.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: rearrange code in xfs_inode_item_precommit
      commit: bc7d684fea18cc48c3630d2b7f1789000ff2df5b
[2/2] xfs: rework datasync tracking and execution
      commit: c91d38b57f2c4784d885c874b2a1234a01361afd

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

