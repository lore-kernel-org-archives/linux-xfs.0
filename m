Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B33233263B;
	Wed,  2 Sep 2026 05:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327987; cv=none; b=osx/rDUMKBLQSGjfR+S0AemwhDt2h91jAPsrlfkUk6XjNXur38OiM/K6sv+2WrFdDH31xD9JcpGuTde29L+5RnGPD5vhRl1J+wqsnkhFgDvEY1j2JFXPcNfVnrkAW2mNGqT9nFUJ+FOTroeFaknVvUlfH4pZSNNL74HavLj5pgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327987; c=relaxed/simple;
	bh=SrHFmhQVG7qq3yR1IPLjB3npwPb9nyfPb/MNNSa2Gx4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDfWZTqU+FmHozfQxpqhGZ1iCLUuFyhmlbHSwvUhyF9vd4Q4Zy6sgBFqqd4kf8zZ8i4OR5Tz3+VPtTw21NWmoD2DkIvtEemxF+IsMOwc0CEqAih3C0N//6X2gNf4qOmsfLxTGSTPowdFm+hnJ/N8Y3wb/ksB+LqNyNzHa56lepM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDFUObPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDFUObPE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A1371F000E9;
	Wed,  2 Sep 2026 05:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327986;
	bh=+J6MbXSiL/MEpPJCal4sMj6ay7Lyi798PSjNAiEoL14=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VDFUObPE5nq7y4Oi7FuiVUmt3IrjT3lPAntHV7ACC59QD/vQUvp2WJS2mjVI9phAA
	 FaTPP+Y+1wr9fx99TSjbxZcLlMWw4NSKPcLJBtVxmUtdc2uqz27sz8rXMiNoJpccMo
	 CuHoDXRAzqEemetVphthSNK+L2HQlI8WppIe1IlHIERnNgoVyD4k56SOSzbEZ8cyqk
	 a03tUaUeav5BYuw2T3v0eAw2exgJgxCeAMKjrscNpdQHxkEV999PiwJ1Q+tFAEX0Vd
	 ccWdluxhr4PS8iNxp3wzY1AdV9Jo7YCfvXXL/3AhrOoc8d7W/tu73Im6ufQ2hxY7eQ
	 lsb6ufSTnRsYw==
Date: Tue, 01 Sep 2026 22:46:25 -0700
Subject: [PATCH 6/6] xfs: lock the healthmon when inserting unmount event
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749961.3507493.2323960743439180395.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
References: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
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

