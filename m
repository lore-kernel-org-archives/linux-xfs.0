Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC056392C3D
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773661561; cv=none; b=Kke8L7qYMZo7RVVZ8Mw4o4YleWWv0ms0fZ0cNuhE+A7CZrB7RCaNvArKBawOuNHeDauQFF5Au8hXjPq0oHID2F27DOJ1AGgkIzmohYTAQXpSdNn9pXlphJiCeez0OLB6BhgbvaCBedydRfb/gRb2BfSYuRyyKYltKsMJNSJ38e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773661561; c=relaxed/simple;
	bh=dCDjhcCPXNj72RoakmpePSMsrGwFs/RG3pdc7Rt7yRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MSueB1ZKgxyBv8FaL2bXYK+gAQzIfXJB7HEmCSuroLTgBmYtwV4Gz9fKWiFz0rGlM3olzLfzp+qtCR7UXo2G/X32AQeigKzd+jHtWuWrBh61mFHmIpGV5HOeyaJK+10xo0RTeflZQxXliaXhEbF8w1poHvxiIuDUyaS5BmPqmxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHw12a9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHw12a9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C595AC19425;
	Mon, 16 Mar 2026 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773661561;
	bh=dCDjhcCPXNj72RoakmpePSMsrGwFs/RG3pdc7Rt7yRk=;
	h=From:To:Cc:Subject:Date:From;
	b=IHw12a9Usxhwezm1hJ5yX4xMAe1FdAmgz+hBwHWTXknDTj6qxGosUq/2cvzL86Tg5
	 +enX+WUmCD7SyoHaNucvCumG7Oi9rFX6TVqqlWxlTgG9jQnOx6hVSYq2TIoUtWV7fB
	 9WOAcePy64gPcOXlcpqmRp+loeEnvhAgCh+uP2ACXYQMlGv3oM/bSF0SV9A92qDyT2
	 U/4O0v24jshUYs6S1BIIdJdx+tEF1eDa+jOI4Iar4gG0v3nU0tAwVHYdpgFFjrU6un
	 u6VUzt/Dg134ZQn4mq3Za3HQ4KSMfHp39OhyK6MGxbb35p57NaRcs9yci3QJj4jQrx
	 okcbtzCBzpKMw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 0/4] Zoned XFS code improvements
Date: Mon, 16 Mar 2026 20:40:16 +0900
Message-ID: <20260316114020.753228-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All,

Here are 4 simple patches to cleanup the code for zoned XFS.
Overall, there is no functional changes introduced beside the change
of information displayed in /proc/self/mountstats (patch 3).

Changes from v1:
 - Split former patch 1 into patch 1 and 2.
 - Changed patch 3 to add new lines of information instead of changing
   the existing lines.
 - Reworked commit titles and messages.

Damien Le Moal (4):
  xfs: avoid unnecessary open zone check in xfs_select_zone_nowait()
  xfs: fix a comment typo in xfs_select_zone_nowait()
  xfs: display more zone related information in mountstats
  xfs: avoid unnecessary calculations in xfs_zoned_need_gc()

 fs/xfs/xfs_zone_alloc.c |  9 +++++----
 fs/xfs/xfs_zone_gc.c    | 24 ++++++++++++++++++------
 fs/xfs/xfs_zone_info.c  |  7 ++++++-
 3 files changed, 29 insertions(+), 11 deletions(-)


base-commit: f8544b654f22b1138ba12bc0971a96963b20311d
-- 
2.53.0

