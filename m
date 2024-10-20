Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DA42F56;
	Sun, 20 Oct 2024 05:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729402593; cv=none; b=pYp1NnlYntMaukk8/uxzU4SBivU7GRgMfGPVyH8Kekcf01Uq8/tIgU4Qu+JJt2ffDDHGfU179uBZUgHdb6h2MsXmCqNLcahU5MQF6VQWt8Jo8vF1XmR46CeSGdubXUxIWs2wF57FMHNaAddjHBAjCAE6whkdR2d0iXhZKdiUM2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729402593; c=relaxed/simple;
	bh=CQLS4Jdh2TrYEHMdcvsbtHJOnhRHa5bYKh7fqXhbfeM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=CqEmJxxrg3HqCWCZxjtRrQqd6Bm0ldN+cQI8N1GtKuOChjDZzP2vfdXiB2IPvsv7XD7wNsBPsp4OL9EHPxe1lSl43Cx0BCCPUO5T6K6p7eimlm75GtnKtaXsUGA4qdDz7skopncJ/MMmYQNjLiNU26JVZez+upQ4nGnwVbW5s2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=xvzJPctv; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="xvzJPctv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1729402284; bh=68MuDEAkugZHHuw3z4nllIsNJNyk2fMNR0z2lft6ay0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvzJPctv/v8lpzz+ZqHjJDAF7akW+OeckVNd7KFjisRWT++zaqzaJMZEcKLn+8Jj2
	 Cd2wx+huqT0Cq7KRmYsdPvIOtPoo4ScStQ+NWbvv0dtv3Fz2fB/svvMbjzRbYX4Fqb
	 rChTYamsJQZXO79i9H4vYvkgRlr4aLxiMyN24Ucg=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id 78496646; Sun, 20 Oct 2024 13:30:04 +0800
X-QQ-mid: xmsmtpt1729402204tpu5ambad
Message-ID: <tencent_1DD6B365236C297EA3A6A45DB768B76F2605@qq.com>
X-QQ-XMAILINFO: OCYbvBDBNb9rtjglg1mFo8KR3yqhPGr5SIiDmmj/8rCInRZKzKSCIt16DX6VeA
	 fTND/GMtJJLqloc5WuhEKLRmDBuskNeDAAwsVSywWKWK2x0aUSLzfrlsM+EvbWJqNsIV4NgwNzc5
	 PMgJMvbwLx2axyydVhOSVVapyOW44YGUkanI7gflGSw8gP54By8d5lR0g5ORmOyn/udYSMnn+FGV
	 9587vwT73vB2nP05uK/L4uwKPzvmMWQHza/OYDaJBUVGUrkfGTqU/mvgSjWjhBoUHR9Wo2lfZUHz
	 H0gOFM/eGsWjusRgVS7azu7DAyPTOEAyO5I8wpbvpnrWUL7Oym81Mk4s7AUWdu56fxY5awOg+yW8
	 L4yEoD+UtYGA3k9yomVjOvdAiJeG7CGarhJoFrWC+bwpjnjuPYUU+wmKsaBZ2TrBCv7LIJy/RKPx
	 M3QvhEiVvHw4OFCm59vT77BSQRxGBi/3JB1CQxsHp6mfFgITQqhtlPsC8Ri/mboNwtyIGLM+An2M
	 vst1rTWyHcEy+CEuDJvYvAuIJQ8p9oepaD0IchCi0v02Eypnk3ltXj6Bd3awr6B0cYqAcX17wjHP
	 iORTvWOzpGnotOlkvqZJDnVd8cUY5yAstX5gzsmrCbJ67syQw4NE6ZInPXsl1sde4Jk0hkY4Luj+
	 42+Qs112zeTZnq/RYg642JeV9qLHDg3RKmZG6DVcBmCn1sENgFJ/A4gDOJwHtzMnp3HOjDfYmBQO
	 TfM+zi2twS9az0VkrNOgY3ZFBbT7bHBDkd9rXLg118lqXu0JIynjx7uB9ted6EWG2UkeYo0tlStk
	 gjbgVUhf7ZJVfzzQtDWnQKk37vwiGkkXuM63XdQO0gCpJMQ33iuNRlAnjKajbDpFJsAS9QUXplPv
	 WEZm5lBwbb4lMi1B4MPyyYrIYVNhFqVRKeail2VzuKAD4aJ26UL4ccR3jOSM9X6fEp8IpLM/DM2O
	 z01tZxRZvlx4UGb5uBYQ==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Cc: cem@kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] xfs: If unable to pick perag an error needs to be returned
Date: Sun, 20 Oct 2024 13:30:05 +0800
X-OQ-MSGID: <20241020053004.2431264-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <6712b052.050a0220.10f4f4.001a.GAE@google.com>
References: <6712b052.050a0220.10f4f4.001a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a null-ptr-deref Write in xfs_filestream_select_ag.
When pag is not found, xfs_filestream_pick_ag() also returns 0, which leads
to null pointer access in xfs_filestream_create_association().

At the end of xfs_filestream_pick_ag, we need to add a sanity check for pag,
if we fail to grab any AG, we should return to -ENOSPC instead of 0.

Reported-and-tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4125a3c514e3436a02e6
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/xfs/xfs_filestream.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index e3aaa0555597..dd8f193a3957 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -165,6 +165,10 @@ xfs_filestream_pick_ag(
 
 	trace_xfs_filestream_pick(pag, pino, free);
 	args->pag = pag;
+
+	if (!args->pag)
+		return -ENOSPC;
+
 	return 0;
 
 }
-- 
2.43.0

