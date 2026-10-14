Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9429B2EC0A2
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791937003; cv=none; b=FMPVpAS52XF4LiU++5EDMuxw0PK8wbxbk6yOYMxTwAjHd1adwdSzmdDpb83es7uHgxJUw0q3Rt57n8oyw2fqmVGnMQ0d8Q7ock/+tW4KpTF04lCaQo8m9GIQfA0RvO+5d9PR56hEkpWKsplZvChBaQ0Oa/BZflCZe2Z7hn22Kzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791937003; c=relaxed/simple;
	bh=4k7aWAA8C3yrTnHJQh+m7eBp90UFyCHi0FG2/fLWTW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJMiPD/fr8E1c4inion6eO+PtQJjLqdItwvuTwGhPu055TCrjhLvad5zzmSLQo3brqBWKuLerupRXtq1WGItsTZehGK08rJLICyD/OLIuO0CzhhL3HkczackRCc0WCoINqOQhHtFcfWLP86puG8UtTHLHXSGg4lOEtnQt6jeyzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=vPZWGhHf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=x8DGcoAM; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="vPZWGhHf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="x8DGcoAM"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B0F6C1400178
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 20:16:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Tue, 13 Oct 2026 20:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791937000;
	 x=1792023400; bh=TgaraTKYy1EhNVxtlFvlQLdtFK0H8j3SfiXmwA2Xm4M=; b=
	vPZWGhHflV+mveY0Q2cZ8k51QoRFbw7fhUhSrt+DBFGzW83YgcMgNXkpAPJEQ3oq
	InMQ9k2Dwk+t3/3QqdyWBSBc5F6e26vD0V1/ruD3xhMgR3sO8j9wqD/bjrsopwYx
	bNOR6T1CiX0y2ny6eVKovQ4TyfTfmTEW9B3xvp0pECw74W4zEgusLAZOBCbqONQN
	GzIbuwkW1wxLCqdUZHT3DrP3n+MGq/Uer705ub7iMf+PdzdUzQk+AeAk1VbWETtf
	m6RjcN2Iuhmin5sAwnUy2yaGyPJkDZsYxbSHcq9Rsjn3MaklGxYRRagd9BbekEg1
	ojMyftogHZleUm25CrSgpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791937000; x=
	1792023400; bh=TgaraTKYy1EhNVxtlFvlQLdtFK0H8j3SfiXmwA2Xm4M=; b=x
	8DGcoAMC/QCzFcbcZpDKvshRC7irLUUSbs08YilmeRfpS2cwhlWf/ld7A5QRGTeg
	qM3iJPrZ1DG5oxWOi21mR8/73lodnhIL3VezXg1+oHcGW/IQNinjGmApPNHN0mdj
	capTr53V2icLmc50CDyVHMeQ4B5YTpFWOyS/b/cRFzMkygZ0eD13YfzIV4Dd6rxN
	O7Ph3txeik4IlqCM/QIMj+GvC9BwhbOdpZ938rog4whUHBZ+D1e8XhLhIyCtNRum
	p4/vTpwZFOFTDsZY/egLjuLEIy/VeXYZTSxbu9x4LJRvWflkU4YrBH/Q9YdUQSW7
	Q96D4FpRR+MgDBeg4Cj2g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791937000; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:sRVsqWUO/kJNi+ZAp18UHlbPA+C705n2cvbIsmp9cuxxXwf
	JKzOmDU7CN7L/N3zMK3EeYp4X6pxspiMzEP+OKM/gQUm8Tx48tdVUDazJeXdVamW
	5rsbOs7zbBAzRdL7eYMo6B7KEtb08Ee6GRF2mhUON5SyEx/85DYbn+AV/Ez/sbE3
	LF+vEMmmIWOudli2LAklG055z/tSluvVPyzLTYjjIWj9iyba9yzn2aUs459t7QsQ
	8CkqFKrIeCAz1UpX+S1n9QmhZpz9YRWquym0HyzMFJ8ff3PoJUtH3DQvU5Xavr7G
	UY6CXJmRK6xmbFb42tA86GpQeAeTLx9OoJopp6A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:54rU4t5VQ5CCWbVQ2qVtBPPdcZOJoWUrcU1unnZN7YA=:4k7aWAA8C3yrTnHJQh+m7eBp90UFyCHi0FG2/fLWTW0=;
