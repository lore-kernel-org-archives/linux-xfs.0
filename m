Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F9236606E
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 09:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772704009; cv=none; b=R6gvIrgD3Yq8d7UemtRFxsvW5gLdzif+HfrK+pfZ7xIjgc0UxXoJsc/Ah5x1yZTdY8zW0ZnFqSNrAi3IRPFkjWiNoSN5ruuPxCHzOCR0udXquYfdF6n45YSgHF6JqCuwQd1PeXbByyUaO0ztF97HIhfqIWSBvKWDQ3ut8igH5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772704009; c=relaxed/simple;
	bh=gnKJ3BRB+cMNcK+P2RHpXo1cWrNiAbTC7WRgKyLDd0A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kQcZsHRkrok3e0wS/ytq3yujC649rLoeW15g/lRVd4IEAPf5wvzf9k3DhiujBhm7VAu+WqLQmnIVytfmursrZ3zkikopClOew0hzAFJukKH0TjnK+FuSkxJPw6kh6frU95Qf8PwF0lkC3QixBBl/ExGqjKA7EBtebeVE/+JY+3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODN+sotB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODN+sotB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0A4C116C6;
	Thu,  5 Mar 2026 09:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772704008;
	bh=gnKJ3BRB+cMNcK+P2RHpXo1cWrNiAbTC7WRgKyLDd0A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ODN+sotBRHo2eAmy6BYErioQB74oKd4jCMqNUvusfC3BI1q2HXUikOYclzDMygmpe
	 OSFUMDiEfxHqMbYNbdZ0ESbQN7eodk7ZVXnFlLIKlwqgcafnsZIhhyLxUZRru6jest
	 sZId9M6gLX+dZnsbSFBW152WwdXf4Xq5l7d2rvX+yzRE03vpTqsmQRm7HZaZl0leo9
	 kmTiJkgnoBINtfwKEZXNDMGatrM4qMFBvmOmcLguOFLPicEiFhxc0hYcQRBS0nWNtF
	 o69mW3p4PiZ209XSghYQJJcbZ/pt8p/n2E+dgFkVWHwN8zVHtbZLDySsk8ocXHxRaz
	 SbNWDaqPZbvjQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, cem@kernel.org
Cc: djwong@kernel.org
In-Reply-To: <20260304185441.449664-1-cem@kernel.org>
References: <20260304185441.449664-1-cem@kernel.org>
Subject: Re: [PATCH] xfs: fix returned valued from xfs_defer_can_append
Message-Id: <177270400795.16146.2707385414257667646.b4-ty@kernel.org>
Date: Thu, 05 Mar 2026 10:46:47 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 04 Mar 2026 19:54:27 +0100, cem@kernel.org wrote:
> xfs_defer_can_append returns a bool, it shouldn't be returning
> a NULL.
> 
> Found by code inspection.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix returned valued from xfs_defer_can_append
      commit: 625f2cf0ed12953313970a80c7d501e9150251a9

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

