Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F172107
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832191; cv=none; b=l0D0/WV0IPfar3Bu0Fc/mCC4vZjExiQuudSDidAe5Brbc7MyLczQ1xmAlqMmJdSW6Yrm12WBB4Hic2Mbp1NhIbyXBEI5GeN93y3nz0zGoa5fac4CawcsW4uiatMT1b3qYFZrTFeqniYoctVJNIMzzICSpa2Ky7LIcSizV6kkf4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832191; c=relaxed/simple;
	bh=8BOkwUFUCooHisG/oui4M8GS0BixLuHhpeNNJLA2KJ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMS0DhVdPGng5x09FcdihMC51mPDUMJfsXE+CKk3ZaD7b/Wq3E6GEPNMxHYRo6VtYZ6UN3ZVrSHj9pXxCrpXPpYkkrS9Da/1hAFwxtfZ2ItuEUPViUZyU4aef3rKJ852eLreIqt6BvqasQpifuC7rVBTMrmrsmeA9BjynKCW3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iEe/CYgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iEe/CYgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05FAC4CEC6;
	Wed,  2 Oct 2024 01:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832191;
	bh=8BOkwUFUCooHisG/oui4M8GS0BixLuHhpeNNJLA2KJ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iEe/CYgutVQquoDvyrhkTUusD0Chdom1Jo9/Lw6gbv8RRz2xkvYldBnUeNu/gNnWo
	 itjrYRfGIyUylqP11R2BQyFuWN+RkVCXWkE8Cz6AWwZAALHCEf3bo2X1/d0KttKPji
	 y9ZVTnLT0+YnV4ZTT3bkSpAEAt6icuEIuaJdt+n+M5QTTUblLll5NoVgblDGRhiS6k
	 Md2PDMK0TICAmTOJchEJ0lIvOF9CdYkqAk4+mxuOTUKHt+uAlh71iO9MnkF5paAlsv
	 BJ3aGToaU2C8HnAnV9soZsw4p93LZUkGnMlGfQQ4drgnfYtuns5CWBQ+KLyKLglFWI
	 RxRwppc0e3t8Q==
Date: Tue, 01 Oct 2024 18:23:11 -0700
Subject: [PATCH 59/64] xfs: AIL doesn't need manual pushing
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172783102670.4036371.17917610512626828787.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9adf40249e6cfd7231c2973bb305f6c20902bfd9

We have a mechanism that checks the amount of log space remaining
available every time we make a transaction reservation. If the
amount of space is below a threshold (25% free) we push on the AIL
to tell it to do more work. To do this, we end up calculating the
LSN that the AIL needs to push to on every reservation and updating
the push target for the AIL with that new target LSN.

This is silly and expensive. The AIL is perfectly capable of
calculating the push target itself, and it will always be running
when the AIL contains objects.

What the target does is determine if the AIL needs to do
any work before it goes back to sleep. If we haven't run out of
reservation space or memory (or some other push all trigger), it
will simply go back to sleep for a while if there is more than 25%
of the journal space free without doing anything.

If there are items in the AIL at a lower LSN than the target, it
will try to push up to the target or to the point of getting stuck
before going back to sleep and trying again soon after.`

Hence we can modify the AIL to calculate it's own 25% push target
before it starts a push using the same reserve grant head based
calculation as is currently used, and remove all the places where we
ask the AIL to push to a new 25% free target. We can also drop the
minimum free space size of 256BBs from the calculation because the
25% of a minimum sized log is *always going to be larger than
256BBs.

This does still require a manual push in certain circumstances.
These circumstances arise when the AIL is not full, but the
reservation grants consume the entire of the free space in the log.
In this case, we still need to push on the AIL to free up space, so
when we hit this condition (i.e. reservation going to sleep to wait
on log space) we do a single push to tell the AIL it should empty
itself. This will keep the AIL moving as new reservations come in
and want more space, rather than keep queuing them and having to
push the AIL repeatedly.

The reason for using the "push all" when grant space runs out is
that we can run out of grant space when there is more than 25% of
the log free. Small logs are notorious for this, and we have a hack
in the log callback code (xlog_state_set_callback()) where we push
the AIL because the *head* moved) to ensure that we kick the AIL
when we consume space in it because that can push us over the "less
than 25% available" available that starts tail pushing back up
again.

Hence when we run out of grant space and are going to sleep, we have
to consider that the grant space may be consuming almost all the log
space and there is almost nothing in the AIL. In this situation, the
AIL pins the tail and moving the tail forwards is the only way the
grant space will come available, so we have to force the AIL to push
everything to guarantee grant space will eventually be returned.
Hence triggering a "push all" just before sleeping removes all the
nasty corner cases we have in other parts of the code that work
around the "we didn't ask the AIL to push enough to free grant
space" condition that leads to log space hangs...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 include/xfs_trans.h |    2 +-
 libxfs/xfs_defer.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index b7f01ff07..912bd4085 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -163,7 +163,7 @@ libxfs_trans_read_buf(
 #define xfs_log_item_in_current_chkpt(lip)	(false)
 
 /* Contorted mess to make gcc shut up about unused vars. */
-#define xlog_grant_push_threshold(log, need)    \
+#define xfs_ail_push_target(ail)    \
 		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
 
 /* from xfs_log.h */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 7cf392e2f..56722da23 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -550,7 +550,7 @@ xfs_defer_relog(
 		 * the log threshold once per call.
 		 */
 		if (threshold_lsn == NULLCOMMITLSN) {
-			threshold_lsn = xlog_grant_push_threshold(log, 0);
+			threshold_lsn = xfs_ail_push_target(log->l_ailp);
 			if (threshold_lsn == NULLCOMMITLSN)
 				break;
 		}

