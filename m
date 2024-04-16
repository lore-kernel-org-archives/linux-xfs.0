Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB99710A22
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287514; cv=none; b=OAOvhkwzbxjlLPtAJ1vXL14opcc5DxyjnpkJY5Qrh9JGQWPk8aKtQXjTK4C9HHrmzro/RyBycqkwkBSxlrxilEwZ8d/2hc/c4NojKvbuku99a4/Cxe8eq1NGVR/Wf7Sogl13L38JQMgI2vqHFImxkXRXQLE/I3uvjQfGQrHPp+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287514; c=relaxed/simple;
	bh=ixysQoDBHqmajO66MF1seZLN2Mwv5zGDFjeCsgGjLLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkngHDK72TN5VoAtscQZN7y2U6KpLaeaUuaYLwy1MCobQizOro8kF0YRXb7ilO6/6r/I6s1MCUpgkilFgeDkpa/+9eqgKpFSLWWWwDlvuk1M7Tuqk338c4tNZ0/Tr948OdJT2zBkP5yPdiUmNx3UzN9HLpmmcCgny8QadBZ/Lso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYGPxIIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYGPxIIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E029C113CE;
	Tue, 16 Apr 2024 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713287514;
	bh=ixysQoDBHqmajO66MF1seZLN2Mwv5zGDFjeCsgGjLLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oYGPxIImC/h+9vMAsn4QomGQeJNrENNjm8PwynAm86pcrIIp97739Ek8JW+u4nhTP
	 AaMyPpVN6uDrLlMvGzy6GV7yG5SpEWkAdxuUCcNnc80NGhmdff/iCdSjm0Z2r1LmmY
	 OIoVb/Ujm/DcCiexIrcX95LMQqmhrDnqHl0xXy3Y9hVIVasNNudSomxxKkMgvMPVA2
	 AcszdEufq8H9BHtKfafMuEgYXxdPJi8vfKxgT/W9kKlXP28FofylwNlbuQPOVtVaW6
	 tZ+grH/qbqzJArxHI7TYDMYkauw4x2lUrC3kv4o29eKkShuWC673+QBvWxOeAc4pND
	 yjpFA8MBKWCug==
Date: Tue, 16 Apr 2024 10:11:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] bring back RT delalloc support
Message-ID: <20240416171153.GR11948@frogsfrogsfrogs>
References: <Zgv_B07xhnE-pl6x@infradead.org>
 <877cgz3rmt.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zh0CHF5Fl3mqaSvV@infradead.org>
 <87a5lta2kt.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zh6njnD-b9v7TPV8@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh6njnD-b9v7TPV8@infradead.org>

On Tue, Apr 16, 2024 at 09:30:06AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 06:23:26PM +0530, Chandan Babu R wrote:
> > Christoph, I have pulled in many patches for v6.10-rc1 and am now encountering
> > merge conflicts with your "spring cleaning for xfs_extent_busy_clear"
> > patchset.
> 
> That shouldn't really conflict with this series.  It's also not anywhere
> near as important.
> 
> > Hence, please hold on until I update for-next branch. You could
> > rebase both the patchesets once the for-next branch is updated.
> 
> Ok.  And I'll give up on the pull requests as they seem to cause more
> trouble than they are useful.

The trick with that (or so I've found) is either to send reams of
patches for the release manager to integrate manually (ala the old way)
or to load up all your branches one after the other and send pull
requests for all of them at once.  Mixing the two leads to frustration.

--D
