Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC759244679;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215631; cv=none; b=XySz3T6k/XhAHNX8TYDdeo/ph3iMazbH6dBQtK3xJiX/bkDnE6zAdsY0Yk96VUH7NlvWQDWZIjenZgf9u1viCrWtFwYaPrXBhDDckMKx+uNLD88SN92SjFz1vLBHM6IDc9PtakOW7PO5JitZ8BfeuPXAPCy7ck2cm7Y5YnAKz/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215631; c=relaxed/simple;
	bh=6oTpm/WO7h/xsMs2YERBx7sSkHmWl3zwJ+O9pCTP6j0=;
	h=Message-ID:Date:From:To:Cc:Subject; b=Z8NtC3fDpNRzQNqlmrLwtUY4hH06L+Bnb+2fiogNPtH2caTYtf6ThDnrU6Q2vhmfe32k0won6JroYUoRgD/KqJ/4iS5ck+CJUSxXAvzf7YEmiqwQ57y2oEuOvkzlUxAZvRkLaGFoFLvN9AF2x0ZZ9Ei5vEunjttTP7UKShOodIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPMGPagL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPMGPagL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F00C4CEEB;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753215631;
	bh=6oTpm/WO7h/xsMs2YERBx7sSkHmWl3zwJ+O9pCTP6j0=;
	h=Date:From:To:Cc:Subject:From;
	b=TPMGPagLsE5eqhb1pawAKhc9SABuoPS/N3aRY3H35o63i5VJeMPD1bilmZghVl4Yx
	 30l/++JqAF94cwC1NqB1jkwf/DSne222GlBNjcq+hBi9+YISySUJikAEdR5I1PmbNb
	 tLxPliTqZcxfnRpuE8xR2CPp1ztF4jUFf6g6q89Qr/duO/EmwLw2OfzbjbkxJc1x4+
	 XtslPI3H+VDuih+269X3av6mSelctgXLpILkAHhIWdgCwjmfvTAUdEKHLxxud+Kg4g
	 8w11t72ouGO90opboWKWsO9s1wCK5gZ5u24TBU+IkJVEi8MpJX5ahyvXHdZqrYW/AK
	 1ls5H+ULmSh7w==
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@kernel.org>)
	id 1ueJTS-000000001Mn-227S;
	Tue, 22 Jul 2025 16:20:30 -0400
Message-ID: <20250722201907.886429445@kernel.org>
User-Agent: quilt/0.68
Date: Tue, 22 Jul 2025 16:19:07 -0400
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
Subject: [PATCH 0/4] xfs: more unused events from linux-next
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>


I reran the unused tracepoint code on the latest linux-next and found more
xfs trace events. One was recently added but the rest were there before. Not
sure how I missed them.

But anyway, here's a few more patches to remove unused xfs trace events.

Steven Rostedt (4):
      xfs: remove unused trace event xfs_dqreclaim_dirty
      xfs: remove unused trace event xfs_log_cil_return
      xfs: remove unused trace event xfs_discard_rtrelax
      xfs: remove unused trace event xfs_reflink_cow_enospc

----
 fs/xfs/xfs_trace.h | 4 ----
 1 file changed, 4 deletions(-)
