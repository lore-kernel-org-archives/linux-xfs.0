Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDA81DF24F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 01:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638850; cv=none; b=Xy6jrT/38C927mPr/6xlHI4oiSHbGbByUeq+AAeha4L9SYD7qbW9BLV8ByIEimsE+HUnLP5PjrM2EAf1xYmCVShFmjZfRGZ4/qaCdnfWoWIbYxRv3Yehs1cELI2FHJ82nCDVjS6mu7MWQ/lvqgjwS9amU0HUkyDRchdLhp7b4YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638850; c=relaxed/simple;
	bh=SkqE9KD9POhtQMYHKuZUR0xfD79YnxWzcMskLl+dwVU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtQsbl7zx5ZKxHDOP5Di+JBbuUSi+YUqG+h16jMVpBOSG0F0RG3SrKA3813g33tbeFgLmXsWfuaJmcog47XJoZ26Ec8podF9+H/WlhsA4/T9eshjNUlraN9W3IpcMx3EsyygQwchp6RNSr4/OW/LpNc46DfYKJiaJNbskyVyorU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l17SnIym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l17SnIym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D01CC4CEF1;
	Tue,  2 Dec 2025 01:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764638849;
	bh=SkqE9KD9POhtQMYHKuZUR0xfD79YnxWzcMskLl+dwVU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l17SnIymDZsO2/cMUKGcIwmRvxDBnFED6mkyMU46d6yK3MdSTM4FHf++sbMrMZKw7
	 qWhBITBLlF42ricRyXrnJaWqGw2M9kTip+bk7VfgJFvzU+qVZa+/alY+dxu1vSUihg
	 Smch1ijJwHowkS7gtq3G7kIrynrdWo3X5p1q2sn9SzV/Uwkf7peXK5olloQDwB6//B
	 5EIbbGeQV4jwcOyru+Dc2c0KZVhBuDGYyLXph4/1E+VToWSuQl7MvgVyNphpXINSg3
	 eNxil8M9yLChgzbsPpK3/eZyBm5/6xmGYgvvlq4Gk4XZ8efqST49QKzX1QZdra+DbZ
	 NiaOSfTdRJolw==
Date: Mon, 01 Dec 2025 17:27:29 -0800
Subject: [PATCH 1/3] libxfs: fix build warnings
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176463876118.839737.7691382070128152874.stgit@frogsfrogsfrogs>
In-Reply-To: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
References: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

gcc 14.2 with all the warnings turn on complains about missing
prototypes for these two functions:

 util.c:147:1: error: no previous prototype for 'current_fixed_time' [-Werror=missing-prototypes]
   147 | current_fixed_time(
       | ^~~~~~~~~~~~~~~~~~
 util.c:590:1: error: no previous prototype for 'get_deterministic_seed' [-Werror=missing-prototypes]
   590 | get_deterministic_seed(
       | ^~~~~~~~~~~~~~~~~~~~~~

Since they're not used outside of util.c, just make them static.

Fixes: 4a54700b4385bb ("libxfs: support reproducible filesystems using deterministic time/seed")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index f6af4531ab4663..334e88cd3fcb55 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -143,7 +143,7 @@ xfs_log_calc_unit_res(
  *
  * Returns true on success, fail otherwise.
  */
-bool
+static bool
 current_fixed_time(
 	struct			timespec64 *tv)
 {
@@ -586,7 +586,7 @@ void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
  *
  * Returns true on success, fail otherwise.
  */
-bool
+static bool
 get_deterministic_seed(
 	uint32_t	*result)
 {

