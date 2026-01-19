Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AF037BE63
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832854; cv=none; b=u98X/xq+M3KHKgugT8HhXIdlpx8ogRgD7MyGyv+az+4+zuCgOeFW8C9BpLylPL2icovI/RdLQGQKZvx7Y0Asg8MWD+JqmfmrG97dyLMR+Uyu20uZ74lyDPn6KjVOdxmyglM4vkYOUZtiTcw+8KMgGTM8/UGg5dSq14UMQGlwWJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832854; c=relaxed/simple;
	bh=VnslPnkYqom809reiGpKaYN1agVhMkyGAQVmbnLxqhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6GgKa/cBBnqAQGvVsRnUfNyNTfSEDDDknhLzkPKFrygo06uvQFjrWCsH0A3CImEP1s68oC0o8tBcQy89kBZFs4opzsk3AUm87lssnLNCiGNo9Dk5Z/xrhht7qpeSJeu9eN6z+jrr9HfXCLA3p7Y9ycBw3XF8EHaz1TyOX+g8Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gg/AanP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gg/AanP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5C6C19424;
	Mon, 19 Jan 2026 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832854;
	bh=VnslPnkYqom809reiGpKaYN1agVhMkyGAQVmbnLxqhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gg/AanP42gbcYgyUQzJ3Vl9OLML/ZV1hZkvBo4bMyrz1qsK+/+PQdASyv5E2vViY/
	 gUsOQf37ynnB1Nf33MA4+myAtL89Szq3YJuf2a+XM28Xhjwm1dtX9hiMwrpuKTECs2
	 9YdT9ve0EzQMwN4EsXQ+mEItqQfHiu9AcJ7c7KADrRG8g1HZnVpYMgk/MlTGTyrI2D
	 hvYHw5ldtqmAovxX8w36KBfFqfL/yhUK8fmwm58WEGb7+s3b85abGOBWMwFoNZlRoD
	 JRra4FACX/OyUUuwSrMlKAgW+6v4r+OIX9vPpbZi4EyjLooxtOP98NU1u04rjrSpNe
	 h/2gZ0ZidWszQ==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 2/2] fsr: Always print error messages from xfrog_defragrange()
Date: Mon, 19 Jan 2026 15:26:51 +0100
Message-ID: <20260119142724.284933-3-cem@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119142724.284933-1-cem@kernel.org>
References: <20260119142724.284933-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Error messages when xfrog_defragrange() are only printed when
verbose/debug flages are used.

We had reports from users complaining it's hard to find out error
messages in the middle of dozens of other informational messages.

Particularly I think error messages are better to be printed
independently of verbose/debug flags, so unconditionally print those.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fsr/xfs_fsr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 8845ff172fcb..fadb53af062d 100644
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
2.52.0

