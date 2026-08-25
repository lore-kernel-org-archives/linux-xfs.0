Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391A9385D99;
	Tue, 25 Aug 2026 05:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636174; cv=none; b=ryddpQtB3MW1urPJhrn5vAlBnQHX4ZPB7YjRvl9lbvR5ScX+rLke1Uyx1trWk85cQu1BlYwUJFEtEhbX7SyMqHC2n3YrCbpPKebgide8eusXZM4OS5lok83xYJBQAKXGXiebtqj/I79b5HhAKmxcv80jGfGWuJHFBCA9unp6h4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636174; c=relaxed/simple;
	bh=fdEmxv7DXFCklz3f7upZ3rc1flTJoJsFdXo4pAahld8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cf4UOgQIKK9nAu1an5XP33Q3ZObM1VHlOX4YgEVuglCfBDTjKXAD+ih+Fb0GdhSbeCUE2xIB4abu1SMbr2WTKDdiuSO9qZ+BrihKekNrmxQd4GIAR+u84fFg0SUnOUl8plva7k6zfMGhSd4RTCgyauhxk39uxEEliIoD81SplfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZvFF8i1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZvFF8i1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 101751F000E9;
	Tue, 25 Aug 2026 05:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636173;
	bh=5Zvs4fjrjxpZOSlIYp/XcJ/n5omIo22NqOUFYtQa/ec=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CZvFF8i1qYv9+YTBvx/EDauDLkEZEpDyx57Mygs/pbpLx6i19fMj2GbOzgtv4fImC
	 6ENbclCTQMG5pgXCByMhfGCJf3rQeGJRMaPqy7Almj6pPAPv2N9ovREHPypN6Kyo4q
	 3a2AK/aChyglhX9Xqd2F68upAKGm2QnrPhNVvUD2ih7Eoi792/dL1XaAgBIuwJUYL9
	 1PUZMPE0ZWlp0vhptSrlZ4r/5BUkwmzOIWTkcxuvlsUWqI2hwagqDMSJh4lq4U3PIO
	 pKWuNKY8RpZCws0T+Oj9gox51H8ZUyew8sAL5zZjREhM4QCjAwdqK+4D3zreVfkhdv
	 ccanvf2GAYgIQ==
Date: Mon, 24 Aug 2026 22:36:12 -0700
Subject: [PATCH 1/5] xfs: always set xfs_healthmon::first_event when inserting
 at front of list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760941102.944364.11828316232110118627.stgit@frogsfrogsfrogs>
In-Reply-To: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that __xfs_healthmon_insert purports to insert a
xfs_healthmon_event event at the start of the event list, but neglects
to update first_event to point to the unmount event if there were
already events in the queue.  That results in list corruption, so let's
fix this problem.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_healthmon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index d8b95af33a3e9f..166ef0d5864486 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -276,8 +276,7 @@ __xfs_healthmon_insert(
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
 	event->next = hm->first_event;
-	if (!hm->first_event)
-		hm->first_event = event;
+	hm->first_event = event;
 	if (!hm->last_event)
 		hm->last_event = event;
 	xfs_healthmon_bump_events(hm);

