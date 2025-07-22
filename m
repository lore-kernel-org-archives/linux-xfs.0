Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6F61F1302;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215631; cv=none; b=H98FQuy93xOeNWxciZWhphTIdGdVMqQkiOnWPZyjfir4XLxxyM9JY3GIgSl9Rqp7F64FbDf7E3F7mjscekkyZfBaJZDnkZLfCZyj2z5LRuBEQXVTewjx612V0eIa2CdVwYRlEtxKgGgfTstizbqhT3NIgxUIhzhTGaUUVrMlAY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215631; c=relaxed/simple;
	bh=2+ucdz0UvLWRzcrIfv05mAP30czo8XWD8AwF2X92bsg=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=sHtM1F8IWWBBZuJtjMBMUkTZjnOG7+6WiX+92phm2Az/pe2vYSSygUXukrCCkeoOyApYtbbKud0eYjSCxJ0giSlcaLlkmf3+8K3S5BqImGnxW8s+KoaoGJKjsfOcdyuqjO8QGiBhAC9YbF/mWRwJEhIOLLT4rDCJsStyplM3BgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hj+XC8dE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hj+XC8dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3E3C4AF0C;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753215631;
	bh=2+ucdz0UvLWRzcrIfv05mAP30czo8XWD8AwF2X92bsg=;
	h=Date:From:To:Cc:Subject:References:From;
	b=hj+XC8dE378EYoJCcn/P65mwxbTkjrfqcJ8EH7WaAXiVJTqu5CwzSXW8WUnBi8zVa
	 IgU9yyPn0obfsxrP25tEerLtbDc5fBRSuEQhHpJHjih+ozF1WfAqos4LYWdtEWhyos
	 6aH3zhgLrM8TwjX3zZLuPRZt/KFv1wszlocVm+DTmfNQlcBbDSfz/3ESU10VnTo44/
	 TOZPw+YE8PJUQYYflUJwiTsxgvlGy8KqxDYBUj6ekFvhDolE/JaFm3uAC/cTYAKePp
	 R1lHQxh4/CZR7fE6j5ca8Nl/ffz67SWu0nchJATEZvsqtng0gu1UCxJPBIv9j++A37
	 BnVsXLEKslneA==
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@kernel.org>)
	id 1ueJTS-000000001NJ-2mFi;
	Tue, 22 Jul 2025 16:20:30 -0400
Message-ID: <20250722202030.515004324@kernel.org>
User-Agent: quilt/0.68
Date: Tue, 22 Jul 2025 16:19:08 -0400
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
Subject: [PATCH 1/4] xfs: remove unused trace event xfs_dqreclaim_dirty
References: <20250722201907.886429445@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Steven Rostedt <rostedt@goodmis.org>

The tracepoint trace_xfs_dqreclaim_dirty was removed with other code
removed from xfs_qm_dquot_isolate() but the defined tracepoint was not.

Fixes: d62016b1a2df ("xfs: avoid dquot buffer pin deadlock")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 10d4fd671dcf..22c10a1b7fd3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1396,7 +1396,6 @@ DEFINE_EVENT(xfs_dquot_class, name, \
 	TP_ARGS(dqp))
 DEFINE_DQUOT_EVENT(xfs_dqadjust);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_busy);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_done);
 DEFINE_DQUOT_EVENT(xfs_dqattach_found);
-- 
2.47.2


