Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BA480C02;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215631; cv=none; b=cMSwlB0h0+DCeSipyy6IPD+sgSbqLQc2Kbm1xEjXwTTAhtzs0arRRK4rH8fusPwwuN5BjxHoAIPqKGiL/errlbEVmOjhizxB4aM5dP/uo9nZ10zOcm5W1Xij3IrmU2UH8YHH3f3rOju0oGen+7gf5+FRO5xB1iDCMtCbb1KfsBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215631; c=relaxed/simple;
	bh=z72uWazKkS2fqyE92fEFcTlRZQYXZwO/VsWMIsYj9vc=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=MXKuOwbWnMhac8IfiZOBX41UgYgfW+FdaSs8Bew9vLZlke5hl9zwi0kMqzibZs4I0E8YD+n1wAOaIE8IHEhdU9HYoDMAP/RwMUUOc0Trn3NebBTJOTuWa/a6TW4a8cwXqLZpOWAKmNl08OLs6yLPwxWs/Jfh9XYPzYTaFmlhb94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4ts9N4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4ts9N4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E061C4CEF7;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753215631;
	bh=z72uWazKkS2fqyE92fEFcTlRZQYXZwO/VsWMIsYj9vc=;
	h=Date:From:To:Cc:Subject:References:From;
	b=g4ts9N4qPIqoE9QyhTwU4lAtBxfmJsK8keOvp2SS6qPIV7P1F5lQ3gOaR5oAtfuEW
	 WvOAWn8TJC9ZarUmblAcjSSJuplFB4PLhgf9DDkP+0Z0U02MOOKbCiT004J7YJjPme
	 7I9CUoXbj16QXRX6lKoZbx80KJ6erdpc2NGVHNSGJH+JsE5bW8i1TRXX5k2jNyiM0M
	 5YDKjnyWzG9GAb6C5aOvhEh6cEyidEp7ki0Ig8NUQw5xftOQYYcVloM4qP3KCIcuC/
	 qwx1zxOXbhc7aIgSZHGwAdBpMoq9xhDsl2F+FlKS2o9YvjGMKwqS95RpdyEl9mEbmZ
	 xNaudiDW96N6w==
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@kernel.org>)
	id 1ueJTS-000000001Nn-3TTQ;
	Tue, 22 Jul 2025 16:20:30 -0400
Message-ID: <20250722202030.683039393@kernel.org>
User-Agent: quilt/0.68
Date: Tue, 22 Jul 2025 16:19:09 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Carlos  Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/4] xfs: remove unused trace event xfs_log_cil_return
References: <20250722201907.886429445@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xfs_log_cil_return was added but never used. Remove it.

Fixes: c1220522ef405 ("xfs: grant heads track byte counts, not LSNs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 22c10a1b7fd3..4ce8689ed839 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1600,7 +1600,6 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant);
 DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_sub);
 DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
-DEFINE_LOGGRANT_EVENT(xfs_log_cil_return);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),
-- 
2.47.2


