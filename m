Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BD12857CB;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215632; cv=none; b=ZI1xqtbGqon3UpymqhyGh/zuaDpzFRIuJVJ+w1fBXBIxR5nm2F8jEfrJZeQNwA+plOV8EqWdtW01BNnD73xHZTxx8oR6lUmtbPjP69TecNRO+QqvSMtLhrQ+FgB+JxYGGh0vgRZIB+4QCLV9Rh7Cx4VNJPZ1/JBpSLb7oj7O/eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215632; c=relaxed/simple;
	bh=GLkD5uBnrlvasC6+bn4FJFEgenUIlTgvQVb/gHpB4Fk=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=oitcWtoZe0KVTMlW0hIeGp169mVlD47MFIHXEUaaNMLPoar/YbTQ+1Bg3ae9qQRPR4SwkUAxmk/tSMi1NvUlfFNm0jgqFv/fwkl0opx0N4PNIWtspg95CqSDAdm4KbEB5VZx0CaFDpDiLqoVqvGBRj9bt1+zyjOeG8EJBUUtbE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEB3uUXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEB3uUXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70CCC4CEF4;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753215631;
	bh=GLkD5uBnrlvasC6+bn4FJFEgenUIlTgvQVb/gHpB4Fk=;
	h=Date:From:To:Cc:Subject:References:From;
	b=WEB3uUXtNP3dxI7cLcZom5UjIey0owZwYU4zZVChLrCQRxRt0e2qMuOxKQLhYu/tE
	 MGv/xybVpT3+R3bPR9xKa3Ij08yoE81JyQntY4mITtPt07oo0waYeNwcxql4Mng5lr
	 yBW94rqwHgS2qxRtFal+hbw/pGwUdRBaGFqwYRh9KX0Mp6TF8dYMmwQR+39+TWRIij
	 eQWqiyRtMrGg214alLBfaVJZSuD8ypkxvIZ5XZV5kUJdUISLDSKd/JonOe5+cIuZoI
	 WtN82cJaAS5vMXC8UaJQa5AU8ZfTVhu/v8a4psH7q5et79ZsHpE0+vX9ilQAc+hZ34
	 TKmrLf7j5UDig==
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@kernel.org>)
	id 1ueJTT-000000001Ol-0g5u;
	Tue, 22 Jul 2025 16:20:31 -0400
Message-ID: <20250722202031.012385530@kernel.org>
User-Agent: quilt/0.68
Date: Tue, 22 Jul 2025 16:19:11 -0400
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
Subject: [PATCH 4/4] xfs: remove unused trace event xfs_reflink_cow_enospc
References: <20250722201907.886429445@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Steven Rostedt <rostedt@goodmis.org>

The call to the event xfs_reflink_cow_enospc was removed when the COW
handling was merged into xfs_file_iomap_begin_delay, but the trace event
itself was not. Remove it.

Fixes: db46e604adf8 ("xfs: merge COW handling into xfs_file_iomap_begin_delay")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1061992da144..e1794e3e3156 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4181,7 +4181,6 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
-- 
2.47.2


