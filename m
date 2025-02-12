Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393DA3597E;
	Wed, 12 Feb 2025 03:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331292; cv=none; b=ltJiVOF9epqDio1c2vfmnnk+ocrg6iJjW4X4ifLWQpVSh22BzBy8Sh3AnHJ6EJ6AIBtFDbnGqfiMYiw6eHlQcpXf09ouyaEGcE2wXpmJyqJ9kLJe3dHeJ34+/XomElN/+M4ySo03W9FTEQFesAKRqQEPyoxXc0Bt1Dyw0qxsec8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331292; c=relaxed/simple;
	bh=TyXY1PSn3AoT0H7EbDwxN2Y5qWp0H/gpJ5t/9GZ5i4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRoib/XEGZrFKTG9BVq2yRgRlLvPnoaL1plnceCKH+NHjHPVc6lJNJvLD960pLasjVectvnXHwpzaqH5cjvMiGaOcTJq4s+izChEgenRn3ZI/p0F7+iJJV6mpSLG9OAtsO+IcK5ka2j4RCeGpuNNnusInJE1H2AMQ+E67lZZzvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G78WxMSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G78WxMSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB4BC4CEDF;
	Wed, 12 Feb 2025 03:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331291;
	bh=TyXY1PSn3AoT0H7EbDwxN2Y5qWp0H/gpJ5t/9GZ5i4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G78WxMSQYUbbYwVBFArbhejIgGNctI7hB40XTdtT9mock7s06BgTLoBKK2pVjdWrj
	 T9QPDg4dWgEAXTUaiK6BTC8CwmaQ9NtqXROAQgXM14drbMMc52sAjXlMP+TkJDpF0r
	 wp7gOvNw1eLkPcvwqJWKhFOJAGM3ZJCec9JzbVu5flAk/G9UbceMV/wDnKigEx326V
	 LrUW2I9cnUSxXFLk/JqeDKRbQlFXbAhpXqO4bNHhrsoAXuFnaEpztIdc++2Yjcm4LE
	 zZE8j8kNJ98wHQ36G0djtd1zYd9UuTnqvJH/9aA9kNNhJhS4gJSVNiFONQiFhTKy4Y
	 kc5TxUOOxOIBg==
Date: Tue, 11 Feb 2025 19:34:51 -0800
Subject: [PATCH 16/34] check: deprecate using process sessions to isolate test
 instances
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094600.1758477.11291016624208986202.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As I've noted elsewhere, the use of process session ids to "isolate"
test instances from killing each other is kind of hacky and creates
other weird side effects.  I'd rather everyone use the new code that
runs everything in proper isolation with private pid and mount
namespaces, but I don't know how many people this would break were it a
hard dependency.

Deprecate the process session handling immediately with a warning that
we're going to rip it out in a year.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 check |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/check b/check
index 8834c96772bde8..e79fefc4168c06 100755
--- a/check
+++ b/check
@@ -692,6 +692,15 @@ function _adjust_oom_score() {
 }
 _adjust_oom_score -500
 
+warn_deprecated_sessionid()
+{
+	if [ -z "$WARNED_DEPRECATED_SESSIONID" ]; then
+		echo "WARNING: Running fstests without private pid/mount namespace"
+		echo "support is deprecated and will be removed in February 2026."
+		WARNED_DEPRECATED_SESSIONID=1
+	fi
+}
+
 # ...and make the tests themselves somewhat more attractive to it, so that if
 # the system runs out of memory it'll be the test that gets killed and not the
 # test framework.  The test is run in a separate process without any of our
@@ -891,6 +900,8 @@ function run_section()
 	seqres="$check"
 	_check_test_fs
 
+	test -n "$HAVE_PRIVATENS" || warn_deprecated_sessionid
+
 	loop_status=()	# track rerun-on-failure state
 	local tc_status ix
 	local -a _list=( $list )

