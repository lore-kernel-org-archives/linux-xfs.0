Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D77E1EEA4E
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 08:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746433338; cv=none; b=BmByovM83XmTZ8IEIvUlexjgZGPRzQKg2WeedHUI/RJ3aKxxcKkQWgOnergdHc2tHs13mLe/4siqi8xIzqUCjUd+GKcGySgMF/rJDJrwAJ1pUNyhSiQ60K8UkTP2Zchd078G3TgTSv31NFYZLPco5oRYKAe21rzgfvKXJ6qIStM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746433338; c=relaxed/simple;
	bh=+Qc7RXBPQjsLqndGToXUAAKhRBxbbfTdUdG+MSvSsLM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eRR+z6fEpZDL0shTmO41JrcUp0szRh5S5tMHkfaaQP/TeVZFmHdYVi4upQmQ7A+dcEz+9yDQoCX1kerDyxtvk9zkIUL05fETCW9qbU5hdpFUMCIXhTytFXbksTYZnA95UAeF1oZ5XWqlau+CelkGOACExBGx/YIpCWIECmMFc0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxQr+eR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxQr+eR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E970C4CEEF
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 08:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746433336;
	bh=+Qc7RXBPQjsLqndGToXUAAKhRBxbbfTdUdG+MSvSsLM=;
	h=Date:From:To:Subject:From;
	b=MxQr+eR8uh8roYQPHMnxNc4qk8LWX5aE+E4khdDKNTEzJJ/IgEwSgQRzKXoa7ZSO8
	 eBDTuMe6KFAoQ+YjF9kkLVUj2vU3zM4ZTG8SdAlPj/AdPVVw603rUG8j9BeWWcshGY
	 NkISy9W4H3mjBj+s7Oqvqf/qpz9U4vihtvA0rIXQdedyQCkjWiuvXGbiDQAsI9I1Dh
	 XwKRc29WSn6Su9jxGx0VE8yyLO1NuPC/4OWr5pvsFXNOepaTpt6cF3TQt5QKF1Mg+I
	 k4Ui5jaV7ObIHjtKXU4RpQH4OhRgCQELppcV9kGwYn8XMkgqvf54/WnAw9EIiX2kga
	 351sri1T6CXLQ==
Date: Mon, 5 May 2025 10:22:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: next-rc updated to 23be716b1c4f
Message-ID: <uo7x7ryimrioypcef475ycyzkjjcbrzebkfqalbhlpirbh64kd@b57r5uzjpd46>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The next-rc branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the next-rc branch is commit:

23be716b1c4f xfs: don't assume perags are initialised when trimming AGs

1 new commit:

Dave Chinner (1):
      [23be716b1c4f] xfs: don't assume perags are initialised when trimming AGs

Code Diffstat:

 fs/xfs/xfs_discard.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)
