Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C57513D63D
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307698; cv=none; b=BHjvQZi3oxsdN2CjKV/Lu8JyhUyqfvuZ2GOWl6jpVs/1mbte+ZbHclOJzs8KyaWw6bKeuvMnymfhGFVWltCFxcQ9ozqjrDvrgEp1cpx8vEEugxMK7PFCYBLaWIK20ztwZL/y79QXyyw7on4e1OKEn3Llsc6iewHgX1Yfiql4FR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307698; c=relaxed/simple;
	bh=v1ZKdLXLM9suGBhGOVb3oYBWJmJ2zwAEsSPI7Al97kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dexnTddcoQ7DuvMCwRjDzqNEDJZXG44GoTlvYd/l5ST7W0SyR+qSLXt+a9ny/E6YSf1KPpZbS2e7ScmecaZzPPEodCla43dUxWS1QEzjc7uQVPi4eH3pkSGXtfhGdQD21OtAR4fnFydTTrAGRLC19bZsz6oW2dXq6HquDwd5xcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eV1Ykoc5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eV1Ykoc5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721307696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bk8WncT64lzd4LgIcFxlqG71mv9F7AOrhpNIyzQF2CI=;
	b=eV1Ykoc5f7RyMTPO0gTisO1r1KoUWDCKLaYreFq05VRJuA8avsNPSdL7pqN/H8Kn7kXn//
	SNzjrseLyCL2SgkmYFN296gEohvdE3956ijfHkhgPD30gk6aUNOTp9xrcKz6Mmwriv0BqA
	Y/jgHIfEWIW51wxpR0Vcrdxzz97UhF8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-7098IFzjMyC3RB2-ZVHpBA-1; Thu,
 18 Jul 2024 09:01:32 -0400
X-MC-Unique: 7098IFzjMyC3RB2-ZVHpBA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BFC21955D60;
	Thu, 18 Jul 2024 13:01:31 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C565B19560B2;
	Thu, 18 Jul 2024 13:01:30 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] xfs: remove unnecessary flush of eof page from truncate
Date: Thu, 18 Jul 2024 09:02:12 -0400
Message-ID: <20240718130212.23905-5-bfoster@redhat.com>
In-Reply-To: <20240718130212.23905-1-bfoster@redhat.com>
References: <20240718130212.23905-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The EOF flush was originally added to work around broken
iomap_zero_range() handling of dirty cache over unwritten extents.
Now that iomap handles this situation correctly, the flush can be
removed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iops.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ff222827e550..eb0b7a88776d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -862,16 +862,6 @@ xfs_setattr_size(
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
 				&did_zeroing);
 	} else {
-		/*
-		 * iomap won't detect a dirty page over an unwritten block (or a
-		 * cow block over a hole) and subsequently skips zeroing the
-		 * newly post-EOF portion of the page. Flush the new EOF to
-		 * convert the block before the pagecache truncate.
-		 */
-		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
-						     newsize);
-		if (error)
-			return error;
 		error = xfs_truncate_page(ip, newsize, &did_zeroing);
 	}
 
-- 
2.45.0

