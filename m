Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E704DB547;
	Fri, 16 Oct 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166439; cv=none; b=eoeD3iWTfWmD9EQx3Ne1rY5fn/E28mTK0iObme5/uBf2g//uG1v7vziFLXULYyAbZdzwO8/qgqEmYIBRQAO7Up6yUd5zTLJHl9gdobvACCb0vPkjO3sLO3CCuIlTIt+DO2KFq7cIMRPAVG46Rse135agPHL0lH9oW+vUTs1KEEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166439; c=relaxed/simple;
	bh=wZWwAubiLeVzLQOEG3jpJGsWjZL6wE6Slmjn3p+wtD0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tVg5lYyK55WGYbiBQ9kY7vKnQ63qGduX8Hk3FGZOJoFTvT1GKCb0E4MzOarJxa1yU8hnTyeREo4QmkHs/iY5IQLZ/eZRm01R/Wb8hv3wiS6VHzVjtBo5Na9oYi5UcuOa7CfD330q7xMIKl7eihvY3HdyN48UX1i592tzZJPvXqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PB3fwH9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PB3fwH9a"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4EA461F000C5;
	Fri, 16 Oct 2026 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792166438;
	bh=DPPtWJThkR1HSDGyZJb+uhlwde5r6SG1m/oIZY7KoAQ=;
	h=Date:From:To:Subject;
	b=PB3fwH9ad/RdxiI88KTVVyHt/5Qwa7WFh6uIqGh3S7bkddp7ETFj57SmN6Ag597p5
	 9HTL3LBL4VJhisD5y/b8wfkfgg/syv10xSEx9Cdeb+AkpV7nuKMbYnJZEK8MWW73lG
	 SGyHK1sdoy92vPvBJrn5kDMfWQAPYIzqa2+HHPhVnxXzFLwR/Qis6uiiDNFa0IctA6
	 s7WqTB/ps18gHS6gKUwsQWkJvs9yEUAZA7c67ozjVI55kQWL8s1jhJ7PpXUR1gI6mm
	 sPzTVvbDKNszOEwaN9py1n4wX+qeO+z0rx2pKkz3f7mAGQjih7Py0SPj6DI9kQX92z
	 sz1OGa6AQVDew==
Date: Fri, 16 Oct 2026 09:00:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>,
	fstests <fstests@vger.kernel.org>
Subject: Farewell!
Message-ID: <20261016160037.GA107919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

After 14 years at Oracle and 23 years working on Linux, I've decided to
take an extended break.  Today, October 16th, 2026, is my last day.

I don't have any immediate plans to drop the djwong@kernel.org
forwarding, though ultimately that's up to the sysadmins to decide.

I have very much enjoyed working with you all, and I'm proud of what
we've accomplished together.  Good luck!

--Darrick
