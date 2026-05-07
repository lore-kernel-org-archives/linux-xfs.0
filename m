Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522B2372B28;
	Thu,  7 May 2026 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145662; cv=none; b=Bw1PGhk9gihuBhFxUxZGFSvL1he9Vz+VM2dZ3E9bT80Zt5+/gQxgDjwZaKj0ql2xa5Xm6IZsS2SqHJqaYbZlEwXkjEln+k3KXCf8pL4W2FIgHARvJW5QpMETlQiDaL0Y02vuoZIQ+xi2RrAVd8KasW2YRyDUOVWFVW1f2dTirxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145662; c=relaxed/simple;
	bh=hBsAO8fnpvcErMUsuWE1R6rz+u7E+mxjWysxYV7xGy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYz17rOlCgVHhHA4BrKHu5j2yZP4gZ0MsFRVPJtbcSfozqJoe5YYkBSAsjbeJQIdUNhkjHOAZ2l7ZOGQC/XmvoaI/POZQes8aLFrrAt1NihAh9L1rzR9S7gFq/bfb1JkfyTRL9tHyhs3ebFZt518CVPQZ1vr+owkcq4AHd+Zz3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f58gOThE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f58gOThE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90B1C2BCB8;
	Thu,  7 May 2026 09:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778145660;
	bh=hBsAO8fnpvcErMUsuWE1R6rz+u7E+mxjWysxYV7xGy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f58gOThE4kky1cywgV70xthRVl7sJkCSSmTZqy7Bhr2LO9ADbzLAki84HvumgY4mf
	 TRfz1WyTA6tWELe6lhqAiKVkFFN8aV2iS1AkU6yCgCTj5IYc/Nhp8PSESqT1j6+ZOy
	 bOJVjW9TcoXmbCJSpUdTNWqS/q0NcKAl6evWB6hGC/1F+O3eG00FZqNk+kl8F2kYGY
	 q9pQLj5aCP4EdRaQuixHn3xnbzflzeD6uTw+cqp2NEO7upaacRlkriWGz5LPgx4NXm
	 6i0jSKsfiTmLXY+PSXpt/TYoui38m3g1s4+KiynFToUu13NXTAY4yjPR2dKN5zRBzB
	 g2PkqBuLb2JjQ==
Date: Thu, 7 May 2026 11:20:56 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/216: pass -t xfs to _mount
Message-ID: <76ufvvhb7jn7dtrrctm7aodiqdqlefvinobkbd33fz255aszwi@awbpr6dknvrs>
References: <20260507050950.1300316-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507050950.1300316-1-hch@lst.de>

On 2026-05-07 07:09:49, Christoph Hellwig wrote:
> Without this, mount probes different file system type, which ended up
> exposing kernel bugs in blocksize > PAGE_SIZE bugs in tons of
> legacy file systems.  Bypass that by forcing XFS and making the
> mount a little more efficient.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
