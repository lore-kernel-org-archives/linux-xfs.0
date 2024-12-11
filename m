Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1741E9B2A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907400; cv=none; b=K7Xjvs/3rHIZllbxN1BimpZ1jbUGyPjnX/8t2IXS004N7a9OhubBdiO4lxUF88SQDW3YN7HsNBg7Tz2SzrUGtligkZeYDpXItV1ahVc6CxXIz+U1zJmxKjM3Kj8DLuad8vuXHwB3GKN2DutCs0hN5IsbzA0Kp8kUFTokODfYKao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907400; c=relaxed/simple;
	bh=zSJr/xxx1M4xtE8hfWZZVVT3gqnPj0xmlK9HMP3Dd3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DNvUDpoBMBaLCLsGkgLjy5vyCW/Cr9ywQGLmQSq8T1QiEUbNMOM4xFcDS/BvOE4CYQ0pFKQrW4W56UIagbngQYze0prBoBVeicTQDDsvouGnJIDIVcPwtfCroNHzrE8P287SGq9wAJy5uV3R1Fx/P4EdTyIami9fHeb20lBEPNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zo+ZPfVr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zo+ZPfVr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Z7k+9ghSIIEcMuBA8i71iG6mCZF85pfrYU/30PI22mg=; b=zo+ZPfVrC4ZC1GeeDgdV03H2nt
	rPxOadXrJXwhX8u3m2AEpmEyQ1ho7Ey9JYwwtL/gZCSCLSUvcqFSwwSYHYqkOxmAiSPYP/0rl8itx
	J1T606L/Dl7lU93gp5p80BgE+l/JcPw0FWAIYx5xAJABZKZZaZnKZMS4glD65Rd1P/wJP0AdfzKt3
	Gy3ZQf/Ytx3KpJJefKEAhoNR3fnAdpnv2/VX968/Q4jjw1jm3SA02IO3WGjlkd0q592OdqySn0eN2
	6se4LY9yDAr6kksYDAJAtjOv/48eslN9Wio39RRm/dPCE1hRr2RNFtwkZk5mnjtMlPI0kb5JOpwu1
	8fnoXmFw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWM-0000000EIxt-1uGs;
	Wed, 11 Dec 2024 08:56:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: RFC: support for zoned devices
Date: Wed, 11 Dec 2024 09:54:25 +0100
Message-ID: <20241211085636.1380516-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds support for zoned devices:

    https://zonedstorage.io/docs/introduction/zoned-storage

to XFS. It has been developed for and tested on both SMR hard drives,
which are the oldest and most common class of zoned devices:

   https://zonedstorage.io/docs/introduction/smr

and ZNS SSDs:

   https://zonedstorage.io/docs/introduction/zns

It has not been tested with zoned UFS devices, as their current capacity
points and performance characteristics aren't too interesting for XFS
use cases (but never say never).

Sequential write only zones are only supported for data using a new
allocator for the RT device, which maps each zone to a rtgroup which
is written sequentially.  All metadata and (for now) the log require
using randomly writable space. This means a realtime device is required
to support zoned storage, but for the common case of SMR hard drives
that contain random writable zones and sequential write required zones
on the same block device, the concept of an internal RT device is added
which means using XFS on a SMR HDD is as simple as:

$ mkfs.xfs /dev/sda
$ mount /dev/sda /mnt

When using NVMe ZNS SSDs that do not support conventional zones, the
traditional multi-device RT configuration is required.  E.g. for an
SSD with a conventional namespace 1 and a zoned namespace 2:

$ mkfs.xfs /dev/nvme0n1 -o rtdev=/dev/nvme0n2
$ mount -o rtdev=/dev/nvme0n2 /dev/nvme0n1 /mnt

The zoned allocator can also be used on conventional block devices, or
on conventional zones (e.g. when using an SMR HDD as the external RT
device).  For example using zoned XFS on normal SSDs shows very nice
performance advantages and write amplification reduction for intelligent
workloads like RocksDB.

This series depends on Darrick's rtrmap work to support garbage
collection, and on the rtreflink series for a stable baseline despite
not having support for reflinks yet to avoid having to cherry pick
individual patches for it.

As pointed out in the subject this is an RFC, formal submission can't
be done until the dependencies have landed, but the overall structure
and disk format is ready for review and we'd love to hear your feedback.

Some work is still in progress or planned, but should not affect the
integration with the rest of XFS or the on-disk format:

 - support for quotas
 - support for reflinks - the I/O path already supports them, but
   garbage collection currently isn't refcount aware and would unshare
   them, rendering the feature useless
 - more scalable garbage collection victim selection
 - various improvements to hint based data placement

And probably a lot more after we're getting review feedback.

To make testing easier a git tree is provided that has the XFS
dependencies, the iomap series and this code:

    git://git.infradead.org/users/hch/xfs.git xfs-zoned

The matching xfsprogs is available here:

    git://git.infradead.org/users/hch/xfsprogs.git xfs-zoned

An xfstests branch to enable the zoned code, and with various new tests
is here:

    git://git.infradead.org/users/hch/xfstests-dev.git xfs-zoned

An updated xfs-documentation branch documenting the on-disk format is
here:

    git://git.infradead.org/users/hch/xfs-documentation.git xfs-zoned

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-zoned
    http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/xfs-zoned
    http://git.infradead.org/users/hch/xfstests-dev.git/shortlog/refs/heads/xfs-zoned
    http://git.infradead.org/users/hch/xfs-documentation.git/shortlog/refs/heads/xfs-zoned
