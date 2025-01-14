Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5342229612;
	Tue, 14 Jan 2025 10:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850690; cv=none; b=EZ5hz5NjPxZW46TGt7n2kZSCEcNDAyVXaGMtTjsCcdPqZ2uwSIWuuOfXPjHidjdZcLy12Q8yA/fIpxCN6AP8KHnnX62+8TZTfZi6m6n7SRht4lKzQO9cC2LSbFhM6A6dKtkWPOMYbOcS1i8zhscYnGT12kOuI4M1gyP4TlaE1G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850690; c=relaxed/simple;
	bh=rNzQZypTsyusD8CJ2pCBLR3RPZndXC97KiZPYQD/X0A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hgz/HnvrK6dRHdaj21ExszjGxnsdcNsuOBm+TNvt0FrgW5MNFigPra7YL+odNCrxWj95ijEO+rVjslKSGzzmFZk3dTTHJrFmPgXVRpw7o5pXzPCjDqWQyIYGdNKbdbWtwzt5MC0IkTYm2MbWdcHPtYeVpeQOdW+e3Rrx5dRosSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9lTq4C+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9lTq4C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB61C4CEE0;
	Tue, 14 Jan 2025 10:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850690;
	bh=rNzQZypTsyusD8CJ2pCBLR3RPZndXC97KiZPYQD/X0A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Q9lTq4C+0IfMCJBqg+mujDEkoeztUs24EGRlunvZVmYQvVFDcF3eUewU0TYlaY+6K
	 5OijzFzgahp/g0D8NQcjV9jOdUgaa99rihIkeu6PvGoI5ycEKA7qHyUnN8CbDL8FVh
	 ON16aPGBpeynW/RiT1OXsx0yLe/mHGq51b4orpmpyEjmh8YWoncXfnr+I6Jp3jawwe
	 GctvfDi3lSPjnFaTcWKEijzOCvKAJSYCQZbberb1Lrg+30y+fQNMOfUTqrDrhRKwq5
	 ayXv4ga2YaP3lhq1egEn0vb1w9OVv8L/Lpsjzbu6yA5S42PE9VMFIfORC8l9/zF+7m
	 QgXcdWhsqC8lA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: eflorac@intellique.com, hch@lst.de, linux-xfs@vger.kernel.org, 
 stable@vger.kernel.org, 
 syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
In-Reply-To: <173499428661.2382820.13397448738755922887.stg-ugh@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
 <173499428661.2382820.13397448738755922887.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 1/5] xfs: bug fixes for 6.13
Message-Id: <173685068877.121396.11076782312035206563.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:31:28 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 23 Dec 2024 15:17:44 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 4f13f0a3fc6ad193e4d144a5e001b7b8f1fc4b7f

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

