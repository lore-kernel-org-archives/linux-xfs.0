Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC1E407CCC;
	Mon, 28 Sep 2026 06:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576291; cv=none; b=ULZU2txR2m6Zj5HHwqh4ROg4q/zt8PG098dtKCptS0tRBZf/KCCUWKAuzSdqjhc65rnaZ6LXT6e6hTdGy7Hdq/HwcH1ULPlpwHY6UKinx8+jjCBvMDmExsHHOmMX7eKRgWUBjLX4z5LcLa8LE+DjVjiApnuD7T73hxo5cmmjCQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576291; c=relaxed/simple;
	bh=gLL4rnyhVH9d2uB1zQINuM2BTl2pLgknrwlwulNJnsQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ud31RVcZb0UULVzrtpb2GUrz2ew5drBc+SBWZns7bZ9u74YpuHZyS4IRvylkAXRRIMT33VObLIX4R+ZdAFFvBrS9Rz+nDXX0sVxomsqeRgi2GAlxh7mQDXvIckTdpjtayfBkGYnIgdJAxH+D9isNxoCv389PoCobHPGrbHYKmwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTniAont; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTniAont"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 847071F000FF;
	Mon, 28 Sep 2026 06:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576290;
	bh=JlrLcThlgKJTdgC4FqtKrlHpTzG/pH2Zl7xrF8lV+tI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YTniAontlItJr0jVv9bU1AeYYzmC0KIp9FxlbwehJOLrgTRSkT5FXcTke6brrazdz
	 W3SKM7MmM6qQbUOZJ5ylVZIqA/3OptIMwvRMNAKnnEo3ZJQl8YnboOqDZjnDEb8Jw2
	 PkerAvG5E2GulEHeJ2gUOfSs7kK9XjElRvIWR8zYuWjLfcuwYtem3Nzkraj88LiVzh
	 U+uKGwzvr01CvLCRFF6eQu5LaixYMZyDlisplouUIJMtlj9JFGvNOM5FYWTqPSGo5x
	 BGdVDLnBt17qReRLFGUGR6LxFsEo/8g/VBvsSe8xGouVqKwjH6U77Dq0TepKpMzeIL
	 op2iko8aymoiw==
Date: Sun, 27 Sep 2026 23:18:10 -0700
Subject: [PATCH 09/12] xfs: fix lost errno returned from xfarray_foliosort
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612788.479634.1850482672854043572.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we stop the sort early but don't actually pass along
the error code, which could enable repair code to continue running with
an unsorted array.  Fix that.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: ee13fc67205b98 ("xfs: convert xfarray_pagesort to deal with large folios")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/xfarray.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index c94f355607790e..310262c0aa9219 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -905,8 +905,10 @@ xfarray_sort(
 		 * problems, we're done.
 		 */
 		ret = xfarray_foliosort(si, lo, hi);
-		if (ret < 0)
+		if (ret < 0) {
+			error = ret;
 			goto out_free;
+		}
 		if (ret == 1) {
 			si->stack_depth--;
 			continue;

