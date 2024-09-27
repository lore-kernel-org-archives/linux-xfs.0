Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208611C1ABE;
	Fri, 27 Sep 2024 18:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462740; cv=none; b=m5xrhxy1zxMfYIuDC2cPPvjWifmh84Uv9zCwc15Oh/FJNr6/aUJR4vNp2skrDfY1+u1x7M8wqu1EwrRsxvbpoHgTVRxeaq6900PsqL+ayvpCDsSEcqlL6X9G9yni0aY/4FLNQSyyy8JZ44Q99+T37AEXaPMXneoltF6xXexW50g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462740; c=relaxed/simple;
	bh=uE8mZid6AM9SjAKFwfUA7F5bA9Qbgqo/SlQasxBOdOM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=W8DERRzeZfFjZuaL4DIs+TLYtDgZmhni8tfoeMvzFkeqRz9gg/p7OtPi6EA6jn84Qh/wLedvrfFDxviTCtG08pvyBLmNUbh+g7gUEAMIr5Dpkryg3wiciz1hnF8ffhnMGjnDTNuscsvjIMDnfW4pwTgCibfVFYedBjRkVosCv6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrThnMmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrThnMmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48946C4CEC4;
	Fri, 27 Sep 2024 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727462739;
	bh=uE8mZid6AM9SjAKFwfUA7F5bA9Qbgqo/SlQasxBOdOM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=BrThnMmYww28L53PSyMbF4iSw9DrjcFESjd9//+HSxwdGSelKCYqTb+w3vdoJZBLt
	 g0bwHcq+Bmrqcb7NUKPysikLFTXea+wCZgrBqm4Xu1ougruAQij4oxrCRXL0z+8Jg7
	 T1arRrO64Zln33P192ZOkm7ZPr5CJ0OkzkLtq52NkfRKC1riV8Z58SBrtCNaOTU0m/
	 ocb2yOQE2oVyNkYwWZ20p2OctjfdP8AmlYaMzhgvJKZDHWqAWm4y3kOMve1HJC2ZiT
	 HDRbTmj4+ic5740nIvsMrPM8spM//FMJl4Zn6RZcd+cL2Y4r+uFNCNVUQQHC4ENxkZ
	 CZzf5mdfXJmIw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Uros Bizjak <ubizjak@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
 Chandan Babu R <chandan.babu@oracle.com>, 
 "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20240923122311.914319-1-ubizjak@gmail.com>
References: <20240923122311.914319-1-ubizjak@gmail.com>
Subject: Re: [PATCH v3] xfs: Use try_cmpxchg() in
 xlog_cil_insert_pcp_aggregate()
Message-Id: <172746273791.131348.18071682105497639956.b4-ty@kernel.org>
Date: Fri, 27 Sep 2024 20:45:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1

On Mon, 23 Sep 2024 14:22:17 +0200, Uros Bizjak wrote:
> Use !try_cmpxchg instead of cmpxchg (*ptr, old, new) != old in
> xlog_cil_insert_pcp_aggregate().  x86 CMPXCHG instruction returns
> success in ZF flag, so this change saves a compare after cmpxchg.
> 
> Also, try_cmpxchg implicitly assigns old *ptr value to "old" when
> cmpxchg fails. There is no need to re-read the value in the loop.
> 
> [...]

Applied to xfs-6.12-rc2, thanks!

[1/1] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
      commit: 6e19fd40d755a64f271687a21cd304ecba41a571

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

