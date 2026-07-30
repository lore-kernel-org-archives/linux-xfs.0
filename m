Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD2C3AFAEC;
	Thu, 30 Jul 2026 05:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389195; cv=none; b=NO4w5Ok4r3l1QRQi0ICF80l+DJAYS30Whf5GIdV3nwN8V7poKWzWs9//BUTjFZjTg93FsmNxGC90A/Byg3mbKKWXfgWGdJw2HNF0HzENw+KMXd4Z8Hed50IJNO9fCJi/2fomogrtQJuAPeWQhbWBp0W+nRKwJrqfFYvh1a5Mj9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389195; c=relaxed/simple;
	bh=Dr7wm/obcKmAzPGOzZ1JC1zvaUW4m8p6NGetC4jShpw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6Y5t34oS+K/a8rdLwfr3LpWRp7STDaream2vLOo4oMUcB4VqWpuoiKcHQEIH+7uoSSzm4cH0pnq/bUlSxoiFzbmB0Jp451fid1p08S0vEPfQrWbDCdxMockHjZof4t/59cMjMp2uC7++JF5Se4rMnY/is9c3TLgvsb160a8Kok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0BjHHAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0BjHHAP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 26B331F000E9;
	Thu, 30 Jul 2026 05:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785389194;
	bh=bxIZ9wGxoDenO/vBMDFKgkH19YYY3BmAEshrsvZapI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=k0BjHHAP2DKU2TX59RMPPYTbxMIesezg+HqL2Uh7MstaciUVPUFiuZ1j1hs1NjKdt
	 ZlNtuvvy0mWJTdme6PT3VkTTXGIIHiFqrs4/jDCgHqL2+qDd0HEGrkP5qXdwV118BX
	 p9tL3XxI+mYceU+8WIHuchlTizi9zzAjOmxc0Xz5feVM/Tm4MZrh+CKrso8g8Msr11
	 KyqQ2n3DC3/Ybu2v2NYwELSIE4N0IgDZ5c7KVbTXwMbYEUN6FcRc+Ze+dzyfWecviE
	 m3Jsh8QzgGJHvDUXCsqUAz+BBfXQ7KdGJGm8vHHoBroOecooOxhl27pzxDk94v+aq/
	 yk1EZynE3qMfw==
Date: Wed, 29 Jul 2026 22:26:33 -0700
Subject: [PATCH 2/6] xfs: fix short ifork reaping computation in
 xreap_bmapi_binval
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178538912922.4070956.12261164869640345760.stgit@frogsfrogsfrogs>
In-Reply-To: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM got really confused about the update to imap->br_blockcount in
xreap_bmapi_binval if xreap_inc_binval returns false.  The intent of
this code is that we shorten the imap to whatever length of space we
invalidated so that the next iteration through the loop will start
wherever we left off.  Unfortunately, the calculation sets br_blockcount
to the amount of *unfinished* work, which means that we pointlessly
re-scan blocks that we already reaped.  This is benign, but we should
fix the computation anyway.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 496c6eab555e91..f698b9be3dd1df 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1399,7 +1399,7 @@ xreap_bmapi_binval(
 			 * far we've gotten.
 			 */
 			if (!xreap_inc_binval(rs)) {
-				imap->br_blockcount = agbno_next - bno;
+				imap->br_blockcount = bno - agbno;
 				goto out;
 			}
 		}

