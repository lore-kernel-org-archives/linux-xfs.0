Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FDF33971F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998204; cv=none; b=soSAznxI2B7iC2jmYMdxV6xb57zjrGqXLp0nTnGHpwvZRd21caIcZmgi3wdkdURB3tuvysf6qv4FWgzC4ak0bs/YzI1xwfkIVuyqsDiob9J/ydWf1Iz+YBx8mkEb7PKfZFcN9vgf88AsL2H3hS0e+ITFIFk+D8GkLQe5LxbjMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998204; c=relaxed/simple;
	bh=QRSl5Zb5NADjH2ijyLS6aIlSTkx07S5YLRj8OOzd3os=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lPplpO7HFhjiuHkC5B54mPJvnm7IgiRNRmBW6PcQ0EUbrl7iYEzjykOZMXC89icNRCK0A6SfoCrS63t57XcW9pMKHPSp2HBaeBxXvc3jLh9in6vziW41UdUXKpcID9tTzzvKBKLnEbnuIuNmFPKw8e87I+U8Pm1tdBGVIVFIwWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acVUeiDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acVUeiDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D270EC116D0;
	Wed, 21 Jan 2026 12:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998202;
	bh=QRSl5Zb5NADjH2ijyLS6aIlSTkx07S5YLRj8OOzd3os=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=acVUeiDgPVjOewOJvI1FI5v+icSGVwooLjSQS76wiGVxRdA3QunFZxqGEXEWClAOL
	 lkQcpRbi3qe/FV61hGdapB+T7NAswtS3zmer2nKIC5ztFnThTjVwVBY8aC6l5BH631
	 eOop/YeX5XuWmma5opCF9b7eoGqTYRrAqqHmcsWvpYULp/8o2hojOh1hgn9pTBHXw3
	 9uMAVdlYc4qRuSOdFx7U6wRtOLkTTxrYDlslQ6f5meHdVOp+E3ZF2/FhkNFee9o8qW
	 wNxN+7tMKbbXFUZwbQJt6XIir9wEforb+9WS06Cw3XedUA3yg4/6EjUrl+0ofC/ZjC
	 ZerrLDz2AEr1g==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260121064540.GA5945@frogsfrogsfrogs>
References: <20260121064540.GA5945@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: promote metadata directories and large block
 support
Message-Id: <176899820156.852684.15749463510034523694.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:23:21 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 20 Jan 2026 22:45:40 -0800, Darrick J. Wong wrote:
> Large block support was merged upstream in 6.12 (Dec 2024) and metadata
> directories was merged in 6.13 (Jan 2025).  We've not received any
> serious complaints about the ondisk formats of these two features in the
> past year, so let's remove the experimental warnings.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: promote metadata directories and large block support
      commit: 4d6d335ea9558a7dc0c5044886440d7223596235

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

