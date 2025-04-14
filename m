Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8A25A2DE
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 08:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744618181; cv=none; b=rWK2aNOphhUnQ+PpAg3CG+hsYfF5KxaZmbiaAttd08J1xggLVnoUz1nH/hMndLojiMiaU1u1FSZ3wiZcrJmtfjGih+v3TqFgANNlUCDwXwZc7i6sBUEeO1SMbEXjTBpouZrqH8Txp7QfdkdD1sct40jZIm91fFYxDNnSTi2b1xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744618181; c=relaxed/simple;
	bh=t0/aqAVbVu3z56HZ49/ZcHl5PvFh4z/prM+/o2sDeHE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cT1mW9odMet737Fq8xdGxkVHNKul0w+OFNDo+ogc/q7r51yq8cfHrYbscyJGM6XMFPudUz9OyJ0C7vqpgkBIYxJti/bB7LBlqDFIYwO4QImuo09HdrsONrvpWtHB09KK6X+jY3DSWRMB2YgVGzK0pvGa/C4Y6WtFqFEeM1z/fNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFR696y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFR696y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53816C4CEEA
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 08:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744618180;
	bh=t0/aqAVbVu3z56HZ49/ZcHl5PvFh4z/prM+/o2sDeHE=;
	h=Date:From:To:Subject:From;
	b=KFR696y+6iDmzFvmq2yWAzQ/fd0fcuAjR67mG8HB9LHxOwr0xXLdMqsEnYq8EY1+8
	 /qTYwScjRqmwzxesG8jY3MZ37TiinLrZZT2Gd2EM7NPYakRsrR4EqdASF+S9MDgDRq
	 Zx+txACHmR5epse2uIkID6reScgbppkNlSllq+J7bnvzUU4uYxquG6EiBV/xwPal+9
	 0WK5nQ90yTA3y5Lmu3swReXZTzeuHcX1Tj0d2Cg/yT6dHPcxqlrInwrKEDBDlnmSL3
	 zNZ5i3nsLW2MAKJ3Jb21vDVshutMIvzYdL5O0xPZIPU76GAA3ElHUkMjl+VjbRmCSR
	 vvdiuneIR2TyQ==
Date: Mon, 14 Apr 2025 10:09:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8ffd015db85f
Message-ID: <4lamjqbl3j6cdrbt6phn6pa37cb6nl66jrug5pgocavtfe5bqm@siff4derbwtt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Giving a suggestion to avoid unnecessary merging, this update resets
the for-next tree to new Linux head (6.15-rc2) to be used as the base
for the current xfs development cycle.
Hopefully all patches sent to the list properly reviewed, should be
enqueued during this week.

The new head of the for-next branch is commit:

8ffd015db85f Linux 6.15-rc2

-- 
Carlos

