Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC12A14A4F0
	for <linux-xfs@vger.kernel.org>; Mon,  2 Mar 2026 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472718; cv=none; b=SwJQ58IfidmHPi1zSlNxbkKtw8gOR3WoTLF3Xg2Z2O3glcN3QRPfZBpINCjS85JSxBwAF0eIAAZLtbLQEsL6UezOEevRtgVj+SIj+0kQtmdBGVMATWoZoG+rsRwMa53P1xf+jTzmME2Rw+J+uGfXI46CdO492tWU/qNnTVhR5X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472718; c=relaxed/simple;
	bh=+vGlKftRxDzQ7xvAXQF1Z9rfH31tRa8cIzL7fRn5Vqg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=d/QLdE7e6M/jg8wAjJBIlW+5u6CVKbVrlpgVErmGNbwTNp/5yCp3Hr7z9ZTWeerLj0jeVNe0lTr2jtjy6jfj6cQtk5E15DT/l470JGGNbKnxfoSvRZC2bPaII2VCZs0TpP6hJIDkZ/hTlDBNCGHPcrIqpIHZM+2ZEfgFt16iyYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hm2gYxNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hm2gYxNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF5C19423;
	Mon,  2 Mar 2026 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772472718;
	bh=+vGlKftRxDzQ7xvAXQF1Z9rfH31tRa8cIzL7fRn5Vqg=;
	h=Date:From:To:Cc:Subject:From;
	b=Hm2gYxNEFAjhCHGpMgOQnawJeQADyD3rCeKlD/fdkuFwCj4mRrq8DAo6TDc8NDHB0
	 jrq7pATmcrJJ6yn3V5MGdKYP1xAV2xWSc856iqZpqLwEdfXdc0AfF3wFAtucszgpec
	 dbIwl5uyFWkeiqQuq+LO62ps28DCq4qxwvprF7akVe1b9xaatXsTz8M1WmgDGz45GF
	 DiSZDQqq8pVTwSSoq2bKNZ4Bl/wz3s/Aadv+77AJNY47M7Ou8qJnjgGcPU7POHsaP7
	 SZUAR78F6LD3LGofdbUGPHW/Ps3wy3AWX+L+Nuo5PLmEySXfoXz+LXBwQ1lBHrLBHv
	 HjKIdX4r1k5Vw==
Date: Mon, 2 Mar 2026 09:31:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs: fix race between healthmon unmount and read_iter
Message-ID: <20260302173158.GA57948@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: add review tags
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
