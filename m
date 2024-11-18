Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC071EABB2;
	Mon, 18 Nov 2024 23:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970948; cv=none; b=fLr/Ys72iIHOEObnuo+zjTQPxgHXqnXxOKMUYWCZ9lAk14Dk6Wx7kDgSUaw0oWUPcVYsT0fXe3s9lbyujymLjYQ+0fyPXfLAZo8VIXB6IbdflLOmTPcmG1nB0Qt7OrvgJmdwK7mBJsJhOmIvNTmuPvP5rrhPOGYEQC1RheydSXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970948; c=relaxed/simple;
	bh=eCPHpoGFERLrQAUnyDxDDExsVtjBYVqQajl2kJkfIDE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LbJnUu7yqNj7sSVt2GgJ2t7nCgBbd/muqtIvbrVH1YJClfwkJvcwXzgRwq3cUMN4UKiAXnLA942koZQtdwRpBJ5IX2LDMSOwARg93614q2qbaTaA/dGUEmfsPVjHaSeZfegwOCZP0HJ/27gWCas5J5ynKCuh1QPNQtq56f1itfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEm9oOjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEm9oOjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A048C4CECC;
	Mon, 18 Nov 2024 23:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970946;
	bh=eCPHpoGFERLrQAUnyDxDDExsVtjBYVqQajl2kJkfIDE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZEm9oOjoE7iVdA9bPhzyvYnfjyitiLCkb0DjK5JNO/rmAxrKq6hbLtmReuz6HlDrt
	 vpF91TJd68s7HAMZ4ViXx+nOYDX9QgzOvlIiyileicLI3PSmEi126Wkp/4CsXel474
	 IBfaQ7J1NI9ZL2QMidJyEAZBSTRFSd5DQSDmIf9LIGJF4q138Fr8J5pkHecAv9HV0Q
	 CCV0OBLePENzFowgaEWzn4CyKl9ot3VQOxYRT//roLXrR3iF/2ZH4KDAmJpxHW8fPZ
	 YrwN8gC3EOJG3dasL2V7zqh+TjrlqQmEhb8KiMcDGrAHSSW65LECioa5/NVeqMgmAA
	 pCOOBUt4ucIow==
Date: Mon, 18 Nov 2024 15:02:25 -0800
Subject: [PATCH 04/12] common/rc: capture dmesg when oom kills happen
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064486.904310.6586845030340568290.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

