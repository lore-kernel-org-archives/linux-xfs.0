Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72AF35AC1E
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971237; cv=none; b=f8z4p5Y3OJwLu+Lpy70v8Don/JfKCTu3Lrt6uusrbQICBoJ3GA9i7P+BsAdItI2z+r74qrM8s4O3/q/U4oadm8tuItD46zf22yaAjKZ6QZqMykDvJbj/61U8+wS6zm6J85W5Cmp2nfF63rRCY7c+Sy4TPZtlFofli5o3qcZiTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971237; c=relaxed/simple;
	bh=zHTnO7kWHIncr+Ra/2FKPiYnHrp+30n96uQ/Rs0rvWw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mwjq5DWm9t3rLiYIclgCkKcVZJVhNWOlPLfpfITwwMireUOGDQR4lqUWJErlsc4j34C8kAo16n5aosNh6fOBp4AiV3n7ZGYt3gdHfTN9IzBGuplFD2tiBPBu688cqGxSUSWZYLP1SQyDBeTDUNKQemTvyW9hOCg58VzPSPgxg5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuLhqaQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuLhqaQA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E4A61F000FF;
	Mon, 21 Sep 2026 06:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971236;
	bh=/26mo1Gb3vRIiaJeWUlDfoK2Ez3uPxo0qLjNhCV8E4M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KuLhqaQAsOE9A5x4nGkyQk1m/6grImhqwLhwKoKx54rSMrGfaq8+fAukhUKrpn1+C
	 3JWVdqBnR09H94TdE3RxnANCJqRNwsKWO6HtSaGG46rEGgUmKT9SOEJIqN0MXuyLaS
	 7Rh7XwQOz+I5tuzdVAbfy1ae74+ET4Wgh0qVGKB9ULy8CDQ2LFh03oi2hXgm2/1ccY
	 P6kaIOV5hH6JsYdhzS3qE6XcYsBU2H72+KNUC7yichl3b5AW9jRk+Ot0rjYPJU+2sX
	 fX9umH/fLa2r4AMRjW0ICQ51kh6KOdcTrpuvOWGo2UUnjKNoK6K457BK7smbXex/oU
	 /nl3pUPhMF7QA==
Date: Sun, 20 Sep 2026 23:13:56 -0700
Subject: [PATCH 1/3] xfs_scrub: terminate systemd services if the sysadmin
 unmounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996057657.169604.179721236454402577.stgit@frogsfrogsfrogs>
In-Reply-To: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
References: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We should make sure that any systemd services started on behalf of an
XFS mount are torn down when the mount goes away.  On a modern system,
calling umount(8) while there's an xfs_scrub service running on that
mount point will successfully remove the mount from the caller's mount
namespace, but the filesystem remains mounted in the service's private
mount namespace, with the effect that the filesystem stays mounted.
This is probably not what the user wants.

Per cks' blog, the way to fix this is through a BindTo= clause.

Note: This isn't needed for xfs_healer because it only maintains a soft
reference to the mounted filesystem and can reconnect to a filesystem if
its mounts move.

Link: https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdStopOnFSUnmount
Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 0109639eede4dc ("xfs_scrub: tighten up the security on the background systemd service")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 scrub/xfs_scrub@.service.in       |    3 +++
 scrub/xfs_scrub_media@.service.in |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index fb38319e95c148..3e4e79fe6a1913 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -19,6 +19,9 @@ ConditionCapability=CAP_SYS_RAWIO
 ConditionPathIsMountPoint=%f
 RequiresMountsFor=%f
 
+# Terminate service if someone unmounts the filesystem
+BindsTo=%i.mount
+
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1
diff --git a/scrub/xfs_scrub_media@.service.in b/scrub/xfs_scrub_media@.service.in
index 98cd1ac44fbebd..954b8e92a1ce53 100644
--- a/scrub/xfs_scrub_media@.service.in
+++ b/scrub/xfs_scrub_media@.service.in
@@ -19,6 +19,9 @@ ConditionCapability=CAP_SYS_RAWIO
 ConditionPathIsMountPoint=%f
 RequiresMountsFor=%f
 
+# Terminate service if someone unmounts the filesystem
+BindsTo=%i.mount
+
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1

