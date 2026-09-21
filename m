Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17011331EC5
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971489; cv=none; b=AJr3qV9vN8VA+SaISFcRx66pBSLFpVVb8H6UBxSlkGCnOLKwv361ATjb9m2caLhPhee/6AyydNHfP2tTi8BQ7WordtWcydAQdaQsA6LB6T6VbrIQDXrCwDuOQ2Xa27n/xxckUzoPySOVeZAXyJUp3cYxUiA+WMPYopzECKs/JzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971489; c=relaxed/simple;
	bh=Em6/Sn8ay6GyiPX+iEh30zXI/0ClbfxHJBgj0zyBenI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N4JVg/R2YJaKcuRdVlJfmfLjcTloTLZ080MLvbmcNlDlPl2OxJb1vKKYayUDtA+r+LlSieX2tiy8VOP/ESiRBJXx6E0nW7WicCqtczOj3+6qdUf1xmeqa+dNC+LzXfEQ6NIlfxzsDUZuOjLGpXrtM29O9YTJDTvLHGf2L69m710=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kc4uL5gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kc4uL5gk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 47ACF1F000FF;
	Mon, 21 Sep 2026 06:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971487;
	bh=B9H9O1+SP35q4mbu5un5ovDu0eIE5sChsUkP8AwB6Yc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Kc4uL5gkM1mHaGUBLckjLdLdZT8uyoCFj9roQNeiz9FiPQup6YeRNyObwuj9Il0ae
	 qv8eOfS18bHieLuTboKZNKVOgdOomsXmgQt/sGK19gqtDfcrW9ajG2LPBb6RZKArNI
	 3Rcj8WEwxinWyo1k8j98tsV57YQ3BrcNpMdafnaT4u/qLIk2ELu3P60AxIpoPCpFbI
	 Xh+vflTfJCVRgwK7TC0Xe9a6nG10kphvkEyyT/UpoHComPOwVd3y/LU987kTN7KXzY
	 dSxPYBm3CkwGkpqtHdCfHYP1KbJTfoXM1q70BxvrD0WSR76v+gA8H9UuT3gDfp03Fp
	 HnduVRlWmoxng==
Date: Sun, 20 Sep 2026 23:18:06 -0700
Subject: [PATCH 12/14] xfs: don't allow sorting sparse arrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178996120807.181988.9510302652927544095.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've reduced the functionality of xfarray_unset, let's add a
new safeguard: no sorting of xfarrays with sparse holes in them.  It's
not clear what that even means, and nobody actually does this, so we're
really just eliminating subtle logic bombs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.h |    3 +++
 fs/xfs/scrub/xfarray.c |   11 +++++++++++
 2 files changed, 14 insertions(+)


diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index d55225c7885b25..05ff65b09fcf41 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -32,6 +32,9 @@ struct xfarray {
 
 	/* log2 of array element size, if possible. */
 	int		obj_size_log;
+
+	/* Might there be sparse holes in this array? */
+	bool		possibly_sparse;
 };
 
 int xfarray_create(const char *descr, unsigned long long required_capacity,
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index ee3f0bf87433f1..78274ad53097e1 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -193,6 +193,8 @@ xfarray_store(
 	if (ret)
 		return ret;
 
+	if (idx > array->nr)
+		array->possibly_sparse = true;
 	array->nr = max(array->nr, idx + 1);
 	return 0;
 }
@@ -844,6 +846,14 @@ xfarray_sort(
 		return 0;
 	if (array->nr >= QSORT_MAX_RECS)
 		return -E2BIG;
+	if (array->possibly_sparse) {
+		/*
+		 * What does it mean to sort an array with holes in it?
+		 * Currently none of the users need this ability.
+		 */
+		ASSERT(array->possibly_sparse);
+		return -EINVAL;
+	}
 
 	error = xfarray_sortinfo_alloc(array, cmp_fn, flags, &si);
 	if (error)
@@ -997,4 +1007,5 @@ xfarray_truncate(
 {
 	xfile_discard(array->xfile, 0, MAX_LFS_FILESIZE);
 	array->nr = 0;
+	array->possibly_sparse = false;
 }

