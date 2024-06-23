Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED5E9449
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121505; cv=none; b=LdqoHRE0l5F93WM4laPjzDJjn9r1oGRzvTgjKm9leFmbU0i/5j9Z7np4jHzbhDn60xaXdYnGEgp9OkETXs+etiWYcXCHhn4z0eOaExAun5OVnvOP40UOkDc1D6Wbw1HBXxJCqHRnxCuKUuVkHD1PNmxOtw8RHcohgkgrbL8fR8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121505; c=relaxed/simple;
	bh=3TkPy9xnV+cDUOzNMpIekyVOrgBpIMwHGU88sXqPfXM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EU9uuKMp+zCO1uxlvcdUGRMontugsuJMwuODht3B2gR2q/Njisfh7DjemB62nPdqkGJp2SC2S4nGsNFarKTGretjuXH+Y7CbZUqswnXQIXb0VjXeZ0bx704HS59MEm2UEJpEQxfbJkYBi+Q5k4aVk0aYsm7osj8grE90Yz4W12M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E0neTB10; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E0neTB10"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kZBquNzR4kWAOlc8QuXKrlCrw6v6YA/DcZPIWU2fbcY=; b=E0neTB105gKbkl6dpRKlk3SIot
	ksw3l+rFC+sZgwUM9bRrHUIhLcRhHyg3RiO7v8sqrxmfE7rxZjdL+yqDmiEIoduH9BYCJcH8tKrNz
	ITw3fr9ETyH9QwXJ1PFW6p4hDbBHU5PLY6AN7DqWNrY9cVZYcC5byjQ+Q0FTRPDzQ0hQeTyLFXWmg
	uz+0n0ydoB9OK1jsT5rj07v3JK6wvkY1Z+Vanx/NVjsQ4vEIYpKc8lWwaxKH7my96+pLa2JdQFFei
	I/+WW96Ob2IcgDkSgFUYbA24urlsbRtNy81nnd2LbP7O83M5Kls+qQODvisY7DvVrpo1duWjxFLNq
	85qwcqNg==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLG2B-0000000DP9c-39Pw;
	Sun, 23 Jun 2024 05:45:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: clean up I/O path inode locking helpers and the page fault handler v2
Date: Sun, 23 Jun 2024 07:44:25 +0200
Message-ID: <20240623054500.870845-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

a while ago I started wondering about some of the I/O path locking,
and ended up wading through the various helpers.  This series refactors
them an improves comments to help understanding.  To get there I also
took a hard look at the page fault handler and ended up refactoring it
as well.

Changes since v1:
 - rename xfs_dax_fault to xfs_dax_read_fault

Diffstat:
 xfs_file.c  |  139 ++++++++++++++++++++++++++++++++----------------------------
 xfs_iomap.c |   71 ++++++++++++++----------------
 2 files changed, 109 insertions(+), 101 deletions(-)
