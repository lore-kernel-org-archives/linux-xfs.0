Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FA633F9
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147711; cv=none; b=OkkVD9u69LVLx9qCGi0shDpXogNI+MdR1Pe2HouWL5bBy9cVZE4F4iYjN8fgCb9LPxloMth+JF2PzSZD6KjHyvq8OzCqODbTCcmJrVVgfn1Zicd9PTrkLHPjdMc/1ettFz51679rOYGrPhKDQKzmpX/cYiRnB+YrW0Z0PatZjrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147711; c=relaxed/simple;
	bh=0rSNrx+G53cJwXs5q+6SOCtp5DcgXeuGgvj+HTGrGXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G90c2wNVW3vF3sYcWENJ49kc+FtL+zGmbZaeFxZOVYJewA4VntLp09hyrhZ0P8jVk4FU8RH/wcdTLckb1S/6sfcGNy+Jka1W+F8wDnewuDu9dH+KPeqIomP6qmY+DO75Z6CcYxqpLNn8FB7WPsMqGdpVF7EWo9E+0n/3WAEVZGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OY+fjlJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OY+fjlJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D35BC4CECD;
	Thu, 21 Nov 2024 00:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147711;
	bh=0rSNrx+G53cJwXs5q+6SOCtp5DcgXeuGgvj+HTGrGXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OY+fjlJ7wkV52i3AtCwPLr+DGznKcLmzjLPM8DjKvkUgqD1DSnTLPd0Xadsxr7k7m
	 ygJRjrfFFQvGyURaZWhJ8KxrfXWCnv3edydYYuXui/YfzxMvfPRpI8ZiitiAvIB6BS
	 R4JndQ2vaWjRG2SMnsvwM/6oTIkCvd7gXZNZiG9id559bplNobsVDRrOqzxiBSFZ+Y
	 sImij4pkqxxb2JkKUH5vh61Jd04fxGE0oaF3BtHrPsikNVFQmnu3HY0ppKR0r50XRz
	 0fDpkFJNtByF3PeG/CkUTyfcQz8M8/U5UKz/iV2LJEG/f5RsMFLkpeDX/qmh/XdWc4
	 gHqDuE7DMn5tQ==
Date: Wed, 20 Nov 2024 16:08:30 -0800
Subject: [PATCHSET 1/2] libxfs: new code for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, chizhiling@kylinos.cn, dchinner@redhat.com,
 linux-xfs@vger.kernel.org
Message-ID: <173214768449.2957437.8329676911721535813.stgit@frogsfrogsfrogs>
In-Reply-To: <20241121000705.GE9438@frogsfrogsfrogs>
References: <20241121000705.GE9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

New code for 6.12.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.12
---
Commits in this patchset:
 * xfs: Reduce unnecessary searches when searching for the best extents
---
 libxfs/xfs_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

