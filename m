Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519980;
	b=1OhBns8X12JMo0M5Z+6h7cIjWyCY2yeQDYTPV9+lC+ktsGOEsaBC/votT6MFBZApt3T4
	 Uxv0ry9Is93omheP+oJZDn7xOrZ6ecqeuR5umBkRsefqyOvApbnHfS3zSBmLRSnCVr+Uc
	 0Wwi47/opnpgDK4LGRMbdFubwqD2uMUDlZAJLI9iAMFaGHOlFzECNLqw36o+GyPJOkrUU
	 hCfAv/6iS9cWZWl0v4KUli24M1dOJnMnPFmLY+TurWDmZu6hsZLuKO+Ncw/sRigE+YxU/
	 4WpcFPgTa4sfYg7LP/wfv+4OG2Ye66CyYCN/pJEqYjwX/UtV21B2HIN/GU0swQuJATQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519980;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zQecoqK1U3fT6xcN1EIuZ3RBsnV4n9MBeaFYMmpatRY=;
	b=dcC+UflTNQJhM5T1Bds0gWfEkB0sQLVslBd18375ORu6ng8Eexq16Rovu/+FyHOEog/C
	 LOEfhDArUmV3T9oU3KOkLOeKPSVs+i2vXmJ66mVOBHWq5XlOWZ1yWc+pZIqOWDDU+FUUg
	 eDt41CcMZuzTg1Oiq4meQBL40FR0BEs1QaT3umC2819LkP3WmyUEmnze5xKrPoLJrCeZz
	 DzFDS0fFFF0oFVZTbPANiR3IVlygLhLhsIYMb73b/eJ2ODSmAPuKWi7ES0LDpwa3yEkID
	 N5O9kvFSY/c9rfX7kdRzpSGnhhC7ahZAp0RiDX2R6+mHY5zV+kpmdo9FWvfPLQxXhJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iVJlcYr/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1461B606A880;
	Thu, 12 Nov 2026 21:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iVJlcYr/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDC71F000C7;
	Thu, 12 Nov 2026 21:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519979;
	bh=zQecoqK1U3fT6xcN1EIuZ3RBsnV4n9MBeaFYMmpatRY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=iVJlcYr/bYTgn1xL0+UYk0XO5WaXjs/1JhP6HxJ7wwhD/eVRfPXgeNF+VkK9gvslF
	 zGkbDW8/U46JusdhtxDLVa3q/wwvvCI9dRl/94t7kVoSRhykvtCa7iVsZS6RtVELwO
	 LCB0/8KvqQ+OW60KpeYkRv6HDocUxEPrWpl3OCxZkVQHt8D3gOqu2j3oyQD7ycyGIn
	 UPL0RFscgf21TCUIVz8KQScYK62Mk5neID8qqLzUMyeoyyJY4SwQjC7EtzfasGwaqN
	 srggR+237SEeT5BHpAYgIyFwBqwDbA8ZEG0bCgbi2+lvvbOsmhC3bWkmo6boI4BG+m
	 ZLSOPGKsFIkhA==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v9 07/14] xfs: test for reflink after the dio write checks
Date: Thu, 12 Nov 2026 16:46:11 -0500
Message-ID: <20261112214604.67875-8-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A direct write that is not block aligned can expose stale disk contents
on XFS if it races with the first clone of the file.

xfs_file_dio_write_unaligned() falls back to buffered I/O if the file is
reflinked, and tests for that right after it takes the iolock. But
xfs_file_write_checks() runs after the test and can drop the iolock, for
example if S_NOSEC is not set. A clone can run in that gap:

    direct write                        clone
    ============                        =====
    takes the iolock shared
    sees that the file is not reflinked
    drops the iolock
                                        shares the blocks
    takes the iolock exclusive
    writes a part of a new COW block
    maps the whole block into the file
      /* the rest was never written */

The fix used here is to move the test after xfs_file_write_checks().

Fixes: ed1128c2d0c8 ("xfs: reduce exclusive locking on unaligned dio")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v6->v9: no change

 fs/xfs/xfs_file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8ee88910b487..d888470d092a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -877,9 +877,15 @@ xfs_file_dio_write_unaligned(
 	if (ret)
 		return ret;
 
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
+	if (ret)
+		goto out_unlock;
+
 	/*
 	 * We can't properly handle unaligned direct I/O to reflink files yet,
-	 * as we can't unshare a partial block.
+	 * as we can't unshare a partial block.  xfs_file_write_checks() can
+	 * drop the iolock and take it again, and the file can be reflinked in
+	 * between, so test for that only now.
 	 */
 	if (xfs_is_cow_inode(ip)) {
 		trace_xfs_reflink_bounce_dio_write(iocb, from);
@@ -887,10 +893,6 @@ xfs_file_dio_write_unaligned(
 		goto out_unlock;
 	}
 
-	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
-	if (ret)
-		goto out_unlock;
-
 	/*
 	 * If we are doing exclusive unaligned I/O, this must be the only I/O
 	 * in-flight.  Otherwise we risk data corruption due to unwritten extent
-- 
2.55.0

