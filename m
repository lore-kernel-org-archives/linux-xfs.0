Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC35A2F25F3
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773763677; cv=none; b=E0iBq4I/midTEIkLI1LjBzPuwPE0x8Yqqgsnx0T+2EC0TbuFWblSxSKTgG2ziFO4mNXceNcRGrx7eTQhmwf/KFgyA+V+z+dhpXWagKvDhIsV5YelPj2bYCTJTybZ+GVQ4+2vX6IR+3D49CCiVfNYfawmugrHvRuHSH5XO1pY0fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773763677; c=relaxed/simple;
	bh=dyHfUzxn+WRHkABD4Zym7SAQ8qwm3jiMXyfYYOKbgCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnkDGefhyt+vyF+OcvHLbxXETGOpeFWYD3JGIYPZowMa5FFVnnAl7eh1hd7tY6qc9m0HZdx8YSD8DP1ECtPAz8cOXnoYQqqqXvJJjw798g283OeaUAM0k+mDvhi+LzrgRdh3p/9yOa9kmMxVqkhU7Ah9iiu2h3TVPMXJIHdOfLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDN3AzuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDN3AzuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A70FC19424;
	Tue, 17 Mar 2026 16:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773763677;
	bh=dyHfUzxn+WRHkABD4Zym7SAQ8qwm3jiMXyfYYOKbgCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDN3AzuZq2tFjCXIP4IOhJPXio3ZA7HOh+BKFq0oDoxV+kIpLlcFn/vxT/yIzzGsx
	 xsQQX/31gI6rh2V5awMjLaUCYF/pwFBUcLvtUdkH0xUELrjuG3JB+Lqvr6Hiy/iIrR
	 W+E30ulUc18pAPIE7l7drh7Hit5Gk+9Re/vkkB7z+cyv4Iww+qnFvJWpcZLFnXoxvR
	 YOMcfPuod2OLzBPcb0/XRAY2dlc5Y2Fmf1caH8MCYus+ZCFBpTnfydP/ESy4ps1joU
	 wQNa4Oa/8A46iGx9/jR91guPOhzUUJ09RZaWXB5VMeU7q/wZ0/HxzJ1Jp0NDBrlExW
	 WGu6CGCmdlaAQ==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v2 2/2] fsr: always print error messages from xfrog_defragrange()
Date: Tue, 17 Mar 2026 17:07:40 +0100
Message-ID: <20260317160750.186873-3-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317160750.186873-1-cem@kernel.org>
References: <20260317160750.186873-1-cem@kernel.org>
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
V2: Update commit description

 fsr/xfs_fsr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index aa2a10839314..151f8ba42380 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1464,19 +1464,15 @@ packfile(
 		case 0:
 			break;
 	case -ENOTSUP:
-		if (vflag || dflag)
-			fsrprintf(_("%s: file type not supported\n"), fname);
+		fsrprintf(_("%s: file type not supported\n"), fname);
 		break;
 	case -EFAULT:
 		/* The file has changed since we started the copy */
-		if (vflag || dflag)
-			fsrprintf(_("%s: file modified defrag aborted\n"),
-					fname);
+		fsrprintf(_("%s: file modified defrag aborted\n"), fname);
 		break;
 	case -EBUSY:
 		/* Timestamp has changed or mmap'ed file */
-		if (vflag || dflag)
-			fsrprintf(_("%s: file busy\n"), fname);
+		fsrprintf(_("%s: file busy\n"), fname);
 		break;
 	default:
 		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
-- 
2.53.0

