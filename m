Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240580;
	b=Len/NYT3sJPZYpmhow6wK9kMmecDaKIULOGNkvBk93h1t6+kqEhV0TtOnKVR7gkoizmC
	 32vrWe1IW9ObTb2oABDb1tZqHHDTkOUISqMPSFVRO0/rc7Y5RaltCN/lyibLwZfLi/QKz
	 p56xTVKzgIZfZ8fmdcc/C+E7XuzXCKfrDsjcvmI8LkrUhLPsLIM9Fkd5NSi/nAz8yz3zg
	 6iTe4S6msNEfIPjmvsHf3FZJJWT/shhjnN/mZNAHS+HJsQTZ+E/TxATTqYkfcP7ltJM7C
	 A2JDBZJNPAepVzzValy0917Fud/WsMxAnbNvj2BNIhdBT0JdaUGuFPgBDcLFdAZ+4Ig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240580;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=VQvK2KDZ9ncdh2P5KPr6t2EXtNY+2xLZjK88BwJVdcQ=;
	b=XUj5OkhoZ8UmhnxipI6Obdp03MW2j1M5slQxZT0oTkCyCnZUAYxPAiIdVMzrgnlSAFai
	 nN+rh2poYRLM4nN6lQeH4r/0z6Xc8ccJuvQTbgOkbJ0vVc75VvZ/Ts5KQfslA+BwRqQCg
	 Ep5FQ8iGoTgfiLnpGpaPejPwFF4CqCCmj4aYY0io3J3qWnaEqMn6yc9svbcBq4Cg7GVEr
	 jAAxGOrQXMX9LvIWUqUs8MD8Ft2DFg/2mn88uQhA5N1gzt499tQE55A3hYnpM2s1olt5W
	 1DjL4Mab5MIEmdaL8oSgAUNcgeMxQKEguhs3DRggGc28AyQmH0XxNFQwpNF5lEZoALg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RXZNhHXn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64040606A31A;
	Thu, 29 Oct 2026 02:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RXZNhHXn
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240579;
	b=DKFfjC013KwuL+fPSB5nLFzlJHrWAd2jpjv9nom/PiiylYtTZNHrkQx95EJi0sXikz9s
	 Le1kKkpzaFLl1Y/3SWhyBHJyLJvTFuQY+BxoeDehkusg564tPBWzvwDsWBf0aAU36NTjU
	 0Zua3hDaKe4HGBWGbawPKW3/TcVwba9WcHG4D+UhXDD/zUAsnqaN9dKZeZ/pFcLCjeLsz
	 1GHZKAhNp10KfdMtSQxbYaQ05FOAA18ei18thO+maafOeiaT/JuQXHEvDl6YxpqJZs5Yu
	 TbWmITTdge6NT0TUWafv6XRgvsnAIsxRR9Z7l0S6VqiXJBPuDmsJgYLjnnzg5LO8y1Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240579;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=VQvK2KDZ9ncdh2P5KPr6t2EXtNY+2xLZjK88BwJVdcQ=;
	b=Kw6uTSOTq/TawbchhOPbPWu32yU7KpdnolhOFtcSkr34jPxWYtZQ9mVNIXIynWZ5nAsG
	 8E/fvbRQVafnkcTBgTjn7mqeT5TbyEsEtqA00UM1By4DBlBqRNLh8WvTvgfe64TTqlogD
	 Lc/kHpjVIQVeWp95D+MvRACzJ7SjH2jPqH8n+amyrUSHD4IAGgSTApFQUu3KeEUFG/VXH
	 fuKCTggToJZDaSX165eQKN5sjvlOel+ISQLpbPc2pB9H3s1Ozp1Stl6KrIYsG6fM1uYuG
	 eQAJ/1oRtNV5pCrcxHzb4JYZWLg8ZtIr36LDeJ9nOCPvPqriaQDpyzB072umiP8RuGA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 614EB1F031E5;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240579;
	bh=VQvK2KDZ9ncdh2P5KPr6t2EXtNY+2xLZjK88BwJVdcQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RXZNhHXnP32XALR0PHhh2BHNcfQhsJC5/ugnO6GA19AS8ptz7+mYEuWxGepOKBMvX
	 4UbBT9o89Py5haazCKR2J/eG6x81lmEjzSDlr5/LG2mVZ2Z8RGX8Y2x1vDAXM6rvZw
	 yUcqxJyCL8Jf+AI1six7eK+jpk/ejrKVdybe1AumPeRLcDB3sVPen9TcbFIYFaiLeL
	 wY6i6PWHXIbUA3Mqf820PRM23Qb6HyEceuLn705qdM6rjI3iUzy/C0fMjuTl4kcocv
	 8PRRRPbplfNIvzsdAj2wIbxl/EnXDTcL6bnStuDs5Oxl8IIN6Fl0Wmbb8eciJEuiD3
	 CuRnVzHk0EguQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DAA8145692;
	Thu, 29 Oct 2026 02:22:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:23:01 +0900
Subject: [PATCH v5 4/9] xfs: clamp a pNFS LAYOUTCOMMIT extent before
 computing its end
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-xfs-pnfs-batch-v5-4-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=1189;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=akdG0QwJhv4iwXfpN2Ux3GrV+SzUkAfBYc45MxG9tjk=;
 b=Vc8044I62Vn1cVdscLLwS4RcfZ4QUS5dk9+LK/Gz8lItpLr/mGFtbPYcckRphcmtGLqs0Nenf
 ZSGjhJ1jSBbDIKo2b57xI1M0VPb7C48FmvvfrTQMI+6B2nDPPnDKqQ4
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_commit_blocks() adds the client's length to the offset before it
clamps the end to the file size. A large length wraps the sum and
reaches xfs_iomap_write_unwritten() unclamped. With the previous two
patches the LAYOUTCOMMIT then fails with -EIO and converts nothing.

Clamp the length first.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
---
Tested with pynfs: a LAYOUTCOMMIT of 2^64 - 4 KiB at 4 KiB got
NFS4ERR_IO and a WARNING. Now it converts up to the hole, then fails.
---
 fs/xfs/xfs_pnfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7ff83274a5..19eb18e129 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -328,9 +328,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)

-- 
2.43.0


