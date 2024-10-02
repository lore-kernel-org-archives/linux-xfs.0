Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE101C2E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832207; cv=none; b=PaPx1A/EBzYtDZMo/WZVFRocqLFbz6J/UxmMq+I12ouJ4KvlG1nc9va/4X2TutaoEVrCWc1h7IqgIpQkC1QYovreB6u4lYh+OlscRfERcnNqi0nx0wyJujzToQWqumKHRAbEb2+eb/9hzk8TppsWxr8Q7YcU7J1y1JOo68SvY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832207; c=relaxed/simple;
	bh=HgA4CDZ0NJtCz/Iao1Xwbmh/9ANPChivcCioV4Fr6S0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c0tDZU4onDeUN1ycSj+m2FxQWo7G+6w0KNjEk73aJwUyAmPc/C9GshbSEGflAY81Mvi3K1zmBmNkTSN2BLL8qKbq9GO79S6bmVvBaFV1Rcc51U4b6ax/X0D1TsGRdr7DhUHaKBnsvMQu/fsjXEuj+IxF4rBR9Wvk5AGFGf3Jn0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLazHJUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLazHJUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537DFC4CEC6;
	Wed,  2 Oct 2024 01:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832207;
	bh=HgA4CDZ0NJtCz/Iao1Xwbmh/9ANPChivcCioV4Fr6S0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iLazHJUFwcQv8PTiFqL6BTW8Do3U+/JQU7LQFMeWz9yi/gaEcu24c7QEbLFhdazBe
	 fO6lRKPMRToyPjJw1ShIJpQ5Y5lgIzytxM6fGQ2QbgTIlCwOVj4qrgyZOn9IZN+9jQ
	 kiBkJSlqsQq+fgUcq8Wl9zqBIM2nrGbJ23cm/lktcCdKK/DAdwPEcB7Z0MRvQ6B9cO
	 UzmlRTHN7m8WViYsHcUCf/pHVC+5QeoakGRp77aYKg83NsiejQJGmgIgslB96k9120
	 bHQ35LhQ7rdmob4Ajxyd6x/snokKBgSyQUDcU2KrLU5LgBRBOGqaQ/p9MOjgCWZ8lB
	 HWJyVYxOVWvhA==
Date: Tue, 01 Oct 2024 18:23:26 -0700
Subject: [PATCH 60/64] xfs: background AIL push should target physical space
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172783102685.4036371.4796452303078240583.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: b50b4c49d8d79af05ac3bb3587f58589713139cc

Currently the AIL attempts to keep 25% of the "log space" free,
where the current used space is tracked by the reserve grant head.
That is, it tracks both physical space used plus the amount reserved
by transactions in progress.

When we start tail pushing, we are trying to make space for new
reservations by writing back older metadata and the log is generally
physically full of dirty metadata, and reservations for modifications
in flight take up whatever space the AIL can physically free up.

Hence we don't really need to take into account the reservation
space that has been used - we just need to keep the log tail moving
as fast as we can to free up space for more reservations to be made.
We know exactly how much physical space the journal is consuming in
the AIL (i.e. max LSN - min LSN) so we can base push thresholds
directly on this state rather than have to look at grant head
reservations to determine how much to physically push out of the
log.

This also allows code that needs to know if log items in the current
transaction need to be pushed or re-logged to simply sample the
current target - they don't need to calculate the current target
themselves. This avoids the need for any locking when doing such
checks.

Further, moving to a physical target means we don't need "push all
until empty semantics" like were introduced in the previous patch.
We can now test and clear the "push all" as a one-shot command to
set the target to the current head of the AIL. This allows the
xfsaild to maximise the use of log space right up to the point where
conditions indicate that the xfsaild is not keeping up with load and
it needs to work harder, and as soon as those constraints go away
(i.e. external code no longer needs everything pushed) the xfsaild
will return to maintaining the normal 25% free space thresholds.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 include/xfs_trans.h |    2 +-
 libxfs/xfs_defer.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 912bd4085..9bc4b1ef5 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -163,7 +163,7 @@ libxfs_trans_read_buf(
 #define xfs_log_item_in_current_chkpt(lip)	(false)
 
 /* Contorted mess to make gcc shut up about unused vars. */
-#define xfs_ail_push_target(ail)    \
+#define xfs_ail_get_push_target(ail)    \
 		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
 
 /* from xfs_log.h */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 56722da23..e3a608f64 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -550,7 +550,7 @@ xfs_defer_relog(
 		 * the log threshold once per call.
 		 */
 		if (threshold_lsn == NULLCOMMITLSN) {
-			threshold_lsn = xfs_ail_push_target(log->l_ailp);
+			threshold_lsn = xfs_ail_get_push_target(log->l_ailp);
 			if (threshold_lsn == NULLCOMMITLSN)
 				break;
 		}

