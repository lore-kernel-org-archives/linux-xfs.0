Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B250F13B29B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 21:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721857133; cv=none; b=oY1Wm4+WE90u0WA6hoG0VXShIRj7/dyYAtOFcHROfRL5XpbaaNkTdHh2v8EfPfE1FTsNip7P6Z2J+65juLJbwfgJl8obVtGx8Mogrig+WAk9x04K6/3jtLVI2f6jjq5b6knQjmumHV4aS5fPlK1IJrYDpPhfcY/Ou7toUCPyKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721857133; c=relaxed/simple;
	bh=BoEbDnBBUXLkFUExzR4zCvdXc8CBJIvHVn6kA69Y6c4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fHVaaJqRd7lJSWAB/6yfkOLIydF2bG3NumRHlgG6vl/Gy7a8XRDiEt70Yy4lLeccxTBG3DnCVFORrmiWj2YXnTKSvAudmQWQ2AiqZWW7YrZihJMPqGQX2FnxhpVXG03c5z65G/OQyFk33lbRvQ/0qZI8jIsX7q6HgVGYE6sWfWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X07puTaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X07puTaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B13BC32781;
	Wed, 24 Jul 2024 21:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721857133;
	bh=BoEbDnBBUXLkFUExzR4zCvdXc8CBJIvHVn6kA69Y6c4=;
	h=Date:From:To:Cc:Subject:From;
	b=X07puTaq4kB9VIKV5Jl9uv2OfI7e18OC5bAMBG+306J4fbPjYEbNcns4UBfOqv/kw
	 qZnFuy3qEaAmaTV9vhdHlfKY7BAcnIShWnES7wfQHWFT2BDg9IT4iRFiB+6iwCLGA1
	 /d8K2CGdYUuqg7Escd31IsDQ8sW4fCrvRBJyi24bIJRvAakV7eR3nqampf124HCLOq
	 acmrumrSZ65SajqR9I9Bdo0APHHu5sfMZRrW0+TyotfeJ91LVnI3DvLPO8u5Lq62sy
	 f875gj1u/2gxYn9TnVcUb6Fwq7Xu1n+S8D36oXJcdWrNkFUqnvCtuggP6veALyOtl2
	 Y1yRr+oF4dogg==
Date: Wed, 24 Jul 2024 14:38:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [RFC] xfs: opting in or out of online repair
Message-ID: <20240724213852.GA612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Over in this thread:
https://lore.kernel.org/linux-xfs/20240724131825.GA12250@lst.de/

I originally proposed turning on background xfs_scrub by default in
Debian.  Christoph wondered if it was such a good idea to unleash this
upon hoards of debian sid users, considering that the introduction of
e2scrub by default didn't go entirely smoothly.  Debian policy is to
enable packaged services at installation time, which is reasonable for
httpd but perhaps not so much for experimental services.

I proposed modifying xfsprogs so that for Debian builds, it would spit
out a separate "xfsprogs-self-healing" package containing only the files
needed to activate the background scrub services by default.  People
would have to opt-in to installing it... insofar as one can configure
apt to pull in Suggests: and Recommends: packages.

Christoph suggested adding a compat flag to the superblock so that
sysadmins can mark filesystems for (or against) background online
repair.  Therefore, I'm proposing adding such a flag.  Before I start
any work on that, I thought I'd sketch out what I'd add to make that
happen:

On Disk Format Changes
======================

Add a new COMPAT flag XFS_SB_FEAT_COMPAT_SELF_HEALING.  If set,
the background xfs_scrub_all service can periodically scan the
filesystem and initiate repairs.  If not set, then background repairs
are not allowed.

Note that administrator-initated scans (e.g. invoking xfs_scrub from the
CLI) would not be blocked by this flag.

Question: Should this compat flag control background scrubs as well?

Userspace ABI Changes
=====================

The first thing is adding a new CLI option to mkfs.xfs to set the value
of the flag:

# mkfs.xfs -m self_healing=1

Question: If rmap and parent pointers are turned on, should we turn on
self healing by default?

Question: If self healing is turned on, should we turn on rmap and
parent pointers as well?

For xfs_scrub_all, we'd need a way to query the status of the self
healing bit; this could be snuck into the xfs geometry ioctl as a new
feature bit XFS_FSOP_GEOM_FLAGS_SELF_HEALING.

# xfs_info /dev/sdf
meta-data=/dev/sdf     isize=512    agcount=1, agsize=268435455 blks
         =             sectsz=512   attr=2, projid32bit=1
         =             crc=1        finobt=1, sparse=1, rmapbt=1
         =             reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =             exchange=0   metadir=0 self_healing=1
data     =             bsize=4096   blocks=5192704, imaxpct=25
         =             sunit=0      swidth=0 blks
naming   =version 2    bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log bsize=4096   blocks=16384, version=2
         =             sectsz=512   sunit=0 blks, lazy-count=1
realtime =none         extsz=4096   blocks=0, rtextents=0
         =             rgcount=0    rgsize=0 extents

I think we also want to enable sysadmins to change this on the fly.
For mounted filesystems, this could be done through an administrative
ioctl or mount options.  Offline, this would become another xfs_admin
command.

# xfs_spaceman -c 'self_healing on' /usr
# xfs_spaceman -c 'self_healing off' /tmp/extraspace

# xfs_admin --self-healing=on /dev/sda1
# xfs_admin --self-healing=off /dev/sda2

# mount /dev/sda2 /mnt -o self_healing

Thoughts?  Flames?

--D
