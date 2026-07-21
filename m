Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2650D78F26;
	Tue, 21 Jul 2026 03:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604353; cv=none; b=kjy8RWKhHHGLtQZLK5dfRyDQE/IxiSioZGhswDlmHwqqT1z3FTBeQukkmNu1b5uoGKQISaFVwzr/h8j7Fr9eIEavXOykpqvyrrmgdWqBpMYqEtDlYFw/8RctjD6VeZzFOZmRUHQ+AsnxhNGLN3isUzBsYyBLDJHI/v7YmQfkPLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604353; c=relaxed/simple;
	bh=ZYm/E8gG+9xYGZvCO1kn/J7Yt1TrtD42kehQkhV6lh8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAFm21HooISkgPn5KyNNLSU0Fa1qFVB2NNan2vxxoD5z7PT6fRBM+hqXQWJcXT7R/oAK0vieWCxvfeAFTk2yuJJgGAjCdNx//CtTefwmbtyu4+R7YZTDOINNPGllr9oIb27J60BB3g/+i+D2mlAqloJjdSaiWTW4cyDVt+ci5Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KED8mBfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KED8mBfl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A58DF1F00A3A;
	Tue, 21 Jul 2026 03:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604351;
	bh=KAf3ef6e+xNc434x9lrSDZ9fbW3A+WWHoszLCCAmU8Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KED8mBfl0/Vi1hDrhYEsSGVF16T4PEVnYlkPmoRwdnyz5raJMyec2Vo5It9VcYmIa
	 wKrCrf7JFmjtahJhTvOKvUUdcfwm5ZBAO0OKNZn1TQ9iEet+YbEwn+lMf+nnJpqeRQ
	 wV3gw0UaJ3rmmQcqF2uNxw+dA2qE1dj3Cmiw4DfNmN8Qc8yvTp3JXFRlA+GKxoOrTh
	 +3ReqnzD8jkV3TT/HH4E82WB3z2nOBqOxddWWz6Y9fKmfCsK2obzzfe56+VzeFQHXs
	 svr+kcKNnbt6vXtNbcxW7U/4HPLFE8Y1Q/Yc+v2UMV7hY4YRMOH+dsJkEGzQqN6PsZ
	 HOVStd6awlV+A==
Date: Mon, 20 Jul 2026 20:25:51 -0700
Subject: [PATCH 4/9] xfs: load next_agino from the correct xfarray in
 xrep_iunlink_relink_prev
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419575.830862.6051379847990817321.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that xrep_iunlink_relink_prev has the comment "set the
forward pointer..." but then loads the value from the xfarray that
stores pointers to the previous inode in the unlinked list.  That's
wrong, so fix the variable access.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 39468b8fa9863d..5204eab09c6450 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1619,7 +1619,7 @@ xrep_iunlink_relink_prev(
 		want_rele = true;
 
 		/* Set the forward pointer since this just came off disk. */
-		error = xfarray_load(ragi->iunlink_prev, agino, &next_agino);
+		error = xfarray_load(ragi->iunlink_next, agino, &next_agino);
 		if (error)
 			goto out_rele;
 

