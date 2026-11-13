Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569359;
	b=S8seLdqSQ8CVgOsbPY1VO5Jy6eJOc59xaDEuFundFMOEXzHnEiSSbGcI8qScwRjiWbe9
	 SFq6iUla3I1nEhMR37ikmTr6f6Ojp1UwOS+u28MjN4cd5BMc/z0Akx28CYzjJo0o2FVBF
	 TTJQdbREWqU+JFw4Us1wDcCFokmxTztajbj52xH64sF7LZ2QwCRRP8rU1iakguspzCHYd
	 JL0OO9zW2ZiJX5sfQIthymrIc02tlwjzbduI8JfU7d0nhRVt/3DJkSoqEfriE0lU15zpL
	 ZCDq0Q3wgmfQH6AY0+z2ukJprwsJ+mddJxaBOUnciktFKeX/1Y+k6NJtbhe4I9/9X/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569359;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=PemelQqymxFjxgU+rdDDfIipGOLO+opjqf02VUTtJto=;
	b=F8pbJ5NTt5QQL0IhuyHYRZ6oHj5q1T+yQMJHeO1sT7crXu29kwXI3PUYfsToncXubA20
	 +5QvhFjBB2UhlV0kntmkNqiU+dwugtKIWanZVTxF5mEmUYbD+IRmSP7t/x6Ahdb2S04Ou
	 dpMCM3O8Snfr24yIxeq+tJOU9h9UYHtZ6npwmV6flYG5JFGGOlcUp+cDcDFB+h8kSK0fZ
	 oG5oTXhIWRDSTxg3hrEAozx1UOE6WCD7TfnsSJ8EivBJOypKTow8gN2dfSZrL8om2lhK6
	 z2pDuG3tQOILLucUfU50hQjmCDGNh1jCj6URClPyrl+wo5nHeQ84lZBs4J/i0bUMwqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95EF606A323;
	Fri, 13 Nov 2026 11:29:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E95EF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C87E068B05; Fri, 13 Nov 2026 12:29:13 +0100 (CET)
Date: Fri, 13 Nov 2026 12:29:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xraid@lists.infradead.org
Subject: [ANNOUNCE] XRAID - declustered parity RAID for (zoned) XFS
Message-ID: <20261113112913.GA31748@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

We're happy to announce the initial public release of XRAID -
declustered parity RAID integrated into XFS.

The two primary aims of XRAID are to support parity RAID on zoned devices
like SMR hard drives, and to provide a fast RAID implementation without
inherent data integrity problems.  XRAID, just like zoned XFS also works
on conventional hard drives and SSDs.  Optimizing for SSD performance has
not been a focus, but even without that, writes are up to 20 times faster
than mdraid.

XRAID builds on the zoned allocator, which uses the RT subvolume to store
file data separately from metadata, so that only file data is placed on
sequential write required zones while metadata is stored on conventional
devices or zones.

XRAID takes advantage of this organization to only provide parity RAID
for file data, where parity RAID works efficiently.  Metadata redundancy
is delegated to existing stacked Linux drivers like MD RAID mirroring,
which is more suitable than parity RAID for small objects that are
updated in place.

The RAID implementation sits below the Zoned XFS I/O path, similar to a
stacked block driver, and aggregates the physical zones of the underlying
devices into logical zones that are used by the Zoned XFS as realtime
groups.

Declustered RAID describes a variant of RAID that distributes the D + P
data and parity blocks in each stripe across a storage pool that contains
more than D + P disks so that all disks participate in read, write and
reconstruction operations and spare capacity is distributed over all
disks.

Declustered RAID provides much faster rebuild times than conventional
RAID, and eases using of a large number of disks in a single storage pool.
XRAID can rebuild to all devices that have spare capacity, and the rebuild
order is dynamic, allowing to rebuild zones with multiple lost
redundancies first, and rebuilding data zones before parity zones to
reduce the overhead of degraded reads.

Work on XRAID has been ongoing for a year and a half, and while we aren't
anywhere near ready for an upstream submission, we are interested in
feedback and testing from a wider audience now.  The current
implementation supports zero to 2 parities.  We did experiments with the
SnapRAID parity library to support 3 and more parities, and while that
is not included in the current version, support for more parities is
planned and the code is prepared for it.

The xfsprogs branch includes mkfs support and a new "xraid" utility for
managing devices and inspecting an XRAID file-systems.  We have also
extended Zonar (The zoned file-system visualisation tool) to show how
each logical zone maps onto physical zones on devices.

A presentation at FOSSY this year has more information including benchmark
numbers on zoned and conventional devices:

    https://verein.lst.de/~hch/raid-sucks.pdf

The code repositories are available here:

    git://git.infradead.org/users/hch/linux-xraid.git
    git://git.infradead.org/users/hch/xfsprogs-xraid.git
    git://git.infradead.org/users/hch/xfstests-xraid.git

Gitweb:

    https://git.infradead.org/users/hch/linux-xraid.git/shortlog/refs/heads/xfs-raid
    https://git.infradead.org/users/hch/xfsprogs-xraid.git/shortlog/refs/heads/xfs-raid
    https://git.infradead.org/users/hch/xfstests-xraid.git/shortlog/refs/heads/xfs-raid

Feel feel to join our xraid@lists.infradead.org mailing list here:

    https://lists.infradead.org/mailman/listinfo/xraid

