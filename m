Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F458211
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798386; cv=none; b=XaML5VYggs6hjCuRjsCt0UBRiXBN8U7EZEmRNKsOVYHPFlvjj2+Zd1C2a87EL0Dig9RUWWpwKIJFyyQETriq73UZQVQJ16ivnSczMS6qrnuHxlGze/DjC2SkQuOmuDhBQRT2zNlUWoNXqvOeF3O0K4+bTLJsvbrxwTqh2ZJ/ZNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798386; c=relaxed/simple;
	bh=bmXyXVFD8TGEn6d0AVvfwWb4bH1hbwzQr9k747LhqaQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJeFzl29mpyawbZvS1u1YiUvCUI4Jv0LK2tPFgTUhUWFKZbyaB9BpH61Q2//fX56AAz6MNEY9EtcPbDHm7nk/FtD7AoHUPSS+4EXdPDbBpHH4LOAyURxqUpWhulBpmj9fzv3WXysVuwyYyARCbH/vrMfrnzCivkG6I34bvZXf6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxPeDDLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxPeDDLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792CEC433C7;
	Mon, 18 Mar 2024 21:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798386;
	bh=bmXyXVFD8TGEn6d0AVvfwWb4bH1hbwzQr9k747LhqaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dxPeDDLceWU3ounshIy5g3YYKsBfuKUxkGsOjsGrQKRrf4fWBeFYN+VGSVZAoR4dJ
	 dzKnZrvsSEjJ0kf4acXTfpRfodXt2/6d08LvkWgVF/mhiR2hnBEEoW6IlDs1bdCzJ8
	 pqYSfLBEINOGrrUUx36CJcWGVplREV5dbre+fIgbfFxR+crCNi0tLr7EqBDDdUdLAA
	 sttx2BNObMjuO9qlm3q6jBQZ8P+EdB2avWF6dItBHau7fheuNn14Ynav65Ik1M52eT
	 EDHv0w7DfTAoN88xOsKIm+Z7J4xS2LtRPnvnP8yItQ/Y/Atb9KLUG4Jh1lHX8mPf97
	 uAfJUL1yfxQ+w==
Date: Mon, 18 Mar 2024 14:46:25 -0700
Subject: [PATCH 17/23] xfs: drop compatibility minimum log size computations
 for reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802152.3806377.18033460028058163561.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index b836de0de5b95..1ccd4aa921756 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -81,6 +81,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

