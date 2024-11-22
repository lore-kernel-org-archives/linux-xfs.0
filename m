Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728F422339;
	Fri, 22 Nov 2024 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294353; cv=none; b=JYUgSKOeLLUMjh5lrrFHV7ig+P9NVw42ihK3H+Ecsf2jaspdww8HhousTVIMf0yFgoPy+A4Lz+W7Ph+rorOl5WCpCpEL9iG6Adb1r4oRQsJRekhrH3UkQODiNcjrAyPgKMoZZ0oigwA5ZveGTeNfTnS/B3N2STi5TVWuFEBZ+Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294353; c=relaxed/simple;
	bh=VLe+iO2CGjCnXmc18PilZKB7CW203XR0IjhQyPHSbvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOkDEOZo+UVe65W5wVSOz884lNFF81MNYEe2DsT5tNTapP20ln33eAhUVKSgOXosi/SshsLr7F2krgMGLoBCfreEnxwAOgXvjEy5XOPKo1nsbS3w4WbJDA7+Zu3CfqdZWmvJCfuTj3/rT9Bu2JAtxoShPW83TZy7dvXfz9G/1Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+TmqGHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+TmqGHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59FAC4CECE;
	Fri, 22 Nov 2024 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294353;
	bh=VLe+iO2CGjCnXmc18PilZKB7CW203XR0IjhQyPHSbvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b+TmqGHzRSvj5mDhWa9z5h0HKwiCpNXJgtVTfEq9YjoF+dcorFaxoDIyDC+RrqxUN
	 w7OAD6VzWcf+uJ2pXf76GJIszwBk/H9iMDhWMVlfwo376XFspE06/GNM5ctDGz+8iG
	 fBms4seDqlpPlZtuwCcMoEZbXVcq+UUNEZxM9Cmn/zmuPMszjv2w/6x19ABovP6WFl
	 EaruX3MW4tOj1y03w5zpbHposADj5XhOhvFaJJCHqABWIuiN6OAp6oi/T8kdntWfp1
	 Cp4SegJPixvWtXo34vBZg4MeQC/JkR/YB85EXpmKYJd5w/zpEUySc4l2NdFNxUMOFZ
	 YcAd3mPMRObGg==
Date: Fri, 22 Nov 2024 08:52:32 -0800
Subject: [PATCH 08/17] common/rc: capture dmesg when oom kills happen
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420132.358248.17693136056902875765.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Capture the dmesg output if the OOM killer is invoked during fstests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/rc b/common/rc
index 2ee46e5101e168..70a0f1d1c6acd9 100644
--- a/common/rc
+++ b/common/rc
@@ -4538,6 +4538,7 @@ _check_dmesg()
 	     -e "INFO: possible circular locking dependency detected" \
 	     -e "general protection fault:" \
 	     -e "BUG .* remaining" \
+	     -e "oom-kill" \
 	     -e "UBSAN:" \
 	     $seqres.dmesg
 	if [ $? -eq 0 ]; then

