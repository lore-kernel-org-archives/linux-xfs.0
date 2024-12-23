Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2247462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994149; cv=none; b=o8ajSMIoxzzyObJgQZhhfA2N+4ZeFuvjX7rH2djCokJdMqI9v5PkRaESzc8F3GFVhAuSOfdSdBtwyC5Mf2zk4EZsGS87TlUi9kf15XmKxNAy4J/XTUo27cDGRRh1Gi+I3MJEexxd4dtx296H/xDqR4hsW/M2NidsrmlRPAMjTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994149; c=relaxed/simple;
	bh=3ZMmJakVPv7I9Y58ZbfOmPkVh4899kSpC2Mce87DDzw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EwQHpm8pSvJD90E/OEPcNBH6ThVbtCk0W+qBh2W8oHRfDLrkHSGINWDIm+YytFFZtRWXKv2xknRinOk5dtzocdI2eabhVcmfwq2eCsRjmeCB5g35KMnKhTRRb3wYahEhuDtnmoeq1AjFSqTuu4LsALttXwnKoHKoIABMSySZDgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhfFQrjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhfFQrjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C8DC4CED3;
	Mon, 23 Dec 2024 22:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994147;
	bh=3ZMmJakVPv7I9Y58ZbfOmPkVh4899kSpC2Mce87DDzw=;
	h=Date:From:To:Cc:Subject:From;
	b=RhfFQrjM4x8EhhzmGLflr10GfS554dD95P+VQNzC8Mx9hmR3j2u8mA1iGdyU3qzC1
	 1cta4EtRhgGnNmieJ8cLcMJA3d/7kcJxgph37s45dZJjLGluY/57Ve2R1oou8Ylt7g
	 Ni3nNI4t134Weeh+cfuVfJnIhWxhvNtPNJHcPC5sXs1ijIepyJK4VducjLvaW5x5N4
	 GSnNozGKzil5YoLf0mDnPkpZgzGlEUknj6oavRlNeHk3cR99nQIXYRW+iJLF6iaKxm
	 iERZ2ktnOqmbDmou/6KRcwpbqKMmIToD2MjboLoL/+YQw912SDkzwdq5qQDqc72e0f
	 p8Q9uNekF2xpg==
Date: Mon, 23 Dec 2024 14:49:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB for-6.14 v6.2] xfs: realtime rmap and reflink
Message-ID: <20241223224906.GS6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Reviews have completed for the code that adds reverse mapping and
reflink to the realtime device.  With these changes, the realtime volume
finally reaches feature parity with the data device!  This is the base
for building more functionality into xfs, such as the zoned storage
support that Christoph posted last week.  Since we're now past 6.13-rc4,
I seek to have these patches merged for 6.14, after spending eight years
on development.

Since patchbomb v6.1 I've added Christoph's review tags, and folded in
the documentation updates requested during review.

The first patchset are bug fixes for 6.13.  Could these be merged asap?

The second and third patchsets are all cleanups and refactoring so that
we can fully support having btrees rooted in an inode's data fork.  This
is necessary because the generic btree code only supports using the
immediate area as an internal tree node -- conversion from extents to
bmbt format only happens when there are too many leaf records to fit in
the immediate area.  Therefore, we need to remodel it to support storing
records in the immediate area.  We also need to be able to reserve space
for future btree expansion, so the second patchset enables tracking
per-inode reservations from the free space.

The fourth patchset ports reverse mapping btree to the realtime device,
which mainly consists of constructing a btree in an inode, linking the
inode into the metadata directory tree, and updating the log items to
handle rt rmap update log intent items.

The fifth patchset ports the refcount btree, block sharing, and copy on
write to the realtime device.

Please have a look at the git tree links for code changes:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink_2024-12-23
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink_2024-12-23
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink_2024-12-19

(fstests is still behind because I haven't rebased atop the parallel
fstests work)

--D
