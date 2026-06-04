Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFE32253A1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553295; cv=none; b=k7Xf6QU9wPKJ0V1sC6ZOueRnjJNAerwg1Cys8YSO6P7GStaA9kpICkBaq0RgymGW8IYRXVcxOLYKPKxjWu24M1HEiKVEkDuVlXrLHVds4BkE89pq+iSBjV8Y8me/2/qX5JN0HtQZspVVQn6vj2l5Tm6QLTdwPjw6kYoYnhAEnTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553295; c=relaxed/simple;
	bh=kuEzsj3qIJva4rCKBSpSon2J4nRUH6BvKBLguHWth5k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFn+AQptkngRK7ncAJ9xDXMoAP1kPW85c3b5MO+d22TbE39sbAyKhOQXkhuwNjIikkidQjgHOqzTpwN7ps4NCQvkUVDdLeAx7zj+xEYIpdXdOjRsFFhDaLyuO/dNiBowZY9X3691p2CtTnjt+y3mgakjfFIaqtrfuhHrh5a0lHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTUZE2zE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTUZE2zE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5DB381F00893;
	Thu,  4 Jun 2026 06:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553294;
	bh=qBEboM5kNVMCZz0a9qA3TKg210w77zL+2XgkWtm2HTg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gTUZE2zEgOTuWHOE8lFYy9rRUOGgQQt9djKZuoz+YGJRrrGdZhcKmpZ8lNtV8aGR6
	 JilIQJ+mbcInUVifi/bo/MYRQTByZl6WmcI8I563X+NdYfTIdy2ikYKHN93M4J5dHc
	 bf5oiE0aeQebeJxxJLYig1oAiPa0DUQBX8QhGMh7SYqgXMPE6vEK+BWUJwt39A/sT1
	 vrc8EyllMcD7uFxBp2tH9T33yaL0l3eU1WWItsHm0FxlCEZc8gPLNYSq8C2x9c93VY
	 fjJUBibqIShxU7OXfnfOt9pAgufFkhK2m/Sjpl3Sg4Dg+aL9NZqERZ2V016TmJUGZk
	 AyZRDzHQqyH/Q==
Date: Wed, 03 Jun 2026 23:08:14 -0700
Subject: [PATCH 15/21] xfs_scrub: don't return garbage value from
 bulkstat_the_rest
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303383.2608728.572212891515924769.stgit@frogsfrogsfrogs>
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

bulkstat_the_rest returns an inode mask, but Codex noticed that we
carelessly return an error number if we can't allocate a bulkstat
request.  Fix this by returning 0, which forces the caller to singlestep
the rest of the bulkstat array.

Cc: <linux-xfs@vger.kernel.org> # v6.14.0
Fixes: 7ae92e1cb0aeeb ("xfs_scrub: try harder to fill the bulkstat array with bulkstat()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index bfd4abc44b56de..ab5cf393327f1a 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -152,8 +152,13 @@ bulkstat_the_rest(
 	error = -xfrog_bulkstat_alloc_req(
 			orig_breq->hdr.icount - orig_breq->hdr.ocount,
 			start_ino, &new_breq);
-	if (error)
-		return error;
+	if (error) {
+		/*
+		 * Couldn't allocate memory for bulkstat, so we return 0 and
+		 * let the caller single-step.
+		 */
+		return 0;
+	}
 	new_breq->hdr.flags = orig_breq->hdr.flags;
 
 	do {

