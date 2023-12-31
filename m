Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E18F58;
	Sun, 31 Dec 2023 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQIm0HgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19855C433C8;
	Sun, 31 Dec 2023 18:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704047154;
	bh=QwW8hn90gcAPdwvISI50BNnLmRAm+x613Da3GnHfS8I=;
	h=Date:From:To:Subject:From;
	b=gQIm0HgK3lyG2SYyC7eEu64MF7kslOlpje6BcYZSHHCSzxhpPYvCL868nlrTZvjWr
	 63Wv8uzr1mYQmX7XMWW3++gipEUpzHJdn7Od9+AYbZS3ATKjAJ4B8M78CS2oJa/RvJ
	 qbBDIrWp5xhJsKEkX50m5AHTErAPF9jmj3JZJPqN8J2bITcw7B5OvNlLtbDwofxDco
	 d8G1Xl2kmuZO9Re9l45gevqz01PH7Xfjo6E6eQ7Y3aSNmkp0WxEMw8e5h2IiRtkqVH
	 sY35cd8R998t7RH7k7bZumD4MzpL3KzwbhvAVVJ13EC8dOF1yXYV7u/F4Up1WYS0VI
	 A+vHEfwXs1mIA==
Date: Sun, 31 Dec 2023 10:25:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [NYE PATCHRIVER 4/4] xfs: freespace defrag for online shrink
Message-ID: <20231231182553.GV361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This fourth patchriver has two faces -- one way of looking at it is that
it is random odds and ends at the tail of my development tree.  A second
interpretation is that it is necessary pieces for defragmenting free
space, which is a precursor for online shrink of XFS filesystems.

The kernel side isn't that exciting -- we export refcounting information
for space extents, and add a new fallocate mode for mapping exact
portions of free filesystem space into a file.

Userspace is where things get interesting!  The free space defragmenter
is an iterative algorithm that assigns free space to a dummy file, and
then uses the GETFSMAP and GETFSREFCOUNTS information to target file
space extents in order of decreasing share counts.  Once an extent has
been targeted, it uses reflinking to freeze the space, copies it
elsewhere, and uses FIDEDUPERANGE to remap existing file data until the
dummy file is the sole owner of the targetted space.  If metadata are
involved, the defrag utility invokes online repair to rebuild the
metadata somewhere else.

Since last year, I've also merged in Dave's xfs_spaceman code to move
inodes.  I've not had much time to play with it otherwise.

When the defragmenter finishes, all the free space has been isolated to
the dummy file, which can be unlinked and closed if defragmentation was
the goal; or it could be passed to a shrinkfs operation.

--D
