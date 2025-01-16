Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25984244153;
	Thu, 16 Jan 2025 23:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070177; cv=none; b=pPxIaQI4eqhx9DqKBueRzdyAr/pFLUjz5vc4HRzf3wcDMBDcrVACS8xgsY9mIXz+N6PGnBPgiv17O9rkuhjZ07e5aA3E/f78g93VC/b8ifNSsHd5i2V1BBFFz0IYMlYFHd+Z4ma5tm4OVPHXSxjXorrYXU69lRYzAF1H3k52NHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070177; c=relaxed/simple;
	bh=X9Ji8lr1QW5xZtOi5oMyQIkT61qXQ0IYWjXUWtQlwbA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUSvQ+tqWfF4WXmeDs9P2GPwBRz3q1wlaCG1Yq/nsJkSi4Y7Vtj8SKdGH3ZqLAMpD11djMehn8tq2e8Its3eIhmE7g9ml0PexfclDYkNFi4W4U8VicExWkSuGTXX1JfqEMJWnQJtdnddGlw/XdOG1jhXpr2BEM3GHLjUbGvHPtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tf6uE5Ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tf6uE5Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBDCC4CED6;
	Thu, 16 Jan 2025 23:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070176;
	bh=X9Ji8lr1QW5xZtOi5oMyQIkT61qXQ0IYWjXUWtQlwbA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tf6uE5Ckl2C1DRp6kNCh8T6cU0MQDFcqf9k1V4ihGr1Gr4rXInGc/SQBEqt3BdN+c
	 msWjJ3EOFGDxgrD8tJ/vrN3iWT3mWNVRzx/lzRzicQ+U4qcqXeybr3uAmK3g1rHQ+3
	 lWUjO/hfwV/tntt3+7JlQY97smWh40aSe9AKu6IP/vpZT9JM3jK5loOeI9jiPu7u4Q
	 SPFVTVzIBDI3wuvshzaioCYTBOvqWRWqGvepv9lP0ygJmWq1QMxM3LaVfvsK6K88xI
	 q3lW/fbMCy5Vaxu9chBuPy/pdsE7eHfnOk5vvj1wbDJ6jjjmh1QHg6DBwoaV4wapfn
	 asYfjJuhpjn3A==
Date: Thu, 16 Jan 2025 15:29:36 -0800
Subject: [PATCH 17/23] fuzzy: always stop the scrub fsstress loop on error
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974333.1927324.5781121702398584131.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Always abort the non-remount scrub fsstress loop in
__stress_scrub_fsstress_loop if fsstress returns a nonzero exit code.

Cc: <fstests@vger.kernel.org> # v2023.01.15
Fixes: 20df87599f66d0 ("fuzzy: make scrub stress loop control more robust")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index f97c92340ba9ae..e9150173a5d723 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1012,6 +1012,7 @@ __stress_scrub_fsstress_loop() {
 	local remount_period="$3"
 	local stress_tgt="$4"
 	local focus=()
+	local res
 
 	case "$stress_tgt" in
 	"parent")
@@ -1143,7 +1144,9 @@ __stress_scrub_fsstress_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		_run_fsstress $args >> $seqres.full
-		echo "fsstress exits with $? at $(date)" >> $seqres.full
+		res=$?
+		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
+		[ "$res" -ne 0 ] && break;
 	done
 	rm -f "$runningfile"
 }

