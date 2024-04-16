Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6428C28E6
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713272184; cv=none; b=hOUA9jtXAqjHFxk12wS/JQuhsRc6Ql9Cab9OLdna8BLgBBrxLQRaaAu6Kw3XAHNpZaJQJJROJSJWulfQmh9fRZ30qp1ocQvWjzJRwcCHC/mvJE+Y4NWZYp9MFOmBu/MbL2IeVok1XyFQfYXlb8WvxlheknBiBzfvDui3wGzOtFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713272184; c=relaxed/simple;
	bh=zXnirLwD4M4i7B24IhYOnqQduA23qSppAag3UMw7XUU=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=X/kv3V5tv49CnjUZmo6bXen3ZiH6yoHRcfqmJAGEVFWVj86WP9TTLmSO0LtQL3uHNzY3z5V70CsttzyKm0ZiD8oVt09lFmjLNtoM6Pi3A0FXfuO9cBbxGGSY09n7DzAw2/0q76hq+RoKwW1RRHCa2007krOGYlWp8jKWhqiThzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s55TUmrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s55TUmrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F41C113CE;
	Tue, 16 Apr 2024 12:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713272184;
	bh=zXnirLwD4M4i7B24IhYOnqQduA23qSppAag3UMw7XUU=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=s55TUmrPwu3qFyraY7R8TMTZOytJTw2+jYgveGWrhtqSVgVzP0uhxbgtOA5ivCUuq
	 3i1ImcO+1cOEFnu5cKAvlkWGvmdiywn+hzS4wuHj9+XZ/Q0Isn7F7mHM34jhcIPMla
	 F0sGhBsyrHUmwGNDLVMl4MzRd0yEzxH/T/QBlj5lEO7J4FfNLbmDc8tbB4/0zas+Nr
	 IsZukFfxECQc41N7JhdWvrEQ/CQ0q7j9OpS8cjQ8oGYAIVA6UEWqcPUw0fiZPYFADn
	 QHsIGSTX0THmoDZ3dZijiUZD5IGL8ASwDL97+lozlVnPPUnKUVHdvv3JwauWVqkRoO
	 6aven75OZCDTQ==
References: <Zgv_B07xhnE-pl6x@infradead.org>
 <877cgz3rmt.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zh0CHF5Fl3mqaSvV@infradead.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] bring back RT delalloc support
Date: Tue, 16 Apr 2024 18:23:26 +0530
In-reply-to: <Zh0CHF5Fl3mqaSvV@infradead.org>
Message-ID: <87a5lta2kt.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


On Mon, Apr 15, 2024 at 03:31:56 AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 02:11:16PM +0530, Chandan Babu R wrote:
>>
>> . Also, could you please rebase your patches on top of v6.9-rc4? I
>> start applying patches for the next merge window on top of x.y-rc4.
>
> Sure.

Christoph, I have pulled in many patches for v6.10-rc1 and am now encountering
merge conflicts with your "spring cleaning for xfs_extent_busy_clear"
patchset. Hence, please hold on until I update for-next branch. You could
rebase both the patchesets once the for-next branch is updated.

-- 
Chandan
