Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3138F57;
	Sun, 31 Dec 2023 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSZI1xiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899F1C433C8;
	Sun, 31 Dec 2023 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704046729;
	bh=da9F+lcbCWF7pAvHK75nYhALGS262yVa7ak24pe6ttI=;
	h=Date:From:To:Cc:Subject:From;
	b=YSZI1xiPwBZs74AOijCzbgjkjspmsdIDvBV9t2kiz6bLRAJs0sZVmTQ5zB4nsltkY
	 9XzCIBbyfNJ+WFdE2pIdvI9t22JOtq8AeQfM+rxwvokdP8rrcyqZqs4jSgZdwMJL0J
	 1BESLikUdvgZo/jbWAu34JIE7fgwjKvk+rOlOr1/rYz2mlbNE/UXviTcTFPOt4k+A8
	 6rjMuf96gX12Y4h/YPG0peIGsNKLhpOVHZv6616ZmWNx42bGkgyoPhRFRWVOB9+zVx
	 w2YBjuFzNHJyr9dOzgi6R/r/O6LjI1eaOJV2d8hby2Ys1cbtBAKKH7QWMfaymBaPiY
	 IK7joX3akwNQg==
Date: Sun, 31 Dec 2023 10:18:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanrlinux@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, greg.marsden@oracle.com,
	shirley.ma@oracle.com, konrad.wilk@oracle.com,
	Matthew Wilcox <willy@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests <fstests@vger.kernel.org>, Zorro Lang <zlang@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [NYE PATCHRIVER 2/4] xfs: online repair part 2
Message-ID: <20231231181849.GT361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This is part 2 of online repair.  This river combines the directory
parent pointer work that I took over from Allison after she departed
with a bunch of new online repair functionality that enables rebuilding
of directory trees and correction of problems with the tree structure.

As a consequence, this river needs closer review than the previous
river.  I've changed the ondisk format of the parent pointers to make it
easier to correct the directory structure, but that required some
alterations to the attr log intent items to support looking up xattrs by
name and value.

AFAICT this part is stable enough for review-- I've been running a few
testvm host systems with parent pointers enabled for about 6 months, and
haven't noticed any problems.  With this part added, there's a dramatic
drop in the number of uncorrectable directory fields reported by the
fuzz test suite.

--D
