Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572672FC23
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 09:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600325; cv=none; b=mOfU00fqOH8XjZVSzyFYBJVpGqewoM+zTCKWsZFq5pwbBZmeHeVeFD4ISpVip+pNqLFWl2ACqowSPy+6eCityZ7L0p/dglN/JzN6oU3KdW1/EUd2M8SUGnua5pD2WOLhoSzOtknQo/pQ5m8pk4wBJJ77YAKpSzrxjxuFFvDnEfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600325; c=relaxed/simple;
	bh=vald3C31XzlLFkrQvLP40gX+LsbTdAYkIcInIpN9Ps8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uIm18hNt5Gz7N51IarxD7vtMb2nKeQAcaxcUGusX80OlDi19akWioJEQ6NKFhGgBI2jhtiAjniPNZdxMNvqBmNN5HRR5a/eRZn+Yq9yteWI+iYXPmdCy847iVg3VhRtsKCzBmnMoD3SsiQIUqWffWqylX6mgcVsST8SxDWyMenA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oynKMyII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oynKMyII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C36C4CEEC;
	Mon, 10 Mar 2025 09:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741600324;
	bh=vald3C31XzlLFkrQvLP40gX+LsbTdAYkIcInIpN9Ps8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=oynKMyIIPUq7p2JpJ9v9//tNDtb4EVqu+/zXqihaP2XQfvvqi4DXIOjHR6SnGbp5C
	 pA8KE2BnlZPb98qrlNpO7081xGFHeZE7dWEs318UkKUJmyTSS4h91Foo+yEq3/qTpu
	 tubV+cE2euAmY/IKMEojdSAxPj0WHLnPgJdg2Qv2qPSVo/Nd2Las5xq4TCLEdMt4P7
	 haW+1qVNDWyUF/XAc9cTVY8MKuJTRtt22b5NOPSqwn1NMzUL5KNcyYnfQpHo61UOV4
	 Jv++5Gd1xcxHHbqJgoYLE5Qt4VI6tbmlqmA0SOzU1ItOCfXOowTRF6NSL/tn8n25/S
	 DeUDszI8K59hQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250303180234.3305018-1-willy@infradead.org>
References: <20250303180234.3305018-1-willy@infradead.org>
Subject: Re: [PATCH] xfs: Use abs_diff instead of XFS_ABSDIFF
Message-Id: <174160032377.193222.907140219242116744.b4-ty@kernel.org>
Date: Mon, 10 Mar 2025 10:52:03 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 03 Mar 2025 18:02:32 +0000, Matthew Wilcox (Oracle) wrote:
> We have a central definition for this function since 2023, used by
> a number of different parts of the kernel.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Use abs_diff instead of XFS_ABSDIFF
      commit: 5d138b6fb4da63b46981bca744f8f262d2524281

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

