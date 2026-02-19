Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F452DD5E2;
	Thu, 19 Feb 2026 06:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480891; cv=none; b=ITg0fXSJIoiwJT0h1Xzbayczl48TfqU7Kvzts0cZJGfvDOylMqLOta7a7Nu4hVUkCZRUP/mIqPiP35lZ4dQq6j2O27o0tDCg/Ac0EdNv7279qP36FWp6FMrxCQtHyz7AjJLL7zFSjeldiWoopshV80prlEyozyBE61TYAQmVpbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480891; c=relaxed/simple;
	bh=KSx4qrf+TCSUeJfz1ZQgZVE84VPN4ei+NpVhGJ1wnlk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SA+s6zQJYNwren61bnsCrK2HpTCOKmSQomgyu9tgiXFkWxIpkb7WtyBomYhAlJ2H8trZwcwXGWl7FM+OZZIFzFIw9mbc7PP+SlWrtloJDqYYr265UCoNxJsy8UCZRqhJLFL9TB0Kr1yShrGkg7ygzbdLHvX3F28ZsAhVlAcGG6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixqg/OIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixqg/OIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1ACC4CEF7;
	Thu, 19 Feb 2026 06:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480890;
	bh=KSx4qrf+TCSUeJfz1ZQgZVE84VPN4ei+NpVhGJ1wnlk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ixqg/OIQYMKGylCqMJJapAOONz5vkHQClnCA8hchQC9+AAcP9NHdPnI+UfMIinjLA
	 R36NRN+Rwfh9YfutsAabuxORZAsG1QFBdhierGkppLQehxSwxmOI9aiEZ0oN/ogeMd
	 eU/eziJIye2MTrfjcxahu62efkVnugbu+Em0WYGbIqEITpbitxIMUCYu6i6WALL+J1
	 vKq1fAl2/sx25fIyrmNQn0iams++qKr80uO/uOwRJG6Lf7+VhpO/r59cdlcYCXoFA8
	 Yd47KvEern0/kzd07uww49PLrGahrbzOgG1E73WiuiWq2exN5BemogEyIAFDci8Lwc
	 gU2Bt+F7DDQsQ==
Date: Wed, 18 Feb 2026 22:01:30 -0800
Subject: [PATCH 3/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177145925473.401799.4192737708449778278.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Chris Mason reports that his AI tools noticed that we were using
xfs_perag_put and xfs_group_put to release the group reference returned
by xfs_group_next_range.  However, the iterator function returns an
object with an active refcount, which means that we must use the correct
function to release the active refcount, which is _rele.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_notify_failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 6be19fa1ebe262..64c8afb935c261 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -304,7 +304,7 @@ xfs_dax_notify_dev_failure(
 
 			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
 			if (error) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 
@@ -340,7 +340,7 @@ xfs_dax_notify_dev_failure(
 		if (rtg)
 			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 		if (error) {
-			xfs_group_put(xg);
+			xfs_group_rele(xg);
 			break;
 		}
 	}

