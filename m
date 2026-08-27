Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8405D3C2D;
	Thu, 27 Aug 2026 05:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808749; cv=none; b=JXZzrXZ+NFgon3mMvn2wau5F+A87OEG72HL8kqXTdPO/Pxj4XJfKLVusStgqNRm9CD3lZrKh1YG5lwV0TZd3jXpLpT8LVxHwufqAc43z0dfJKZYJhg7twy2adSnmQhfQ8/gUT5r4SbviYoV3Fampd2hIHsrL0QDFc8opH7BPANk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808749; c=relaxed/simple;
	bh=SrHFmhQVG7qq3yR1IPLjB3npwPb9nyfPb/MNNSa2Gx4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRvfYtEKtRbyBGklpr/YeClss16aimcwcADAgIAvo7V0O9ylue6vNQjRWCRCiM3utYVDfDj8WxnQveNyqHTJ6CNdk2bMFU/v9mFR3bNgSKXJjiPm8ZUiB2ekeMJIxQYec/6eJ0lP5YD0V99eI1+srrULBT0d4yZJn0wz0CHtud0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1ALedMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1ALedMV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5177A1F000E9;
	Thu, 27 Aug 2026 05:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808748;
	bh=+J6MbXSiL/MEpPJCal4sMj6ay7Lyi798PSjNAiEoL14=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=a1ALedMVIirFrU2wmTUw4GjH6VkQy/ByibDkaMoNAdcVRikfYQidgvyjLaVrDytGL
	 9BMBj+RQlU6CzujFAe8VIuIklIjQygovcWaU3jauQ8jIgwD4sM4Qn/ZWEznpvLnCC/
	 eiIhay87O/Mf9dsukvk+2OYBk34K9p4hTxdmtF9O+NWDBP+jFU61E1xlK4RxD0PiH0
	 0SoILl8GwsP4qny5tJqkXlJ5tJlYa9iguZSNdE3I2X2RYXsZ1VfUqlf7A8qTcIj3PK
	 /cPPONkufCAJ4Qzkh+KukPtTJbWak3Xlq1ywh4twG8lDG8S0pifhmflprDxhWE4ilm
	 GbfTi5lKWuw6A==
Date: Wed, 26 Aug 2026 22:32:28 -0700
Subject: [PATCH 6/6] xfs: lock the healthmon when inserting unmount event
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640303.3528187.4785802682222873330.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that xfs_healthmon_unmount does an unlocked insert of
the unmount event into the health monitor's event list.  Fix that.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: 25ca57fa3624ca ("xfs: convey filesystem unmount events to the health monitor")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_healthmon.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 4521ffdab9f1ae..3ae5f4496ad1aa 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -272,6 +272,8 @@ __xfs_healthmon_insert(
 {
 	struct timespec64		now;
 
+	lockdep_assert_held(&hm->lock);
+
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
@@ -294,6 +296,8 @@ __xfs_healthmon_push(
 {
 	struct timespec64		now;
 
+	lockdep_assert_held(&hm->lock);
+
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
@@ -415,8 +419,10 @@ xfs_healthmon_unmount(
 	 * There's nothing actionable for userspace after an unmount.  Once
 	 * we've inserted the unmount event, hm no longer owns that event.
 	 */
+	mutex_lock(&hm->lock);
 	__xfs_healthmon_insert(hm, hm->unmount_event);
 	hm->unmount_event = NULL;
+	mutex_unlock(&hm->lock);
 
 	xfs_healthmon_detach(hm);
 	xfs_healthmon_put(hm);

