Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BEB155330;
	Fri, 21 Mar 2025 07:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541710; cv=none; b=QHFbRKpGTX37lfnphR56nH/nlvGNjPZCNDolSTFxs/Gj06GMAP0+XQ8+5qiY5ztzJ5GxwuFkf1wZvLZC0NAVvnW1E7nTvm3t/c3m3bjq0wrP3rlpvFEa3ogdcDRy07ZJD/NxQWvWRSagKMo+75z38P4bfxBqWFyNDv4rFg1Uj7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541710; c=relaxed/simple;
	bh=fYFTs//DGe7JBOvgs2WE1iCavgi2y6k/wZ+au5hplYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g0wAUa5oYMEEo3VdOOtHj118uNlMgIPEpvA+Gv+2Lr9qBE8fyWx4jx/Wrj+g/+SmMj3dwr8MoWHoDIAxN2WqabbxTW1gM/CP/WxBho0ew1jUizkQUaigI8HUo4YXqPosa1QcR3B9CBNqgJiE0tPTTjU4JHdyKbBY4uAfuBPwmg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ufdd8e2j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ufdd8e2j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kFgcxCcvQoajT18WMBxAm8neODUXlX93Hu+mN0+PL8Q=; b=Ufdd8e2jH0yvNJ+4in8lQqHFAS
	Kby716EsATWRjR3OvqxFaux+TdheoWeRiHJ/+adEEB33q/wYymUmSUXXgZ1oaRRBKNlekABh4sCrb
	PjldyG82+WbnFx/3w9IaEIwPRExCabuZTfnQcDvCjqBuWHNxsvE/UuEQ6IURkvshMcb+TUhF8SAZH
	SpK8lk4qnolfr9nuOYyuEDeRpqEFw8j89Rz1ySXKAIWKBpNs5S9aSE/ZU1zbJ/CvLIC7Nm0k8Cgo7
	i469NfqzKXzYMH9lkRVNVu//+kxsWhxfkJeXNz3WyWZ+z1PKH4yiGWmM00gax7EOGPYMBCqCizZHB
	FMRSzEWw==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhP-0000000E5B6-3MDF;
	Fri, 21 Mar 2025 07:21:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: initial xfstests support for zoned XFS v2
Date: Fri, 21 Mar 2025 08:21:29 +0100
Message-ID: <20250321072145.1675257-1-hch@lst.de>
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

this series adds initial support for the zoned XFS code merge into
the xfs tree to xfstests.  It does not include several newly developed
test cases which will be sent separately.

Changes since v1:
 - improve a few commit messages
 - use -n instead -b in _require_dm_target
 - add a code comment
 - use $XFS_INFO_PROG instead of xfs_info
 - fix spelling in a code comment
 - don't re-specify the zoned option in _scratch_xfs_force_no_metadir
 - don't skip xfs/311 on zoned devices.  A patch to support zoned devices
   in dm-delay has been sent to the device mapper list instead
 - remove the _notrun due to non-aligned dm maps in xfs/438 as this
   test is already skipped due to the lack of quota support
 - drop the patches that parse mkfs output for now.  They will be added
   once the output has been improved, finalized and merged in xfsprogs.
