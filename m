Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD633D564B
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553233; cv=none; b=Yb5rASumvByszh81+hDtwiRBl8+g3Vwu27Gb9RLfejDmh4RzOi+7ZOOxupeGe8cksxTx8CCmO0RM+1FaB28mCmYl/93xQmJCMY4+dG/F2J+jifrJJGnoGXm9hQiMdwmTB5n45O00QdgDnevziDjAga2iOh8ZClMJnLCRtHHFufM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553233; c=relaxed/simple;
	bh=/S6064qy+G5LGXei9qxZrkU6lgnXb9eSA4eScMkGWms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V7e9oYNaIU8EE868lOvsLInTOEG8tez6tg1zbtuGLGX+VsuK+GuxAedkLyYv1rjwD2aXwOWm4T8o4k0WUixp5JEReM4hgKoW2UXG9H2dAPkzUCbrFQDm7F66Zz9OJw6KrSxc+i8NAhNboXTf1cilY2sJqO8rBfPD880nqTvlg+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9ycjc80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9ycjc80"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 49E811F00893;
	Thu,  4 Jun 2026 06:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553232;
	bh=2iVaL5G/eVstkXVrRnnsWRnnuAU0RMgUYKo0Mm8yP/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Q9ycjc80b+qBUapp/crUhOi0YvnBgo57mtSLGzWZO9B5ysDUsD8t5XMSv1qpuJVi3
	 JWHup7vo2qBuGKGryuIEtRreuzi1iE5d9p/olBrtTdQaQLs0T6UjlTbubfLu5mHk6B
	 FPM0p/r259+7puaIquTqKPJXsgeRBzfGYscta+e2sSkXUVAGP03cN7BHcJQCSN6ErZ
	 m2EuU3fGx4V7+dIo/DZmhK6xcA43oJZM0TlY/1lqq+aWzXqBKm8JOqr1i9B23FKsCY
	 yxo8ReHGsPCfXMXwwVKc6xccmwbY+AI6DqzAUcSUnwZJj5vKqhK6j2Jf5tpsaisiXI
	 +4OUQQyC6kVlA==
Date: Wed, 03 Jun 2026 23:07:11 -0700
Subject: [PATCH 11/21] xfs_scrub: return SCRUB_RET_OPERROR if unicode
 collision detection fails to initialize
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303312.2608728.7622814423707470375.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we can't initialize libicu, we should report that as an operational
failure via exitcode instead of "success".  Codex found this one.

Cc: <linux-xfs@vger.kernel.org> # v5.11.0
Fixes: ff8717e52b7364 ("xfs_scrub: load and unload libicu properly")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index aae24ec83c1c75..80b56f8baef611 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -749,6 +749,7 @@ main(
 		fprintf(stderr,
 	_("%s: couldn't initialize Unicode library.\n"),
 				progname);
+		ret = SCRUB_RET_OPERROR;
 		goto out_unicrash;
 	}
 

