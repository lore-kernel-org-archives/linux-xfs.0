Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795748707;
	b=Syo1/xsdtqrjRzQlQoGU9aScIA6YEvewGZ1V8hJZyqUykq6Wbi3HliTa9I6vdx+duOgU
	 JBu73LRGhjfeprzmNdBoZAhiQTnM9DuhMlGas7oG/6CMrMifXfpGupyq9O3ksD5WdUFQ3
	 FZZ+k5GQBaxH4UsXWh5ScDzvPYz1IlxLZVvyHLItHnFumQHjlzUXy4WPbdYOh44snan2w
	 yTWWwz4fZ7cfNtMnsEmszpX6jwx+8XzBzM1nXtjdFu65NPWOlx160wh6MLxxkHUaf4Uld
	 LOh0thQ1s3eAl8xCJM6Lgzy3IEPeZ+wan3J2ybfrxD1zdTtA3Xa0iEvtUM/mXpw/qjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795748707;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VMJSDmNyEar0oZTXLe+VUV/WQ3gMi33nYR1P2XH9AI8=;
	b=4zfbvzUzcsdHLPhRF4ZAMcYS60/pkI0tf+J4NWEovx7yAJ2iDSeEPgrha9vUNdvtqAyI
	 JcJfZIHq9FYOF9Wmrct6+XVOqLhCn4B5UKplIm2/8rjqZfPCZODG54L5HweDrbLtTMMJ/
	 MJbg268YCYbgy5YLlS37Cqe6Oy9X8nsoZqYotMiB9208pyEV5pqXsE20ZPDwbqTtitniu
	 WDTPCc6zlboCCb8fItRQOvX9mqktXb8xJU6iVLHXcOpkfirYQtaB5to9DqIUQFP3vzCXv
	 SAXBw7nJX8lnxL4IYWvKGHdSeYnI+ITzrKafuOXLTIQQgS//uxSWTjAImaiRD475vaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AE38USPW;
	arc=none smtp.remote-ip=74.125.229.8
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0CD606A321
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 03:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB0CD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AE38USPW
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-382afece6d8so1565274eec.1
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 19:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795748706; x=1796353506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VMJSDmNyEar0oZTXLe+VUV/WQ3gMi33nYR1P2XH9AI8=;
        b=AE38USPW5TWl9F4oXD7LDVr2hn25W7zaqL+RZgZm15AUQjyNTmfZw9Yx759f6OTMuM
         CrQT1lS0N7x+8afjh1La6Lx4lTB8aNjjUYK82L73suD1lWk9IBY7F5Rjshn4cnWZPPim
         TDRhZEN+M7Cq1Xm5YD/8RiBL/Bkr61GHbql6IR9gY+4hV4aiW0XaPgON9g3V3k4dQiBx
         ggkpH3xj6SABmowixfpV0VyyFcYsMP/XMmOY+JbIg4dxSMGWkO4gla6lVIsITMK/UjjP
         +FJuJc2ncDBud2RcclfSFfjav620QfIJb9cBRFRaU02gjyj4r6gRVRirFHnw4MhalrkV
         MfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795748706; x=1796353506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VMJSDmNyEar0oZTXLe+VUV/WQ3gMi33nYR1P2XH9AI8=;
        b=gRYgHbqXKia4EXdaC1ZglHvl9tsGQbqrMlFe1JFRT77t6focE9ZuomcYhubGAa2bkY
         3Yf7iTwWHHJmodrRGC3gSCJGDrTSldtVekTAvFhUm88Y37zmEIi/bN+NtG27jafGO0k7
         b5pgE7YEEakPVl9/y9gE8M2U2FjtEu6xjdOCX+qrW9cbDgORVyUP+hzdd9fzwRold7Pc
         Z3WTTWmEKI8/Eem9uNiLlgw7mCjp4lorIuSxSkX5pUDmLf1Y0c8xbnEkBimKp890WOQn
         S+X4N4UOLSIYFnfnCri9iFN2tIyLk5SZ1XtzZMQCkm/oZx2imjhmxh4C/vBVGBqTQrgC
         2F4w==
X-Forwarded-Encrypted: i=1; AL+hErES9AI5pDWX6YjIfHJlrKKn+ghUIbXWVGkErD81DB8flJMxj/75GeUixzA63blNpAgyZYnDFuAR+Vo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9zPk5UyAY04DoUToSJPM4ZwM98qzmpoMNZCiHmkYo0ByREybiE
	QeN/DlFZVufTap4e064XviipWoBYHIN05EXWOEzYDpQ4O5uvWE8qCRPq
