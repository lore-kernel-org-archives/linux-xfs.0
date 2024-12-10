Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5FA1AA1DB;
	Tue, 10 Dec 2024 14:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733839799; cv=none; b=Am6vRlnHgBBYGPoLGCjZnKQ0DWUb4q0CnZcxSMVJ7QVIIDn5WDGONJ5ODhiQOuRe/BYU7NJNwyv7J8NNaSUAVJa9i7NAI6KgvwySzJMpsrEVVju5YXg6Yr1Lj7eI2YUEE4zjsfMHYdhBwrTZKMm/Pr1SP0Qm2VIdkWifo6mByb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733839799; c=relaxed/simple;
	bh=E4FalgpJ6T3uaU5hYDLLsw3EH8E5IiWUltoqmgMX3OU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y33b97dBpOr8tITL/tTCyv7OunlafK3quNYeXkFV827PnXScrbueXmV7HJHkKFvzqETt0XVpS6FjFuYB8U9PLGyGb22bxEdmNm8I3AwpZDrl4LbWJjL1T+IMPkDGV5hW1J4zRfvFDI+ddEyOc2a6sugkXEfPes83S2DV0AdIpdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+LUX28B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+LUX28B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47036C4CED6;
	Tue, 10 Dec 2024 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733839798;
	bh=E4FalgpJ6T3uaU5hYDLLsw3EH8E5IiWUltoqmgMX3OU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=S+LUX28BT/lhKKHGuArTgYA6c1q0x0uTGme6/VZuML/+NpOX20U+xxyenVndffGKR
	 Cf3WhEBggXIB4QDOXycKq1OUmLLHnUT6yEgIGItN63ub1nk6h0QxW2d3suebHRJbAA
	 bXUQzffkohpbSFPsGuIIrT6OyUSg43LygI8nEsVHPLWntVqlEc174H9a+jBCAde9+q
	 8f5MrkYdrUWQgbVglbPbrpxZGPjaSXgDnr0q0/g9gheOr2XVCcdUgLkMaKKzqFwxkc
	 YGr4M4K1DQ9WpYo6QchyJ6ijwttSNtnZKHKF30k7X9i7Gh4bWI9hD/+EmRoawrXV+n
	 vy6URZT31/JPA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: dan.carpenter@linaro.org, hch@lst.de, linux-xfs@vger.kernel.org, 
 stable@vger.kernel.org, wozizhi@huawei.com
In-Reply-To: <173328206660.1159971.4540485910402305562.stg-ugh@frogsfrogsfrogs>
References: <173328206660.1159971.4540485910402305562.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.13
Message-Id: <173383979692.593876.11310599824299852830.b4-ty@kernel.org>
Date: Tue, 10 Dec 2024 15:09:56 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Tue, 03 Dec 2024 19:23:19 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs against 6.13-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 3c171ea60082eb4e90a54988eef86fa2a4d1ac58

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

