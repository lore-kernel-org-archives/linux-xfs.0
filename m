Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179B3387342
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773304743; cv=none; b=hzuyKl+tc0Oa/AuMIV/HSKSXY0T2NXOFX5TaKZGjsTykoYqn+bGOQekF/3kaslSAYtdSWCCgPf03WQI1BDP6fLq4dCp4fPIEd78DoUsftDrYiFVrd0VMN0Kt7iT+4bTyKmUBMdjICu1S5ZnZULsrm6KH9YoBz867oC5au5FTTsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773304743; c=relaxed/simple;
	bh=zrmNlWzilPDrCluOQQSVbklEU+D+0LARP8QcG7REtU8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WAMCMZ0b5CqCd+UHu/zgK2YTLvQTCxg6o05NR6O/yqJiGXzNql7e1dRPNb+pug5/Uz6nYheJp33rmI0o9xlV2GeuMG7CRjo7wGTpVpqLnfOUho3gzYKF7RhJQ5gmdxClK5Q1Ru+t+uaaJQ+IgVjIqoJDWzucM5TYVh59llt5yPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azs9KGo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azs9KGo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7385C116C6;
	Thu, 12 Mar 2026 08:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773304742;
	bh=zrmNlWzilPDrCluOQQSVbklEU+D+0LARP8QcG7REtU8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=azs9KGo01CMWARx8GovoeAtxAvZjPXQDiRMbNAEfI+7MoxLFt4aL04a02+R0NtAgm
	 3dXERDH6LpHT7VrJNzQnMH1caK1OMRddfuuNKAY0HMdDnT8b60Dlo1dtjg/JqMtN6U
	 re3OtuF5Bp8eq5dfKwuEZlkIIzifvC8I0/gY/9WgdY6T126/LaCkSNg6muApbWBk+H
	 hLHxC2TxuoXOi0dScYlsIEnYbSSf6tvzV0aHuonwpTHlBCzMgj7QZK5eXGQMxUdv4H
	 y0KdDjC02kSS3DqN2TRjGcPWOXU7KAViQdMtU88meT5tFL87rzOobVlKMc6Cj8NjBf
	 47xS/5vtwauTQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20260310123233.449659-1-leo.lilong@huawei.com>
References: <20260310123233.449659-1-leo.lilong@huawei.com>
Subject: Re: [PATCH] xfs: fix integer overflow in bmap intent sort
 comparator
Message-Id: <177330474045.21168.6950788298705202973.b4-ty@kernel.org>
Date: Thu, 12 Mar 2026 09:39:00 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 10 Mar 2026 20:32:33 +0800, Long Li wrote:
> xfs_bmap_update_diff_items() sorts bmap intents by inode number using
> a subtraction of two xfs_ino_t (uint64_t) values, with the result
> truncated to int. This is incorrect when two inode numbers differ by
> more than INT_MAX (2^31 - 1), which is entirely possible on large XFS
> filesystems.
> 
> Fix this by replacing the subtraction with cmp_int().
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix integer overflow in bmap intent sort comparator
      commit: 362c490980867930a098b99f421268fbd7ca05fd

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