X-Gm-Gg: AZFdTZdIJfwFeo9/7BpasPXkHAfvFQBACDg3yo76/FaqGJySDvD9Z49OrjnXCdeRSCS
	hK0cnIA37I9U7sf7dFo9JAiDHhorgBacfItHNO4emLsETDnGhqTiVRbeUSVL4/k8QsfmjyzbweT
	FJPutPJKTWzVJmgA2us0fX2Kh8SNWRwRtKeDz1UR6VOzE5zAhvxBowrVFky2ck5QzL23DqA7kvA
	vCKI9Fv/Hr9eIA8p5qMOrQY5nX/F0QxYd63tlS6lqz84pQ6LirRt5SoPiUtMwyUCgn5IczfbFvH
	biRoYY5ecr+fAob9Yhn/ytV+UUhzRXIP5wBvJNkR4KC9wi2ML4SlZSWsH+wlboBwQgISjcskUSx
	FYOEkYVJmHknHUst/MH8P1pZPbb2NwjmA18E97CfLvMduwhWc32p+as21dNORUMvL/80LGKGv0C
	0CI3J7TqVYDkP7UG1SnzRDILufsUWCz3QtV6JgRec0kJ5b+h/NIX2Cb/bcyXNrXhNfr5+roSVoB
	PAVxpgFpmPgGotJ074ls+AEOpjpQnKO20tq2f5PPfE/UP41Dus89ZLQClCAPQ1EH2RzfRxUJcJj
	cd2jmsWw2dSP2KPUnJKIZetExnWM7OUhO7pAh7v9L1+P54Unhz7Lg7eOC4edsKH6u8AbyMS6J2g
	0Fn6g2c81nRqMtA6w8vWtLPFmbQE47kxJ20yfoQ1JTEoim6w+/jFTaZ4SDZR/u7iDIlzY5TVJVe
	c3u921FOFp/iHDfBFunbcmjw==
X-Received: by 2002:a05:701b:4583:10b0:185:33ab:4d55 with SMTP id a92af1059eb24-1b5569101fdmr21655037c88.29.1795748705829;
        Thu, 26 Nov 2026 19:05:05 -0800 (PST)
Received: from localhost (ec2-54-254-160-110.ap-southeast-1.compute.amazonaws.com. [54.254.160.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556847fdasm59613588c88.13.2026.11.26.19.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 19:05:05 -0800 (PST)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH] xfs: fix log flag cleanup in xfs_bmapi_remap error path for attr fork
Date: Fri, 27 Nov 2026 11:04:55 +0800
Message-Id: <20261127030501.1618-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

xfs_bmapi_remap() was originally a data-fork-only helper, so its error0
cleanup block hardcoded ip->i_df.if_format and the D-series log flags
(XFS_ILOG_DEXT / XFS_ILOG_DBROOT).  commit 7cf199ba5a70d ("xfs: make
xfs_bmapi_remapi work with attribute forks") extended the function to
support XFS_BMAPI_ATTRFORK and converted almost the entire body to use
whichfork, but the error0 cleanup was left untouched; a later mechanical
conversion in commit f7e67b20ecbbc ("xfs: move the fork format fields
into struct xfs_ifork") preserved the bug.

When called for the attr fork, the cleanup is a complete no-op: it
checks the data fork's format and clears D-series flags that were never
set, while the A-series flags (XFS_ILOG_AEXT / XFS_ILOG_ABROOT) set by
xfs_bmap_add_extent_hole_real() are never stripped.  This is reachable
on the success path too, since error0 is a fall-through target: if the
attr fork starts in BTREE format and a three-way merge drops
if_nextents below the threshold, xfs_bmap_btree_to_extents() frees
if_broot but a stale XFS_ILOG_ABROOT remains in logflags.

In practice this does not crash or corrupt data -- the inode item
format and flush helpers dispatch on if_format and clear stale ABROOT
before if_broot is dereferenced.  But the code is logically inconsistent
and relies on downstream defensive checks; fix it now to avoid future
trouble if those checks are refactored.

Make the cleanup fork-aware, mirroring xfs_bmapi_finish(): use
xfs_ilog_fext/fbroot(whichfork) and check ifp->if_format.

Fixes: 7cf199ba5a70d ("xfs: make xfs_bmapi_remapi work with attribute forks")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dcd5faf3428e..9236aa80838e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4520,10 +4520,12 @@ xfs_bmapi_remap(
 	error = xfs_bmap_btree_to_extents(tp, ip, cur, &logflags, whichfork);
 
 error0:
-	if (ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~XFS_ILOG_DEXT;
-	else if (ip->i_df.if_format != XFS_DINODE_FMT_BTREE)
-		logflags &= ~XFS_ILOG_DBROOT;
+	if ((logflags & xfs_ilog_fext(whichfork)) &&
+	    ifp->if_format != XFS_DINODE_FMT_EXTENTS)
+		logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
+		 ifp->if_format != XFS_DINODE_FMT_BTREE)
+		logflags &= ~xfs_ilog_fbroot(whichfork);
 
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
-- 
2.34.1

