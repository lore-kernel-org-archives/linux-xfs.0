Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFC61F5847
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775560516; cv=none; b=He9KgmLfr6Iqg5YPsQdpa4DuG3ZshipEbYQoJsx6oNy/tEbiNTdVzvOPv89Cc6wytbZPVBiUL4WCfTGBOMn5vy1azD7YGww1P0eaVo+IXo5mbFArR8tCbRl5lOnTUsIxv5RIiafnA+9UM2Vr5Hty8VXsSgUUd5rq/wXezFKQ81Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775560516; c=relaxed/simple;
	bh=pi62l9nDUeNXf1ZWyGGTSxH+dmvLC1w3OOgBHugCGo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx1l1qZnYH+Hjt3eTFI9Hdx9GzIsFjHc1OdJ0NzIATKvrDJzz91d6HfhHiK3oBSWYwzhpJ//yfp2rnPvBj4Mbaxz26at+zxQIMdbn9j0h2dqxPnYCuOvLrkQ30Wm3le8uN4ZJH1IzykQixQEYuocTcQMBCX/SBFWLvEKcBhUObo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BldCIVqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BldCIVqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4403C116C6;
	Tue,  7 Apr 2026 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775560516;
	bh=pi62l9nDUeNXf1ZWyGGTSxH+dmvLC1w3OOgBHugCGo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BldCIVqCLVzpUkSmZevyUDCga7vENAmTr4UxDIFf4h0ZgyLhYDWAbrdRD+JL7tpas
	 7hDKBLyL2qdzrvXAVl1O4Jj/+LvFy1rPNrpemf/0ZdTvEi6JI8bLkVAVyQw3Nql+vX
	 Ccz5vFh4k9u5PY68hOaVaQmJYFIUb/+NFHL+DF7x9/XajBml6/qiMSwIzakXWHHaxj
	 VMRnRI7FoAjrfwVtAWRoca4qioCAO+ar5e+pNUEDlW+DlTGcyYuPxGKxOr9oD8fE+W
	 eBlj0G4bE7q+Qdh6KWgFba/BaIYtJhNXT2+KxMx+E8AUhsFTxbxi3OcODAAY+9PvvA
	 Whgc3bEnZr8sw==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v4 2/2] fsr: always print error messages from xfrog_defragrange()
Date: Tue,  7 Apr 2026 13:15:00 +0200
Message-ID: <20260407111507.79977-3-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260407111507.79977-1-cem@kernel.org>
References: <20260407111507.79977-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Error messages from xfrog_defragrange() are only printed when
verbose/debug flags are used.

We had reports from users complaining it's hard to find out the error
messages lost in the middle of dozens of other informational messages.

Change packfile() behavior to print errors independently of verbose or
debug flags.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

V4: fix up previous rebase (fprintf accidentally removed)
V3: Rebase on top of patch 1 changes
V2: Update commit description

 fsr/xfs_fsr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 390f7c5276df..e74180c143be 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1464,19 +1464,15 @@ packfile(
 		case 0:
 			break;
 	case ENOTSUP:
-		if (vflag || dflag)
-			fsrprintf(_("%s: file type not supported\n"), fname);
+		fsrprintf(_("%s: file type not supported\n"), fname);
 		break;
 	case EFAULT:
 		/* The file has changed since we started the copy */
-		if (vflag || dflag)
-			fsrprintf(_("%s: file modified defrag aborted\n"),
-					fname);
+		fsrprintf(_("%s: file modified defrag aborted\n"), fname);
 		break;
 	case EBUSY:
 		/* Timestamp has changed or mmap'ed file */
-		if (vflag || dflag)
-			fsrprintf(_("%s: file busy\n"), fname);
+		fsrprintf(_("%s: file busy\n"), fname);
 		break;
 	default:
 		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
-- 
2.53.0

