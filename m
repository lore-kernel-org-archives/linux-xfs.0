Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C45481B5
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395438; cv=none; b=u30yfkRKZfS7EJw1qZzLBlczeKkn/vN9ZyGbFapaVk0iIgvHYPlmNjKISjdZ+mhIFsV5+d5t+uI9Kd91+vXQyJWCmYAa/almENC/1++xMUDubh9Cp5Y5u84drd1rA+aXdsEBOXHxkKFllAk2I4y/ybmWmwF21JJaNG26NWFphac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395438; c=relaxed/simple;
	bh=9XgrBq4jBXOOHW2ID4mMKFXSgD29eRgtkWN2H4Qzk50=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FAxABtE5dnbt4MOvKXDXSSXjGSTL2iyoeEQj0jFvW1cN92eYVcNqHRr1IZyTb9+VJuu/WDiMfF6qMFWYueSe7pZKhjOQJnTrmm7kOmTecKd8jxEfCnaSpwKnjz9Chz8aivq3f9Z6qtE22vcNKk5MbQtQd73NV47ysP03nf28oDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAX3I7r7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAX3I7r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1349C072AA;
	Wed, 17 Apr 2024 23:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395437;
	bh=9XgrBq4jBXOOHW2ID4mMKFXSgD29eRgtkWN2H4Qzk50=;
	h=Date:From:To:Cc:Subject:From;
	b=ZAX3I7r7I0i/yXKXCzeOLoGlCmFyqGLoD76bxURckDFHjeDYpr/YqOx9oML63PKut
	 LyBm5jiNje6+KHui+a+i0rixBFLw16svw+q5nPRu3p10G+T3dM+bIGyP2ZdfFuZy7I
	 s1WAe51Ticvnz+Z43NJqwVI1ehGhxNsSqiE623/kMegLE2AH3zh7Q91GFncuE6jlxK
	 hezcbuTz+XnM4+z/Pn0CVO0D4Aw6k31W5qO6qwsUDyO3PeB5IV9Ba55qCgGpe2ookw
	 f+s5keZDQuiXAKV1YdD2Wgf108F8d2T0nmveZyXR/nJqo4QGWl1FMGea3zHFEGnx/7
	 dJBSaO7Yqy0sg==
Date: Wed, 17 Apr 2024 16:10:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCHBOMB v13.3] xfs: tweaks and fixes to online repair, part 2
Message-ID: <20240417231037.GD11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

As most of you are aware, any large body of code naturally attracts
bugs.  This online repair patchbomb tries to address a few things that I
noticed during the review of parent pointers v13.2 -- we're working the
inode cache recycler harder than we need to, there were some bugs in the
code that unlocks on failure, and we need to be a bit more aggressive
about invalidating dentries when moving files to the lost+found.

There's also a cleanup to remove the code that used to turn on
exchange-range dynamically since it's now a permanent feature, which
means that we bail out of repair on unsupported filesystems earlier.

Finally, there's a speed optimization for the vectorized scrub path that
has us iget the file being scrubbed and hold it across all the scrub
vectors so that we amortize the overhead of untrusted iget lookups
especially if reclaim is being aggressive with the icache.

These are the last few pieces of part 2 of online repair.

Full versions are here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fixes
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes

--D
