Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882A12517AC
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 17:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039507; cv=none; b=KiZkMf4KjmzV/PLnAPsJ9A+BUhTYLCl8rcubrMJD4YHwQJNHc4r+6mgbREl+36ZVwnZYJVg0+ETaEH66V8Qtrp6c3DfUkRzERVPKR2DnJWFHDAR7k12ptAA3eketDOYQkTiwZSbQNGwb9Yx+r5UNUSUwJWTjRP3swAVnVT+XX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039507; c=relaxed/simple;
	bh=B82YnSbcOGHskASSPJxDjsli7lapgEAZc5LBmPJKXmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=a5sR2DnqdY5SeXE1Hferb0NhQ2fAQTvx1XFztiVf+hYU0vIJBcCOVEpLl/XGLR9vZiJS8CHDROg0qNvgCbu6+LIrYuXJMs0gv4Z2w/EJGulptnOxGr9L1YI/g145DKYIeuYv2w5DeegKoy9TXzRhz+0CK07Uawt0HXVSR+F+gqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPfOzjt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPfOzjt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203FBC2BC87;
	Wed, 25 Feb 2026 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772039507;
	bh=B82YnSbcOGHskASSPJxDjsli7lapgEAZc5LBmPJKXmQ=;
	h=Date:From:To:Cc:Subject:From;
	b=mPfOzjt0//hHiEurU70SZjFIT22pv+xM5UOzZbfex0fXQNUWQj7D3J29dOqeufJR7
	 ZoQsii7sKkga2Y8P9Gq75cQDztuVtIs11mJxu1V3HTq18Cg0Flkum82AQCwkaLdsFF
	 NMmFVMi4zuCcY6cO/M3QWOKJ4rBuP4Y7mcCiHrUGXglAMOATW5EV5Wp1AbsEL4h0UI
	 88LSaju/CcOjdRNAtw4E3lTmQOzKeeDWiRaSu5a6OosLahv67zXihWLyIFJ7MzHoM3
	 lTN2utZ9LoygBxhruM2ZGrprNxZ5vmJPgjEJd6BRDKRXLfkRxC3o/05KhOmCu4HQ70
	 3x6e9O6HVOTtg==
Date: Wed, 25 Feb 2026 09:11:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix race between healthmon unmount and read_iter
Message-ID: <20260225171146.GC13853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xfs/1879 on one of my test VMs got stuck due to the xfs_io healthmon
subcommand sleeping in wait_event_interruptible at:

 xfs_healthmon_read_iter+0x558/0x5f8 [xfs]
 vfs_read+0x248/0x320
 ksys_read+0x78/0x120

Looking at xfs_healthmon_read_iter, in !O_NONBLOCK mode it will sleep
until the mount cookie == DETACHED_MOUNT_COOKIE, there are events
waiting to be formatted, or there are formatted events in the read
buffer that could be copied to userspace.

Poking into the running kernel, I see that there are zero events in the
list, the read buffer is empty, and the mount cookie is indeed in
DETACHED state.  IOWs, xfs_healthmon_has_eventdata should have returned
true, but instead we're asleep waiting for a wakeup.

I think what happened here is that xfs_healthmon_read_iter and
xfs_healthmon_unmount were racing with each other, and _read_iter lost
the race.  _unmount queued an unmount event, which woke up _read_iter.
It found, formatted, and copied the event out to userspace.  That
cleared out the pending event list and emptied the read buffer.  xfs_io
then called read() again, so _has_eventdata decided that we should sleep
on the empty event queue.

Next, _unmount called xfs_healthmon_detach, which set the mount cookie
to DETACHED.  Unfortunately, it didn't call wake_up_all on the hm, so
the wait_event_interruptible in the _read_iter thread remains asleep.
That's why the test stalled.

Fix this by moving the wake_up_all call to xfs_healthmon_detach.

Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_healthmon.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 4a06d6632f65e2..26c325d34bd1ac 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -141,6 +141,16 @@ xfs_healthmon_detach(
 	hm->mount_cookie = DETACHED_MOUNT_COOKIE;
 	spin_unlock(&xfs_healthmon_lock);
 
+	/*
+	 * Wake up any readers that might remain.  This can happen if unmount
+	 * races with the healthmon fd owner entering ->read_iter, having
+	 * already emptied the event queue.
+	 *
+	 * In the ->release case there shouldn't be any readers because the
+	 * only users of the waiter are read and poll.
+	 */
+	wake_up_all(&hm->wait);
+
 	trace_xfs_healthmon_detach(hm);
 	xfs_healthmon_put(hm);
 }
@@ -1027,13 +1037,6 @@ xfs_healthmon_release(
 	 * process can create another health monitor file.
 	 */
 	xfs_healthmon_detach(hm);
-
-	/*
-	 * Wake up any readers that might be left.  There shouldn't be any
-	 * because the only users of the waiter are read and poll.
-	 */
-	wake_up_all(&hm->wait);
-
 	xfs_healthmon_put(hm);
 	return 0;
 }
