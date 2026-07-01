Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D85480DEA;
	Wed,  1 Jul 2026 12:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910220; cv=none; b=a1PYycTE3LQ0NSHx2VCaoRuKWVSsz+rlni/KgCIOgDCOIlf3eZY7azxOS3jNoK0CAGRxCuKnIaNp/1NFgsY1WGhLlelwzArQbqpfvfRtuF+oH5M6+j2NGvjwhvLSuXOAcCvyziP1sYdWEgm9Im9NCz5Kq4iNJvQvFxZXJIFdtXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910220; c=relaxed/simple;
	bh=8wIVvknSPultBsQ9tJ4WO+6FP9KWHIH7MQRmHOPnf6I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gfqgvfdND7PhX6nmpyMa70IMOyagi5IYtyyevLA6oI/WBaEB+7t4wAymWdPFws6T1F1Y+aKJxRytlC8xq2wUNaTXsDy+oPtyezK7ul0qtwQkkwLK7GHxX52ZRrVD9EOXs9Sb6BS2a+IGbVKJOmmgz/XIe9glB75tPo2sNGzaXTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mK8ou+Gb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mK8ou+Gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4B81F00A3D;
	Wed,  1 Jul 2026 12:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782910219;
	bh=/oAYLi/n7bO/TRVxKEyYF80A6IbBWdjvkJKQyKaePFI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mK8ou+GbXeclsT6qNpQTZ6Ct3fzrpdIE8m4hx2zz9ETobsEjazvuB3I2mmTBgor8j
	 4dmV07iox1SATGGh1VsYMA9gyW+VIM6CAbplTlJw4hc4VNBjb1wOzZ0Vy+4P344jGm
	 guVdFC2c0pLkuU7h0gXM7eaTtsnuUeXGYQeHVUHJQ/w0ne9Rql2yvr2WotUrnMdtrx
	 BjyhS50rpyDcC4Cor7y1VgCLvKFKHHw71X8RDnvXVckRYRMewC+Jhqwqc3lAw2Q5D9
	 rd8yZsRMrVc+VUxL9SqAXBsbGp/J8JE0+6wJSNiqBbB3yClrO1MQZ9VhNIC9LdwcNx
	 ST9trK2NPQiPg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, 
 Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260625131623.3261735-1-gaoyingjie@uniontech.com>
References: <20260625131623.3261735-1-gaoyingjie@uniontech.com>
Subject: Re: [PATCH] xfs: release dquot buffer after dqflush failure
Message-Id: <178291021819.353898.10550193282677454885.b4-ty@b4>
Date: Wed, 01 Jul 2026 14:50:18 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Thu, 25 Jun 2026 21:16:23 +0800, Yingjie Gao wrote:
> xfs_qm_dqpurge() gets a locked buffer from xfs_dquot_use_attached_buf().
> If xfs_qm_dqflush() fails, the error path skips xfs_buf_relse() and then
> calls xfs_dquot_detach_buf(), which tries to lock the same buffer again.
> 
> Release the buffer after xfs_qm_dqflush() returns so the error path drops
> the caller hold and unlocks the buffer before the dquot is detached,
> matching the other dqflush callers.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: release dquot buffer after dqflush failure
      commit: 0c1b3a823a22af623d55f225fe2ac7e8b9052821

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

