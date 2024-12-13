Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B7779F5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051195; cv=none; b=MUn8vQ1fGuiTlfIkQdu1YKjYX3u2UYvzlizh1S9Yt2+NlZaT0X8dT/dhqr8iGfXTcIajbX+X4HUCO7JpWNAYDtTarZCeAAUIrwz1UwSwNTC0JOqZIHl2A4w6SfF6eT84C0ct7YX7UEKvNj+YszJU7Up4Kx6nmq1KPN2jsTC5+mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051195; c=relaxed/simple;
	bh=hsm//ZTaFz6yl15Apfv6kakIjb0krEoqDi18sLerEFE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rO0ddTRWQ/3qyD/hyru1MN6QYlV4CrtM9iQ9Y7enwMYHDlyLhb7IXMIilZ873c8T2d2pCSZdQePXR67ocMfBmYyk3lUJoLNUphtKfXlphfVtmiXmy42l2YN9nW9DRMMpeQ+qJNpUHZq729BT3MtNZHFiDYDagjipKzbdcuQR2gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLQspjYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLQspjYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69B5C4CECE;
	Fri, 13 Dec 2024 00:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051194;
	bh=hsm//ZTaFz6yl15Apfv6kakIjb0krEoqDi18sLerEFE=;
	h=Date:From:To:Cc:Subject:From;
	b=KLQspjYYCLZd/6DYwJYntL604xWJG6Et6E6cbeYIblTCUcKe/9UiyLS2Lc+y0GSj4
	 3/d/fdP7IzcvDeSe2c8QY0QK6cHtJDaTwQT+7wf/RMG7Eao1Ib35xE9gDeg9DVrlWY
	 FiLjci+ygF3Ut/oq/hWMaBpFwsYABTDyFlLwP52a0ufFw281VVRgsg72qTLYKNNpSN
	 3L5zHN1xq+yqEHmnDnLX3ucvtRoEgCERxlUA6gimpqRws23jA4sPqJmHKfqt1xA+D2
	 t8aQGvQl7Uqa9SlNGsWRFfMVjQLhKYC5bHS1FnDv0Lo6fQ1sLGqxKnDklZOd0MRk5L
	 aRWonXrorM6tA==
Date: Thu, 12 Dec 2024 16:53:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB 6.14 v6.0] xfs: realtime rmap and reflink
Message-ID: <20241213005314.GJ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph and I have been working on getting the long-delayed port of
reverse mapping and reflink to the realtime device into mergeable shape.
With these changes, the realtime volume finally reaches feature parity
with the data device.  This is the base for building more functionality
into xfs, such as the zoned storage support that Christoph posted the
other day.

The first couple of patchsets are all cleanups and refactoring so that
we can fully support having btrees rooted in an inode's data fork.  This
is necessary because the generic btree code only supports using the
immediate area as an internal tree node -- conversion from extents to
bmbt format only happens when there are too many leaf records to fit in
the immediate area.  Therefore, we need to remodel it to support storing
records in the immediate area.  We also need to be able to reserve
space for future btree expansion, so the second patchset enables
tracking per-inode reservations from the free space.

The third patchset ports reverse mapping btree to the realtime device,
which mainly consists of constructing a btree in an inode, linking the
inode into the metadata directory tree, and updating the log items to
handle rt rmap update log intent items.

The fourth patchset ports the refcount btree, block sharing, and copy on
write to the realtime device.

The fifth and final patchset is still RFC status -- it enables reflink
and out of place COW writes when the rt extent size is larger than a
single fsblock.  This part is sketchy -- I want to avoid needing to
change a lot of the bmap code to handle the case where an rt extent's
worth of logical file blocks map to multiple rt extents, so I mandated
that sharing and COW must happen on rt extent boundaries.  To make this
happen I had to fiddle around with the generic remap functions and
writeback control so that we always dirty an entire rt extent's worth of
pages, and we always try to schedule writeback in units of rt extents.
I suspect this might be racy.  We might be better off never picking up
support for non-power-of-two rt extent sizes with reflink; or never
adding support for rtextsize > 1 at all.

Please have a look at the git tree links for code changes:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize_2024-12-12
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize_2024-12-12
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize_2024-12-03

(fstests is behind because I haven't rebased atop the parallel fstests
work)

--D
