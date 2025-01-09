Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852ED1EBA19
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 08:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736413005; cv=none; b=XEpwJgDwaC2Hnn5Z7A7Rd+XdAVsif1zDiSerdUeXctJriHvRa8FCj5ucIPScPcvVGo3M9rD/KCTt2omGM4nJY7IHm8JMMzRqtu5gUcDev0S09066V0chKLsJnOUlIdjr3S3pFs9cOQpcbWFLmBjc+6umMkgqza6J/qW/vMMicIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736413005; c=relaxed/simple;
	bh=rvQdr7+nNF4GWigDhwHSpL7uf63bNNWxCGk4EBhGdUs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=joIzykLBzkwZuh+LsyTEQDDUbtjKHx7iznYfpG0WcaIDiYL0bwoUr5cKkoiEVhIYr5H63GYobnKsjv1ZsXjpt1M/Gm3rhWxLJbdFZkvlc/Ye973qqB9TnSXvjHhPRyHdNTyNrzYjkzBZTpQ/99LF9KlXmJzi80GEu+lWTNl11Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGGN72PV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGGN72PV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DD4C4CED2;
	Thu,  9 Jan 2025 08:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736413005;
	bh=rvQdr7+nNF4GWigDhwHSpL7uf63bNNWxCGk4EBhGdUs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=GGGN72PVU/YKdIiNAS9SYVzxtbll+bQ1CQmwKJsL15ChLjFuTu+QtwqqavLFOxp4t
	 BdJIrTuejTg1PYwZZv6z6QRWWuEW+OEVgKpc5UpZ9634l4MLpPqSsopDG6C9u41ug5
	 m0LQWJbX3Hjf7h6em+Pty4fOcauBth2HsNRCj7heHlgh7LyxgCmzSAhF5/O2S3EpOu
	 jcIuGE+gOYcuDkMQZR8DRDu8pnygEYFFh5x4+SNEElQfBMzjcsAkrUM9u4SsqRVLr6
	 tzNtVRWDtGYUfvumQh+sxrL/6u9LbcBld4/aYzDjZ1wop6+7fWiMV9IIyIa59IKTAU
	 ygH51ircuocwQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 Brian Foster <bfoster@redhat.com>
In-Reply-To: <20241217042737.1755365-1-hch@lst.de>
References: <20241217042737.1755365-1-hch@lst.de>
Subject: Re: [PATCH] xfs: don't return an error from
 xfs_update_last_rtgroup_size for !XFS_RT
Message-Id: <173641300377.275835.10463744885740061113.b4-ty@kernel.org>
Date: Thu, 09 Jan 2025 09:56:43 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 17 Dec 2024 05:27:35 +0100, Christoph Hellwig wrote:
> Non-rtg file systems have a fake RT group even if they do not have a RT
> device, and thus an rgcount of 1.  Ensure xfs_update_last_rtgroup_size
> doesn't fail when called for !XFS_RT to handle this case.
> 
> 

Applied to next-rc, thanks!

[1/1] xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT
      commit: 7ca96c6c5e80fbf23c5629127ef17dac5011bef8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

