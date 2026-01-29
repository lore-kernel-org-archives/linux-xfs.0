Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE226CE39;
	Thu, 29 Jan 2026 11:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686341; cv=none; b=soLOoVB2trDT9ZpnzcNLS2YwvXqMPBPuwqjGGyZyEbk3WDj2dw2bTNGg6JZLH+D/kDbielSitWk6G6YJrVTNlFyrr4QeeJGP+YMA1PDasn/j1GJd/juawMsrgVeHT1dkZ943vfkmgqViAgBYPX4ijedXgshXckXsNnhABf61c3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686341; c=relaxed/simple;
	bh=U5YCHF13s1O/p4HcuZD12/tWExDEHg3mKjyVQmAL+NY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uLD5dSaS60XKFRxUTHvfg8b1/aVstHD1g5294lzu5SVhMo9zy1rqhALQtws2RZCQBPkUc4BdTmMB6SPBleoBKPdndf8xGOgpG748wiBlKIpNW73jjGYs0cfhRz2GY24EI87/14cElMzWTKcFNIdemVXZ+C/9np6Ei3I2+wDhb4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgn2JxEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgn2JxEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA985C4CEF7;
	Thu, 29 Jan 2026 11:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769686340;
	bh=U5YCHF13s1O/p4HcuZD12/tWExDEHg3mKjyVQmAL+NY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mgn2JxEEkm2vMGxPAy702RNh0mVGlaLa4xBcnTbbJuUe0Pr8O3SK5JdLiJx0VCA2E
	 roWE5xP9fCTAgZsSiUuw4aaE1P1u/+a2h7gVeNmeKpLLIftfTtVUH/dfDSLokSqKYD
	 A8Iak2mwQurtDimKBb1MHtWHXTMbQ2eHirOFz3oFYLu/4SG+azNNvufbKdQmsTmXSC
	 vxB3JmzgoqUA9rqcBwfK/kiya5hWuhcr9+YVNOWrRKaAs3WpoutNY6bHv3ciUmFDDo
	 KNmL6jaIqkHxsQq4O/jp57YHheAaRH7iFYYt+DfFQGeU0Upt1mI3EfCm130CNuhDwy
	 l7YnSxutz6tyA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, r772577952@gmail.com, 
 stable@vger.kernel.org
In-Reply-To: <176939848276.2856414.2422046318877467815.stg-ugh@frogsfrogsfrogs>
References: <176939848276.2856414.2422046318877467815.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 4/4] xfs: syzbot fixes for online fsck
Message-Id: <176968633865.19342.13279126021268988131.b4-ty@kernel.org>
Date: Thu, 29 Jan 2026 12:32:18 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Sun, 25 Jan 2026 23:22:28 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs for 7.0-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 692243cac63195ba38512a86bdb47b9c3190716b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

