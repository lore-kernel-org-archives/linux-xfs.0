Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEFF1E0DD8;
	Mon,  2 Jun 2025 14:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874088; cv=none; b=OdVqP1kq8ovqHEDVtVMwgG2R5eLKt+BxIutqHv+I4h4i3lBC+fVgRN0yB1lywEPad3C1nW9kEI3EzHdb0ewhRuQ0ZZxsiZfPylgNpE1AF170PomidibFV35oaUi0t7OTeH70+cV+vq0YZJXYUEieBBXEZEXm8qUeAVJrXiliA/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874088; c=relaxed/simple;
	bh=aJSb9PmeEEKVMNDeRlwAav1QVCTH6xqnxDLJofN6fhA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gl6BAsGXVOVddGRYqo/MDwGNrCIgFkDuJ+DxLmT/O5LexBoJQSGX7NkSQUtM6Og3Tzr0ldSlOK6RtSMyY7AC6egcOQ7LQCbAjUGwyboNW2tfnVzjeMZnMs7ipkQw2HcWtF+dttDqcBGSsASqCI3lbvBxhdNgIa/1tUZdbZG9lMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=C7Z5KcZQ; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="C7Z5KcZQ"
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1748874082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kgQPI+dNQX5S/d0yPfZSHZR915JjJBF9kW4q/ixBVA0=;
	b=C7Z5KcZQCaOB+ldk8UgL6UvcJUJWh4vMjC/cyhywjJhOR3NiEbHA2lREht4+ZLp3QthIyv
	4m9pz6505g21a1ZZhRbSZYVj5n7QFR17R8Zq5YnRPZEbuMRtjwB2JwdaMO9qwdQF3Vp4uV
	AQH9UKhhQ8X/xj7/6IHll91usFDFIpw=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	lei lu <llfamsec@gmail.com>,
	Dave Chinner <dchinner@redhat.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.10] xfs: add bounds checking to xlog_recover_process_data
Date: Mon,  2 Jun 2025 17:21:21 +0300
Message-ID: <20250602142122.82111-1-arefev@swemel.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lei lu <llfamsec@gmail.com>

commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 upstream.

There is a lack of verification of the space occupied by fixed members
of xlog_op_header in the xlog_recover_process_data.

We can create a crafted image to trigger an out of bounds read by
following these steps:
    1) Mount an image of xfs, and do some file operations to leave records
    2) Before umounting, copy the image for subsequent steps to simulate
       abnormal exit. Because umount will ensure that tail_blk and
       head_blk are the same, which will result in the inability to enter
       xlog_recover_process_data
    3) Write a tool to parse and modify the copied image in step 2
    4) Make the end of the xlog_op_header entries only 1 byte away from
       xlog_rec_header->h_size
    5) xlog_rec_header->h_num_logops++
    6) Modify xlog_rec_header->h_crc

Fix:
Add a check to make sure there is sufficient space to access fixed members
of xlog_op_header.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Denis Arefev <arefev@swemel.ru>                                    
---
Backport fix for CVE-2024-41014
Link: https://nvd.nist.gov/vuln/detail/cve-2024-41014
---
 fs/xfs/xfs_log_recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e61f28ce3e44..eafe76f304ef 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2419,7 +2419,10 @@ xlog_recover_process_data(
 
 		ohead = (struct xlog_op_header *)dp;
 		dp += sizeof(*ohead);
-		ASSERT(dp <= end);
+		if (dp > end) {
+			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+			return -EFSCORRUPTED;
+		}
 
 		/* errors will abort recovery */
 		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
-- 
2.43.0