X-ME-Sender: <xms:6MnOajrG8dkFacp-TEUvbN13sZlnnlH6F-QOTfXOj9imYtV96EokPQ>
    <xme:6MnOakhprigEzB8ahRhidzwZ7-L3p8OA2T9sUlugjQXcX9VKZfuhuU1x_F1DdKIUm
    3TCS1TbjbnahU4cXobEEsFmgCgvyidAfxvdoRps5m0ZukNJBU_IDlFQ>
X-ME-Received: <xmr:6MnOaogWTCYZ8REnrELFtO21HTGERn1-OW-O9n3QeVz3J7jqj4ZvN5LT7fd5CZwnXNarIsUqkX1K_3uJZ_PDnnhsYsB2lQ>
X-ME-Proxy-Cause: dmFkZTE9i8/UUgFoZnsQzAxv4prq+fflq/Egn5q8Wgh2V8hL/iCTiu9mJ8aC4dTIbO3xe1
    4WV06TfmJK+9yXjfbureDtPDqAre2Nu2H/vETubpvTNwkl1MgZS5VltxdqmBJxDEBVSJWW
    O0SaiuXWkWXrlY6kLTHnrJ8+J3VP1w1ruUOFgNaEbNpf/EaMtV+WTFBACo78QCGY/Ma7y7
    wRte+MFc4ML7QA+TovlHTHk/PwD8cPi5zlwq6P9BjhuHMoBvPOVwAR7w7wzDp5kxfrYiHP
    jN6FCp0cm8AvE9wXKu/VTWdS7tsMCmuyAUgNSu+G08sQyfcY+tgJr0+x8zIFrsaE2V9pPo
    G6Ny/5h2Vx2KrevnEU544Bo0DYN4TWdg8xGGAhJX5jmtwhhkHAhIaptsI8ovw45fMiBaMi
    8UujLITNI+hovSAcxBzdO86I75jcWZD4BgNPSFsOqIvwS7hEKjhvn0GU+qDGNuKZCvy8Ia
    oA70/bhNUfmPiZVp3a6cC68Y0J76jo2MOGyk25zSuRwdKMtIZwOmknGErtko6t516IyVHh
    CrCMdLdcOPO2UdKANGgrmiDcOmwAumQ6NkQpVUCHlbICrHeu4Cxj2uTNj3qC4Qtz264mNX
    pgcj85Or7r9yKvDRvvBL04h2ncII0Jh728plyd9N/+jT1kCPqOcw3FIY6uzA
X-ME-Proxy: <xmx:6MnOaijypOU6twK9m4dz2RTh1aDjHVDW6YxDQ3RoaOzfKdPnnLBN_w>
    <xmx:6MnOagLIwBoTKjwHonOrQgf6cd_z6xM4bOeYsR846S9n4qCSylt5ZA>
    <xmx:6MnOapFOm7kZL3N9FJFbKurToAWRwk-Uia2N06-Unc6YEOlj4ut2FA>
    <xmx:6MnOasQBnBGMkz9q6MB8cSUPLOJ8g_kREBlb6VEQEqxuaguERkToCQ>
    <xmx:6MnOaiX54dOQSVxonWkmeOW0ZpQWY3BpfzMkW-_JrtF2kroXT7METmwq>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Oct 2026 20:16:39 -0400 (EDT)
Message-ID: <551761b8-51c9-42fb-8992-980a72999135@sandeen.net>
Date: Tue, 13 Oct 2026 19:16:39 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 1/2 V2] xfs: add missing cursor status check after
 xfs_inobt_get_rec
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org, djwong@kernel.org, hch@lst.de
References: <20261013211851.641256-1-sandeen@redhat.com>
 <20261013211851.641256-2-sandeen@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261013211851.641256-2-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The xfs_inobt_get_rec() call in xfs_ialloc_count_ondisk fails to check
the &has_record return - if the record is not found, the next
conditional will read an uninitialized  or stale irec. Fix that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

V2: oops, fix function name in subject!

 fs/xfs/libxfs/xfs_ialloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e705f681ed44..17699f7c009f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2843,6 +2843,11 @@ xfs_ialloc_count_ondisk(
 		error = xfs_inobt_get_rec(cur, &irec, &has_record);
 		if (error)
 			return error;
+		if (XFS_IS_CORRUPT(cur->bc_mp, has_record != 1)) {
+			xfs_btree_mark_sick(cur);
+			return -EFSCORRUPTED;
+		}
+
 		if (irec.ir_startino > high)
 			break;
 
-- 
2.55.0


