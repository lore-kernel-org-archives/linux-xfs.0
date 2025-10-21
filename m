Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6886E31329A
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039460; cv=none; b=Y5zYVI2iIGKCe8rId8tMWK3CHDLlakeBhQngj6wsGIHsyJqL+rNt3A5tcA1PUdIshyj0OQFbOGnOTke01+TUoFLKwz61tITBIKjPH0JK/JqmbX5jivKUhngrFt8YWrVhF4guGbpx+YdEb3ykyI+iboZYqzBtg5orvSRVwCBfue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039460; c=relaxed/simple;
	bh=7WdlW9v0O8clrGARrOMHaLKZS63Jkb/TN4d5qa1QvxQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SUkh7DwsHRAdlB/wD4ml3lkgLseq9CH3hbeozlRMwoILPYIFwJoRMR73Eis7o4bAhrBM7pfnzDEKRfAK4tWMII4OCkXeWZM89fJacTjGXCaukr8LcYAKHH93W8nrSlwg2+uxPkitX89J/TggwYj2SP55XA4wySkWg2RAdjzofF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjh31u9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjh31u9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F10C4CEF5;
	Tue, 21 Oct 2025 09:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039460;
	bh=7WdlW9v0O8clrGARrOMHaLKZS63Jkb/TN4d5qa1QvxQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=kjh31u9H5Dh3WJgTP0ySCsYa8d/oy2v6uZmdviFi4IEdlyv2X1tuZeavJv2NG+RXG
	 2B7NqsdE35X3VQQFGg7iTjNEXSvhDj3M6rb8HU1NzVvs77EuACe1eNDmeTIN/tatrm
	 4fYcb52sA9uK8DyrqT2v6RgQy2uTETRxh5hEzsXko3MkcAHKQ5HLy3uXrFckAiLYkf
	 XUvkJdrR1GtMjYKANBr+of4yO7ghV4j/nPnxoXQkcWYDhMQFDmrSlrKSpny3/bgPuW
	 OetaR6KavEueEJ58hs45eeye1/mqefiqokR77H41jAcN2VkK8ALxaRnNUQJV+BIaGW
	 CRgSLEfiZ+n6w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: darrick.wong@oracle.com, raven@themaw.net, linux-xfs@vger.kernel.org, 
 syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com, 
 "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20251003101307.2524661-1-hch@lst.de>
References: <20251003101307.2524661-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context
Message-Id: <176103945823.16579.13860309705802801608.b4-ty@kernel.org>
Date: Tue, 21 Oct 2025 11:37:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 03 Oct 2025 12:12:48 +0200, Christoph Hellwig wrote:
> With enough debug options enabled, struct xfs_mount is larger
> than 4k and thus NOFAIL allocations won't work for it.
> 
> xfs_init_fs_context is early in the mount process, and if we really
> are out of memory there we'd better give up ASAP anyway.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context
      commit: 0f41997b1b2b769b73415512d2afaae80630e4fe

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

