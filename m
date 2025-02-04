Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93CB25A62C;
	Tue,  4 Feb 2025 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704389; cv=none; b=gT5Zx7zAgTjRd+Ysq0gldz2nWsYqVxuTR1lSEaWTd3WrLudtTWN/VkkPyd98sXjUNiPHA1QsDXqT5YET6QXDHfZufXYUFLZ0EaQT6z6MAxO1WGtJ/WcOZB0ohk3tfIpnjcjtunyD5hZTa6a36Or71yqpBAEsTPAYa3V3osJHdtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704389; c=relaxed/simple;
	bh=mmdjsr1Q4lpMNDVYg+RiJvxkrSSsKmmvR1cWxPRwZ7k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uD1eXS7Uf8W1hyd82N8NfRve2N4yVV1VOR2+A0QxscjKRJayQx0t3j06I3ApYnD41tFPkIyVwQC0AW+xuetimDQkhNesTMqUT73vYU4tTC28L4Ex9LnqL0ClZQFMLCqI0ZZ63b3YPOykLHMkMhYxib5K0d0acWP/Pz+nXCk86KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hG7CN3Ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hG7CN3Ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F36AC4CEDF;
	Tue,  4 Feb 2025 21:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704389;
	bh=mmdjsr1Q4lpMNDVYg+RiJvxkrSSsKmmvR1cWxPRwZ7k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hG7CN3EabBrmbJF4MHkmXCXUwzW5rT6rahc+dy2A1aZXu7KiJFxTfyeRH+UEwiO3j
	 /vZLaj9rdumi4d1r5FmM4J1ZT5O3o2alZkmKMkNh0F70KZI795cTf69LN8na+YmFd1
	 8Jphs8GauqaRtP3B9VGaxLXKONGlaYhhajvbCNHu/iBan+EXCMM4o7m625obU4lutq
	 4kt22Zy3UD60svloSjZExR6DGhdH0SUMvjASPXvJ1wW9VWCxBLA1dI2mOmFTlAcCez
	 NojGDtyr2khcjP4GQABMQMfXLjVvmmU+ZYBAZm68UJ81aJs/2ZTqaG8kKP+/92psqS
	 FYpb4QfOziimg==
Date: Tue, 04 Feb 2025 13:26:29 -0800
Subject: [PATCH 16/34] check: deprecate using process sessions to isolate test
 instances
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406352.546134.8739392016656606912.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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
---
 check |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/check b/check
index 24b21cf139f927..5beb10612b75fb 100755
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

