Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477E44071F3
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521563; cv=none; b=NNtVlLnXV8n5wny+oHB/xkD+AKbUDOSnzSIn0sjWnJiE/ZXsQz7gTO/HQvjfwS7yRGzFBY1YGcT5SWMOlxFK/d3/hUHKen8eiOgooCXXrsYnxFla3o6VAlRj3NEIjm0d1fco1lG06REw+VcQJITVD7B8q1Z4tTHcciah9dWItrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521563; c=relaxed/simple;
	bh=h+EpWbfuFTLH9Dw9Edh8qJaUrrZ9I7cE25Gh0EqVGos=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PxFFKqDjxa7zxq5Q2Q/TwDqKw33W55Uv9JJZo1ZeVnogqAUeyKaFPfM8ZUM5aDeYB0Y9kJJEoMPVQc80w7RnY+kYmV3WjAGYMq2K1e0nEjxK3FSHRY/HLfaJmGKxQyFYwIsJVrSmGeIUx0OSsriE5XENRLcEgdO5OF0AqLUbfI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXu7diXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXu7diXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8951F00A3D
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521562;
	bh=uF+ejnWBenc8DAzEb+alOiwBc4ajsB0AzQRIbvghkI0=;
	h=From:To:Subject:Date;
	b=jXu7diXTQn37MZN0aI94DfFBcBz0bqwjj24xCSwK6UzzOII10YZ4AiibCXRTwrMxa
	 aWi2x5WcUc1HFIqwN6KHQ86rqVjJaQri2SV5/f2CIpcglkITEGyHm6gaye6/39sdVk
	 81pq+mnlyal6nPRJr0VU0S8DkhcKjByfeFBkHj7p/DaS/YvRveDEPjOlsErwh4LqK+
	 nZJdmZhyZ/siCbxGY/MpZUmchNTlXHHt2V5/OXOTl37xjjymWfp2zfBTiQeWOYzPVh
	 Kfhle0Lc+/B+ItCOU8DrHHg5wJmP8z2Tjk6UASovFuckzoY60Ny4sGnjOwFUon/IUe
	 +HBfLHZBzOgag==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/3] Log transaction cancel error codes in the kernel log buffer
Date: Fri,  4 Sep 2026 13:32:20 +0200
Message-ID: <20260904113231.1408890-1-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hi, this is a big RFC which is just compiled tested and has the only
goal to get opinions, please don't use it...

Once in a while we face some sort of failure where a transaction gets
cancelled in the middle of an IO operation and it is not always easy to
understand why.
One of these reasons is when xfs_bmapi_write() fails. It can fail for
several reasons and sometimes we get to start a guessing game on why it
actually failed.

So I thought it would be useful to have xfs_trans_cancel() to log the
exact -ERRORCODE that caused the transaction to cancel.

The reason I used a variadic function was mostly to make it a smaller
patch instead of a long sed-generated patch which would not make my
point, although I kind'a liked it :P

Another approach I thought would be to add a t_error field to the
transaction descriptor and report it via the tracepoint, so callers
could opt to set an error code or not.

Does this seem useful to anybody else or should I just abort the idea?

Cheers.

Carlos Maiolino (3):
  xfs: add xfs_error_report the ability to display an error code
  xfs: enable xfs_trans_cancel() to report and error code
  xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel

 fs/xfs/xfs_error.c         |  7 ++++++-
 fs/xfs/xfs_error.h         | 10 +++++-----
 fs/xfs/xfs_exchmaps_item.c |  6 +++---
 fs/xfs/xfs_inode_item.c    |  2 +-
 fs/xfs/xfs_iomap.c         |  2 +-
 fs/xfs/xfs_log_recover.c   |  2 +-
 fs/xfs/xfs_trans.c         | 12 +++++++++---
 fs/xfs/xfs_trans.h         |  8 +++++++-
 8 files changed, 33 insertions(+), 16 deletions(-)

-- 
2.55.0

