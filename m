Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2AB22EE9
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705512812; cv=none; b=sdjqzEiHQhnIQqGsCgPD6+vPu0Ohf03g+dxsA+WtRD0QK1uPgm3Ne4nSDdCrqQ9tP4VMWJXYs8kMqSzGibSJwacvnnYviSKVSYC0te+hLsBAFF19u+qmvIkrp7e4n4qXni9waNySobKxGbLu7VJlLzYtB2b/xZ8IN3BdC9iqb4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705512812; c=relaxed/simple;
	bh=9Ok0ZQKSf3duo23Y429cYCcGQl2uOxpdakUdYwD5tjI=;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite; b=kGeAqIwcPKuAOrmnh7pMfJEKwq8GT6sMARcBzEQqeQWkoJv+55Sg0XRtG5JXFusx7xA+q8Fi9Yq5ctIiWJsiVYnE6ASSEi6cvdHOC4EwxIpLtbhBqq5faDXQphYxUMzWEXIDX1KNZ7kpAjevEKimoGztNo5qzaj0P7QmdrjbJ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=smSda3vF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="smSda3vF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0Y45DTBqWdDtn9mR2FgmveS/tUj68OAUP8V87tiXWks=; b=smSda3vFV1u2PpSkwhKB8QGZyL
	oP4uYkQtg83O+ZZAZXB4lGZ7kam1YasHryS3W0m81cZUR0V0XjgOnJ191bhKEbFgvq02t2KQewC08
	rLjiPlPoGBlivgonm8VPvkpwGQYxAtbx8VnjaIV93e4xqkiYYANYYnc+UWEHrQNKT8x9croouftKy
	m5mOSVR7IjgpmbfoUAsmeRmLet7CulYVLEEHZDukqweBO2DXBeaDUs9WfxLCf2iF17Xm9UQjAYRDn
	eMVb+aDjuOBGZaN++AmOl1z8P9gyAPbYRGtCjfL+JqQabmhwW10rSw6uPjgBvUPig+KrWSxhTcGMD
	oeyX+zbw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rQ9n6-000ERa-0N;
	Wed, 17 Jan 2024 17:33:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] libxfs: also query log device topology in get_topology
Date: Wed, 17 Jan 2024 18:33:11 +0100
Message-Id: <20240117173312.868103-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240117173312.868103-1-hch@lst.de>
References: <20240117173312.868103-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Also query the log device topology in get_topology, which we'll need
in mkfs in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c | 1 +
 libxfs/topology.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 3a659c262..9d34235d0 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -326,4 +326,5 @@ get_topology(
 {
 	get_device_topology(&xi->data, &ft->data, force_overwrite);
 	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
+	get_device_topology(&xi->log, &ft->log, force_overwrite);
 }
diff --git a/libxfs/topology.h b/libxfs/topology.h
index ba0c8f669..fa0a23b77 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -20,6 +20,7 @@ struct device_topology {
 struct fs_topology {
 	struct device_topology	data;
 	struct device_topology	rt;
+	struct device_topology	log;
 };
 
 void
-- 
2.39.2

