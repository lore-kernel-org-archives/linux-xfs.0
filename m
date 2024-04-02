Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A4715E80B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712095894; cv=none; b=qav2rRpsXzDvmJxrwuE8r/LB++GqDXOjInpKvL8P7Q1VK5XXceQXEw2NBg3mUd+wtdDEKxmgONRdRFM/pGDVqVTprcobIaOD/4glaEl8ilwQBGujI09XmbX+ezQqla+wcnpl/PSW0qR1CQFBUPkYjSkfFIh+rmut4OH7uwpwdNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712095894; c=relaxed/simple;
	bh=EqJjJX9UfGIB8O2/Dj2VOE18skNN2nB9AQdXxhVBCto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkmFioNgzKUOueUAEC57AqXi/b0dKO1yzxshxAjv4dSfuqbniSVAowoM63a6ZsAqZtvLva24kdnWlWOslyGS9ThSjKob80PEozYSuAd4b6mTFh6nqxmIJma/woiZfzp/9XBmINFEaTUPnGTojhxX0SEP4TbI6bNKKpfBhCDIA5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Gx+BVp7u; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Gx+BVp7u"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e220e40998so32269475ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 15:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712095893; x=1712700693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RU0F6Y0uA0zkAo5HNIG566sm1NWcWPQzQQ03PIGHd1Q=;
        b=Gx+BVp7uEE3O/J+XZ19KkVtlrk1yWYyZL3X27lTXBHNA1aVwjLKaff9x0oNhMyCIHP
         aCFAO7VPBr0xvleDh02unS9G8oU4vdk7Ag2BCyeb9JQasyi6aoWaOY7ngI2N3ZuxU0uk
         sOr/gCwXdyo8YoGoaJcwBrVl3Vdfm62UKhWvnfXLzfu1N+W12s0lxK3dqWdmiznnVKXr
         K8+QglQkFIB2r+k/MLfLvutxC8fh0BKqwlXDXRI9e517L+/SgyOErOPHsnDzD2jU3Inq
         OFzRDbxn+LAcxEjd4asu47ggGaLa+z+Em25zWoHL/zbx+ph6vycbI+RLMsn07FR1dmE1
         gGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712095893; x=1712700693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RU0F6Y0uA0zkAo5HNIG566sm1NWcWPQzQQ03PIGHd1Q=;
        b=YtxjdPrpHncE7d8W9JyFfrzoQxD+l3OrpcdejK6ODqNF/9vUKpA+xLX0jbiZZkP4uD
         VPNjGZuQnp0ySIexWDySeY0YO8T8jDyUkMVAhvsiMTFr/OJbuKkIKynFnOUtrvh2vsCQ
         wGcSVczFadESFqqzikOvTslEniUy1uBx2v8trMyrtJoZpFwcWz9IVsQPkCvErG8jsHm7
         5V4tTSbEGUZfudz9p793zkpk0LDEbkxhN+p4cWK8UfMBqc0nKXKs29apsKpkI5Hy3TL2
         EPsgEgNsaBwuPzG8bVrSX1eQ1V5vfi7aJ9Y5r9FE2gpz4deyeJYNYjclc+wkVFD5DUsg
         l8Ew==
X-Gm-Message-State: AOJu0Yx+HBQ4FgpVYp9Ks4LN9vW0jxLY0z3us0LnUi+jV6ZV02L4OpUG
	QHH7QAjvk5JLGcIbVE5AWZO5hx3RqJcYjrEetb8ySzGe/KaXN6sfz0I0NdUp/79kB1EeKHsd3dz
	0
X-Google-Smtp-Source: AGHT+IFOYb19i2KHydrOcxWjLbztdbqZPORTlM2kdna1RUUNBYSmnU64udRxynl/gJdAQdi/wGsDaQ==
X-Received: by 2002:a17:902:ecd1:b0:1e2:7c3a:835d with SMTP id a17-20020a170902ecd100b001e27c3a835dmr1137179plh.8.1712095892446;
        Tue, 02 Apr 2024 15:11:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id kg4-20020a170903060400b001e01c3dd1c3sm11644633plb.66.2024.04.02.15.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 15:11:31 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrmLq-001osL-05;
	Wed, 03 Apr 2024 09:11:29 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrmLp-000000052qw-2GP6;
	Wed, 03 Apr 2024 09:11:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 2/4] xfs: xfs_alloc_file_space() fails to detect ENOSPC
Date: Wed,  3 Apr 2024 08:38:17 +1100
Message-ID: <20240402221127.1200501-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402221127.1200501-1-david@fromorbit.com>
References: <20240402221127.1200501-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

xfs_alloc_file_space ends up in an endless loop when
xfs_bmapi_write() returns nimaps == 0 at ENOSPC. The process is
unkillable, and so just runs around in a tight circle burning CPU
until the system is rebooted.

This is a regression introduced by commit 35dc55b9e80c ("xfs: handle
nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space") which
specifically removed ENOSPC detection from xfs_alloc_file_space()
and replaces it with an endless loop. This attempts to fix an issue
converting a delalloc extent when not enough contiguous free space
is available to convert the entire delalloc extent.

Right now just revert the change as it only manifested on code under
development and isn't currently a real-world problem.

Fixes: 35dc55b9e80c ("xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 19e11d1da660..262557735d4d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -735,19 +735,13 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		/*
-		 * If the allocator cannot find a single free extent large
-		 * enough to cover the start block of the requested range,
-		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
-		 *
-		 * In that case we simply need to keep looping with the same
-		 * startoffset_fsb so that one of the following allocations
-		 * will eventually reach the requested range.
-		 */
-		if (nimaps) {
-			startoffset_fsb += imapp->br_blockcount;
-			allocatesize_fsb -= imapp->br_blockcount;
+		if (nimaps == 0) {
+			error = ENOSPC;
+			break;
 		}
+
+		startoffset_fsb += imapp->br_blockcount;
+		allocatesize_fsb -= imapp->br_blockcount;
 	}
 
 	return error;
-- 
2.43.0

