Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDF747B41C
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780582183; cv=none; b=fCJBbqbh+pCDEr11SimZ0EsvC2vnR0mEYmAU4yb/C9qO8ZD3L2A0B7XC6BdM6E2TX5FN+V/4PA7NChBRamvfjrblqNxoKN3jpHAYl9AfvXOiqf2akCIhUbQbgA2VfKSp9j9cwl4NEVweTMgNNJD7xyC92/DNncjfrzKpNnnJk2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780582183; c=relaxed/simple;
	bh=2PxuZKAMSBEHaa5ZvA/Lb776AJqixlyIFH8fxcsqPEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e81PtSjvzTW1NgBZDIWAc5g0/C5o6U1Ern+jVPo0cmJXqzfpT+p62DO5S1SwjtSy2gD3jrTPd4tx4sfQ1oMwaLi0WtFuzV5g0XHnff4CsiiAhdGQ8COJ4nhxPmwflsyS0II4iufq7O0RtxpwuTelYaW2tBH+rP+kE6ls8iy24yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZLe4Cgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZLe4Cgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F381F00898;
	Thu,  4 Jun 2026 14:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780582182;
	bh=raZrEwtWy8zj5IhyMsw2eZo0eKtjsgySuf3iLKPq1GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jZLe4CgjbuQRO92AYfvQasalAG9Q2i/RewdbUiaxPWr8tfzWE1M8cKduePJ+cjFsH
	 1fg1VJI7PI24M7hnyuRrldKTHLDzuwMMRKCfSj3LGmD0690ZRYOc9QPLIIWPqqzzgl
	 8K6WP87QmYtEJxqFjhjltcRWaTCNY9js017B+gFfIgyCEwYTl+oQmMx3jq2KbGVu7M
	 cunPV8JHEJPSQVHwrUrStmZUoiThj5/5D0BlD9oLQirV7ml2Koqyy3oo/hZ30viuRj
	 4QlcnX8JY64JyklYo27nKIPjwYeU9857CDtmbGhJ7yt6lYXw56cDWjAcg06JdYzVwK
	 LLQ+M9dz6jIUg==
Date: Thu, 4 Jun 2026 16:09:39 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 14/21] xfs_scrub: reset bulkstat pointer on retry
Message-ID: <aiGHEEq0D9IdIleN@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303365.2608728.13882189590028658191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303365.2608728.13882189590028658191.stgit@frogsfrogsfrogs>

On 2026-06-03 23:07:58, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that we don't reset the struct bulkstat array pointer
> if we decide to re-issue the inumbers and bulkstat calls.  Fix that, and
> fix the @error variable being returned uninitialized if hdr.ocount is
> zero.
> 
> Cc: <linux-xfs@vger.kernel.org> # v5.18.0
> Fixes: 9f4d6358e28ba1 ("xfs_scrub: don't revisit scanned inodes when reprocessing a stale inode")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
