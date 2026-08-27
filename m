Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F66929C328;
	Thu, 27 Aug 2026 05:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808765; cv=none; b=DUFPBFEkaj2jQJjDNlVx72J05JW8oCiN4p2bVmL77+sqNNaagoMhwlekxF2f9tSACxcYefah2KrD/QF9QOCQelyKSc4xvnwso8P3Vkoq/CPoey5xaTi96aAoPPt1WP2oDROXujf9tnac2NCf9bDmclasjR7+Z0nYpTGUbCm4CCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808765; c=relaxed/simple;
	bh=8DJIDphcaq9ZiLpwjXdXmvF32L/wDYccj3hTDRZ5YwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K1RRw4gqXDuy7F834iINemKo6NT4y1X1TEvt5qO5nBiok0+dIbBaI0kVr7e5KDUkEFB62a9luQskL9suCgujxFBYlIPtcKA1aaEgHW3GQC7dBuc2rRBRbTqg7TPmF5Dyi4riZ7IpxppcLUi2jpPGcv3jK+ty0TRJ/LL7WmBUi5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXpHwM3q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXpHwM3q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D147E1F000E9;
	Thu, 27 Aug 2026 05:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808763;
	bh=GmKm5SsuyGSDcmD7x7QKLCR3tRAzcEQbfyaDkW6y80o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=RXpHwM3qR/egKsveIFm8FO5A0NYgvhNqHuF5A1VmfESL2rtCb/S5bMEdjHxRCKKX6
	 6flAaP344t/+q4E1msxWkoMO06fWOAsDsv8R5jBc9hzUJkBDk851A1jiqWUpnagn0E
	 vAxb0ogGuUhc0uLkLPsIVVOSfdFyjaBqgnI6xuDQZ20FUiRSE4p5mQu6E9d5qfZA0b
	 pGoGw8A2S0DYcBt/B4J9+GxGOO6OkqlDGUaqNWpx/f06XdmpK6Jas0N1qFklXjoA0a
	 ZzTkgBdFUEUBVdEU0xM2U5nsp/ibBtKVty5RYDvhXtkJWNZsUR9CFqQH9OMWnuz4CM
	 pNUdlbZXblGCw==
Date: Wed, 26 Aug 2026 22:32:43 -0700
Subject: [PATCH 1/7] xfs: always set xfs_healthmon::first_event when inserting
 at front of list
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640604.3528467.14704360442661766846.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
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

