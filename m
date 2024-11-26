Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88806C2C6;
	Tue, 26 Nov 2024 01:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584471; cv=none; b=jvZjmMqEg0qIB+pr4gzt0a5zZ483z7QlYi+pkXhb9zQTSf7cMtdF7CBOMdJPlEmXMwXKASm2r254dJpk+uIimdyHGMN+NzH+W894VloWpHVrZgRTer3MgWHKDkCb+pTN4nKvig2MrMvPXYc0e/3Os75Of/kMsMBpDkEfYMh0n8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584471; c=relaxed/simple;
	bh=4vgcFib9AR65eqjVPmhbGa4SZu/AvWK6PBa6PPpGwV4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJmNeNdf2lN/0+OpDwDZGEIZ8Fv65l9XKAxp7MzjrZfHEf7u/8zSA6X8/W11JHgqruoLS89G61DkMH+mUPKoPqyl4gtCgddvjYT9Q18ewgvFcSczVo0zb+bUgkr8KxqOtV8tNjq6Kvk1CKXtGasp3BVdvvst9mWURXi9wgVOU0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jak8Osc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jak8Osc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07592C4CECF;
	Tue, 26 Nov 2024 01:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584471;
	bh=4vgcFib9AR65eqjVPmhbGa4SZu/AvWK6PBa6PPpGwV4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jak8Osc6Y7LOUrP4W/y4cm149gp9w4FLe5Ktnb+r+5Q6DvBZo0wsyl6sErtQa+vnr
	 d3niDeHbAM4nXE4PrXsZXVinRV0nDAmVztwsRjS30qIgMhDwurpKdRTv4fTrvPFu3s
	 IX6Nkc7lmlvMRWlCodV2CjIwohmnkcTgtssKDKO3xRZSwGp47EiCgvOfXDLj+AWuv9
	 K4goMHt+48LXsCQPGZUl15fmjITC3IVwFhNQhI2tCeAIpJnnto41KlMINnY7UrAidc
	 jnhp6jnlrseLkRoACKrGH6tZrdN2SHJ6eAjMiu/KvKzBy/LMfHAcg4/TPRKN/eaQ4Y
	 tzBODDHcb01+A==
Date: Mon, 25 Nov 2024 17:27:50 -0800
Subject: [PATCH 12/21] xfs: fix scrub tracepoints when inode-rooted btrees are
 involved
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258398008.4032920.2214591217065414920.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Cc: <stable@vger.kernel.org> # v5.7
Fixes: 92219c292af8dd ("xfs: convert btree cursor inode-private member names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 9b38f5ad1eaf07..d2ae7e93acb08e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -605,7 +605,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__assign_str(name);

