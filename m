Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4438038758C;
	Wed,  2 Sep 2026 05:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328003; cv=none; b=kfC/d1kjtxMEU3xn86YbTDBBHnbVkwNY9GisuDCpZ+/bcx55Sbt2BFIh0qJcQ7vYgX0D66hcbLGyS25YIDrdUjHQiBqHz0UwVNTDjm7pNtXS9dEMoM9a/CVDV4VD0a/zmU8S3ob3vCzS1EkA+WbsUTajTmoP6aDXFdzc3u17zMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328003; c=relaxed/simple;
	bh=nVpF4wyG+/JhHxAtTERbbN7545dDGbp7Kb7rMcJY1mM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GX3y5O5DMVdbzl6yUkGAxE1KJz6YDEzD1WZvfs0cZS6i0PKZtIJXnyL8yzRh4qccVKRQubO/S0Y3b1niy7E/UNYw1EMWFNTJxZDPtMJkRyl7MG0buebAm8nzZt/n2NpetjTdobQtDhKELUpkCQpCprW8zePbBF8KlvR5Dh5rIJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHT+O2E4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHT+O2E4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B40331F000E9;
	Wed,  2 Sep 2026 05:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328001;
	bh=brjgHdSwNSdwpswBRqNZakL3E339/j8n7QZs7FYDgL0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UHT+O2E40AQ+w672zWZCnFi5aTiaJw3Amby6yHUUFbWy54cYNDeDHLHboeNr9QLz2
	 Sygq7BPPdJJwnVGwek6PAJiKWTe95o7szVk4wsLTNAFtWMZm9305NfYn5bS4pGFWJy
	 dJA16FCjtxkdPFh2eux9FA/Rx9orOQeuD1gBhzrrYAClxEuAp3Zl5vuhhk1p0Q+sXL
	 81dDMMCI/A4bj3yNfTsjdC5TJDk5arS1zwqe66WBfg2PAHKUKh5DHoH2p9uVMl8t+P
	 ssUTJt88OgDEVQbFEhicRpuA9ClighUKQINF0qbb5bsgFHrNd0aZxqFPVwdPA7HP0n
	 qLOL0bpCqeBDA==
Date: Tue, 01 Sep 2026 22:46:41 -0700
Subject: [PATCH 1/8] xfs: always set xfs_healthmon::first_event when inserting
 at front of list
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750287.3507776.8244145130516180990.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that while __xfs_healthmon_insert is supposed to insert
an event at the head of the list, it doesn't do that correctly if the
list isn't empty.  In that case it *should* make our new event point to
the current head, and then make the head point to the new event, but
it doesn't actually update the head so we never see the new event.

Fix this by always reassigning first_event.  A subsequent patch will
clean this up to use a standard list_head, but I felt it important to
call out the bug fix first.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_healthmon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 3ae5f4496ad1aa..a4efc084a8fc0b 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -278,8 +278,7 @@ __xfs_healthmon_insert(
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
 	event->next = hm->first_event;
-	if (!hm->first_event)
-		hm->first_event = event;
+	hm->first_event = event;
 	if (!hm->last_event)
 		hm->last_event = event;
 	xfs_healthmon_bump_events(hm);

