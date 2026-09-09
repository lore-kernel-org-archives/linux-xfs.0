Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BDA38F233
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933814; cv=none; b=RwS5D+Oh6SA3iov7EdUFMGWcNMjSxLkN4ZrCQTKlJl+Riz/YCpUTg894C8PJlswLkboGEobBCLPvgTbu7l89eTEnSCTh7Lz2C8rcAS70UAcKbPMNh7QOG76i2fMEskYrmlpEjdhKYw86kb241iCQC8LTHZLyUP927c7xIBszae4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933814; c=relaxed/simple;
	bh=4zEG4JzQLK1LKfu7dJzhnVszMWHATLA4EkrMjBn8Svs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnfjH+PO7UmJg/sFt9Xlg96YJrBDnhCiDKiklt9+7WnvxDiGA6wgX+PQfIAUH1F+Fe1ukYIKbX0ciTVcqcRSOCLZ5ehITodjteXOKkomJu0+fF/wCRvPMKNanJW7GU0xmCKUxKytgrPnKxPRfMQKtAcLahyicm3yO8g/ZeYdYUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhPe7j6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhPe7j6m"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6E3BC1F00A3E;
	Wed,  9 Sep 2026 06:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933813;
	bh=8T5iPyW38movMIIt9Ks3ZYkB6BE6s5Fque2MmZ+nLgw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XhPe7j6mJek29N2a04LzzeHtyuhUDTXGBeXjP8zZvbzpKEu0KkxblDFso1KEX4o9F
	 JGJpty39hpGgLKShdiytide+7IeksgBKmnWUxspXmRFV8mGC0ahYkQYZqJybguPmII
	 Utvmpr1tyXTYNNx6flV2ijFeeDrb2bmmJ72y2AxCSawuw5nqL8/4syR/yy2RocFhgC
	 74RHUvIZ69/a+BD+2tMdvQr0aXZKeyIQnI0bJ9stgDa4oMd0YhsG40K+H0wkqFtquE
	 IDPOuCE4yxh4Ukfn3VmLUUgVNQH6tI5KnXz/lIH0ZXwiGAq1KEU3pwbG9weLnCGqPz
	 +udouI7TuH9LQ==
Date: Tue, 08 Sep 2026 23:03:33 -0700
Subject: [PATCH 3/6] xfs: report runtime failures in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <178892936248.4057682.17611498534947155078.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new counter so that we can track the number of runtime failures
encountered during scrubs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/stats.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index da0c05ffe5cd0b..3339cae4b39d14 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -29,6 +29,7 @@ struct xchk_scrub_stats {
 	uint32_t		incomplete;
 	uint32_t		warning;
 	uint32_t		retries;
+	uint32_t		runtime_errors;
 
 	/* repair stats */
 	uint32_t		repair_invocations;
@@ -110,7 +111,7 @@ xchk_stats_format(
 		spin_unlock(&css->css_lock);
 
 		ret = scnprintf(buf, remaining,
- "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
+ "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu %u\n",
 				name_map[i],
 				(unsigned int)fss.invocations,
 				(unsigned int)fss.clean,
@@ -124,7 +125,8 @@ xchk_stats_format(
 				(unsigned long long)fss.checktime_us,
 				(unsigned int)fss.repair_invocations,
 				(unsigned int)fss.repair_success,
-				(unsigned long long)fss.repairtime_us);
+				(unsigned long long)fss.repairtime_us,
+				(unsigned int)fss.runtime_errors);
 		if (ret <= 0)
 			break;
 
@@ -207,13 +209,17 @@ xchk_stats_merge_one(
 	}
 
 	/* caller applies this same transformation after we return */
-	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
+	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {
 		sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		error = 0;
+	}
 
 	css = &cs->cs_stats[sm->sm_type];
 	spin_lock(&css->css_lock);
 	css->invocations++;
-	if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
+	if (error)
+		css->runtime_errors++;
+	else if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
 		css->clean++;
 	if (sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		css->corrupt++;

