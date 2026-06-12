Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF233B3C11
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 12:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266256; cv=none; b=pdnDmR23G4DZcxETaAdesMgzoVoQ0bvIdw/J/I4w1lL09vQxUMW9HEO5eQQ/q4ZH5xkKrTaZn2oK0ADHH0Pn8GxSKz0EA9rfF8gsUiGvcyr+s1UbRHajHj6UBGFqFmnuoSSEWGLY0bMyZ+KERp0jsRnGJCeB8If4qhbnOewN+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266256; c=relaxed/simple;
	bh=HZ9Ks0XPk0YTR1RMBY9S7/jI8tTrBBoWbjsfOfflUkk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g4szdn+2vM73TEuhXtm2byWQo4gskKnLEp93n89zgwm7ohhjd3JFoHPlhsWTcfVZ5hwImchsp3HlNjvY+jV4MlPYdjufGdll7+dCL/xvZuZoFMOADe7++68PxWCS+aYcnUncm/IjwS953sbL9mENTOicsDwgV7ekVnpJaDuEh7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TUf2NX/d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TUf2NX/d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781266253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bAG/aaleL+KGNyeyu+ILijGdPmXoI66HYof8HAvsvrY=;
	b=TUf2NX/dH0A2qlAmsVR3POew2TeyrpedRB57yNnrAKObnVYKU7Rp/PkHYdhAKADbIN05Yd
	vMrJ5ySFJSYKYGquasO0zYdlrWzry9GEdof88S2SuR2FEdSoeZXyjHr6ZI3Embc8QScHFM
	L8uYAxpeYDbDd/68M8/pnAV8p0IE3AA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-3v5IX6EUPKqTgzN8ju9jJw-1; Fri,
 12 Jun 2026 08:10:50 -0400
X-MC-Unique: 3v5IX6EUPKqTgzN8ju9jJw-1
X-Mimecast-MFC-AGG-ID: 3v5IX6EUPKqTgzN8ju9jJw_1781266249
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CFA21800A7B;
	Fri, 12 Jun 2026 12:10:49 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.93])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E1E33008B34;
	Fri, 12 Jun 2026 12:10:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Gregg Leventhal <gleventhal@janestreet.com>,
	Eric Hagberg <ehagberg@janestreet.com>
Subject: [PATCH 6.12.y] iomap: don't revert iov_iter on partially completed buffered writes
Date: Fri, 12 Jun 2026 08:10:47 -0400
Message-ID: <20260612121047.397754-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Gregg reports that the iomap retry behavior for nonblocking (nowait)
append writes is broken. The problem occurs when an append write is
first submitted in non-blocking mode (i.e. via io_uring), partially
completes before hitting -EAGAIN, and then is resubmitted from
blocking context.

The specific problem is that at least one iteration of the loop in
iomap_write_iter() completes in non-blocking context and thus has
bumped i_size. The next iteration hits -EAGAIN, reverts the iov_iter
and returns. io_uring retries the entire append write from blocking
context, but since i_size has already been increased, the data that
was partially written on the first attempt is rewritten at the new
i_size. This is essentially an intra-write data corruption since the
data written to the file does not reflect the write from userspace.

This problem is already fixed on master as of commit 1a1a3b574b97
("iomap: advance the iter directly on buffered writes"). That commit
was primarily intended to clean up iomap iter state tracking, but it
also happened to remove the iov_iter revert and thus accidentally
fix this problem as well. Without the revert, iomap will commit
partial progress internally and loop once more before it more than
likely hits -EAGAIN and returns partial progress consistent with the
inode updates. This means the blocking retry from io_uring will pick
up where the first attempt left off at the current i_size and
perform the remainder of the write correctly.

Cc: <stable@vger.kernel.org>
Fixes: 18e419f6e80a ("iomap: Return -EAGAIN from iomap_write_iter()")
Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
Reported-by: Eric Hagberg <ehagberg@janestreet.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This relates to the discussion here[1]. Refer to the link for further
details and the custom reproducer. Since this is a stable-only patch,
I'd like to see at least one ack if possible from an iomap developer.

Note that this patch introduces an extra iomap iteration in the write
iter path before an -EAGAIN will return, but I went this route because
this is current upstream behavior and I didn't want to introduce novel
behavior in -stable, as trivial as it might be. This was initially
developed as a custom/selective backport of 1a1a3b574b97, but as it
turns out this is also effectively a revert of commit 18e419f6e80a. So
FWIW, this is somewhat historical behavior as well.

I plan to float a patch upstream to fix that loop wart soon. That would
seem overkill to fix in stable to me, but if it does prove necessary we
can revisit something like the custom version posted in [1] as a
stable-worthy variant. I'd just prefer to only do that if/after that
change proves acceptable upstream.

Finally, note that I'm not intimately familiar with -stable process so
I'm just sending a 6.12.y version here. Earlier branches can either also
include this, revert 18e419f6e80a directly, or I can post targeted
patches if needed. Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-fsdevel/CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com/

 fs/iomap/buffered-io.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0178292c1864..5f885286b2f4 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1037,10 +1037,6 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		}
 	} while (iov_iter_count(i) && length);
 
-	if (status == -EAGAIN) {
-		iov_iter_revert(i, total_written);
-		return -EAGAIN;
-	}
 	return total_written ? total_written : status;
 }
 
-- 
2.54.0

