Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812B5216438
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 21:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843921; cv=none; b=MFkokQ0wb3NULPOD6zKzfgZvwenrthyfPqDxZoP6GPju22YOeZT8xssuEgk9j+mc8j8vQ3X/ntgk3UKWH9RyiTgaT2boa5NA60qWmwNPs163togGtIAxJqRx4qe2Lcl5EdmtgcN/lHGEIw1zMmyAvOz3AdVm9QNIj9QEg1StSkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843921; c=relaxed/simple;
	bh=tdTwPJlAbU2tcJKkfqdGpmVGmswL29V4qEkeP0teL+I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OWL7hLinQQ4fV4LfhOJz9K2vrB4PelCWmEnxnACAlm6mDHPB1693pgckAixSE9slbcRJlrnm3HAQ2n3yWXHyBW164GEXqDLJOGMMLhjS02ku5y6yBpvNlPhRFqFtP7/ndtBJVTal5LAromqKpPtzJwOcdeZKus5qgKpgS2lbUA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bcMFCQ66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bcMFCQ66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2079CC4CECF;
	Tue,  5 Nov 2024 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730843921;
	bh=tdTwPJlAbU2tcJKkfqdGpmVGmswL29V4qEkeP0teL+I=;
	h=Date:From:To:Cc:Subject:From;
	b=bcMFCQ66YuETB0AcRleGXVFA1LS3Oc3vTey/oYH65hS3EsvUf6g5ceVOgCjs69pFV
	 Ev2UPBuLc/3dVCZ8zxB7RdU+Ud1g0IBMawR/P/V2p4TlV3yBZX0yxZQI7y/Fm7Wmz4
	 qzRXpWHhCtIenOBxcr9BJ2D67txcy3ZWOxQAj0OKvAF7/yDFDQ6w/n3TSaJ4uKGw0C
	 n40iNBPpJG8BCLVxCuc7tsESA5W8SOvrHH5p5RT4wSurpWzY7m/cpu8tEWKBEb0oMY
	 qvRhOx+NLJydyu9awMwgFlfFWrUkMR0eYu3WTPeBzkMg5vcH+65JlDdUdqy57v0oUo
	 1rgqFgPEDMgIA==
Date: Tue, 5 Nov 2024 13:58:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB 6.13 v5.5] xfs: metadata directories and realtime groups
Message-ID: <20241105215840.GK2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph and I have been working on getting the long-delayed metadata
directory tree patchset into mergeable shape, and now that it's fully
reviewed, I want to push it for 6.13.  Changes since 17 Oct include
dealing with merge conflicts, adding some more tags, using the new
experimental warning code for pnfs, fixing a refcounting bug, fixing
some quota flag handling bugs, and porting xfs/122 to the kernel.

I am sending the kernel patches one more time for posterity; pull
requests will follow immediately after.

--

The metadata directory tree sets us up for much more flexible metadata
within an XFS filesystem.  Instead of rooting inodes in the superblock
which has very limited space, we instead create a directory tree that
can contain arbitrary numbers of metadata files.

Having done that, we can now shard the realtime volume into multiple
allocation groups, much as we do with AGs for the data device.  However,
the realtime volume has a fun twist -- each rtgroup gets its own space
metadata files, and for that we need a metadata directory tree.
Note that we also implement busy free(d) extent tracking, which means
that we can do discards asynchronously.

Metadata directory trees and realtime groups also enable us to complete
the realtime modernization project, which will add reverse mapping
btrees, reflink, quota support, and zoned storage support for rt
volumes.

Finally, quota inodes now live in the metadata directory tree, which is
a pretty simple conversion.  However, we added yet another new feature,
which is that xfs will now remember the quota accounting and enforcement
state across unmounts.  You can still tweak them via mount options, but
not specifying any is no longer interpreted the same as 'noquota'.
Quotas for the realtime are now supported.

Please have a look at the git tree links for code changes:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/tag/?h=metadir_2024-11-05
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/tag/?h=metadir_2024-11-05
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tag/?h=realtime-quotas_2024-11-05

--D

