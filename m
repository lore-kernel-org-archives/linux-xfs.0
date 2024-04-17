Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429D3262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388938; cv=none; b=atU+l56W3lv2lxck3SjkRy3SYBlEJu0Z53EVo//8qtxXoKFCTvcmVVeA7VMNTt/2nA+smi0Jy+ZqsBmgnSvXt2U7GztR/2mShyI46p1Vu1fFNfIyBnQ/W0wGm6Du7rik5zoJmQ7mkDXuwWL3X4rcbcwawwrIlmYhtlRuLoLF4ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388938; c=relaxed/simple;
	bh=DkuZIUDoTkFQQsIhwJkuBq19CdM8amW1CMrJv5AJ6Xo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HnB78IJqwyNJXTGLQ8U/NhU1yq0Am6yqVzNgBN4JTF6KNnPX3RnCw+3iAl6GnUfvJqtNLRoa7NroXkcnaowUBGAiNxOz6IMyjiCwKaQ+IyHYs/bf9j3TiW7Zpqgi97iuXGUsKq8CTnPVDK0yEDn50ZuvRAM8KPYaqrjnDYhP4Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMtx0GDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMtx0GDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C49EC072AA;
	Wed, 17 Apr 2024 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388938;
	bh=DkuZIUDoTkFQQsIhwJkuBq19CdM8amW1CMrJv5AJ6Xo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WMtx0GDLYA0mAJyLNXPP3iGINFQg7kgjsxHbXMikYZxaLIHt5WDQ4cVlh7cMwslbD
	 9NPQjosaEek21fImK/eyTBMs4+IK3mTb5VlIOyfopsnY3X+GV8w2WHi1TCPDpfNG85
	 w4lBqpUGfFRN2K+kBaZ1+NA6o/45bXU355XedTwvrjqMI6RxoyYy40Cm3VboYyYd4D
	 s5enZrbmCI5J8qcm7F0RQ0BQFzKF8pM6otimhTGZug7GfhPXJCBci+S4pgYta8kJCX
	 HAVv9AhRov5zJXT2UOeXhKqSD4fN2ZRcN7cz9TsVjDqlbKF4uDupeT0MXFWDilegRM
	 ddgrrRCHPC5UQ==
Date: Wed, 17 Apr 2024 14:22:17 -0700
Subject: [PATCH 02/67] xfs: recreate work items when recovering intent items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842370.1853449.1456974905203336505.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e70fb328d5277297ea2d9169a3a046de6412d777

Recreate work items for each xfs_defer_pending object when we are
recovering intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    3 +--
 libxfs/xfs_defer.h |    9 +++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index bd6f14a2c..4900a7d62 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -671,9 +671,8 @@ xfs_defer_add(
 		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
 	}
 
-	list_add_tail(li, &dfp->dfp_work);
+	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
-	dfp->dfp_count++;
 }
 
 /*
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 5dce938ba..bef5823f6 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -130,6 +130,15 @@ void xfs_defer_start_recovery(struct xfs_log_item *lip,
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
 
+static inline void
+xfs_defer_add_item(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*work)
+{
+	list_add_tail(work, &dfp->dfp_work);
+	dfp->dfp_count++;
+}
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 

