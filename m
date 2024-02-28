Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E50B14AD34
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709128396; cv=none; b=aKtQHF/w4X1p//LHTWyAHwnIpNZ6AIzJ0igivg6zzX2ki86+OFOvdIjXJhVCTcJuhby7M7jyNlRi1gUmD+qSCsq5NymFjrBF6rw8UFRcFy9ozpSb0HN0hjRggVLzX0JbDsUzs8lfBOe2wSZrwarhJpdx/sC+HpawWen8rHDx12U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709128396; c=relaxed/simple;
	bh=xpzHUvwfI9YuwfYDoqu/44WP2riWczG5XJc09OvDpwE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H04HARia9SG/iD+xBQW5huCXZ/9cGa/NVdE12aCxXDVu0mOrxxVorfhsgjNO2UclCnpawh8hSc0oJYN7aOdO14HaFW50k2XWnWYEDoewna9xtY30Rm1wND0n9CSxZidD0y83R1W+VoObhNuQmDU3jF4zRPBVr/3e052C+ZwUQXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=okIgCTs1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="okIgCTs1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=IgDYAgmiQJFdIRZOMMFsM2Z1xHGMRju2uRhelAI96gY=; b=okIgCTs1/QFhRF6hffcCza1tTt
	MCHMBnUmBeQu6+39L8mZjQuyNv1W3EodYEKHEkk9U/7+BI9X4D8JfuSb2OVXk0Ip5h7oTLwrg+NMb
	8WO7xSKViiX/PSjuWL+TdQL3cc1+jR4EV2DyEqMO8ieEhjm+QCBa9d0+pJ73ZUmnYtgpDariXR3DP
	hID4m/bPBj3k1nojN0hfplvvTUyfGoEcV1Ml4JggN4sQmdB239+H4mGpM/ywpR3uO92+WHNxZPE2u
	tFifKf1fLJKqyfTTBzF86kx64+6zO5NTL3CKI6a3TZUbrzhDOzSqRsx+5cqYQgspMcGG/Meow2pAF
	DLSKYd4Q==;
Received: from [12.229.247.3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfKMz-00000009Yt5-2jEY;
	Wed, 28 Feb 2024 13:53:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: don't use O_DIRECT in xfsdump for RT files
Date: Wed, 28 Feb 2024 05:53:12 -0800
Message-Id: <20240228135313.854307-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

for reasons unknown to me xfsdump has been using O_DIRECT for files on
the RT subvolume since day 1.  But on 4k file system this causes writes
to fail due to alignment problem, which shows up in xfstests xfs/060.

This removes the O_DIRET flag and treats RT files like files on the
data device and thus fixes the test failure.

(xfs/059 still fails on 4k file system when using rthinherit with what
looks file data corruption, I'll look into that next)
