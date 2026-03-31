Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8223E0C44
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 12:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960008; cv=none; b=RlBtERC6/7fkXdYgFHpUu6P5vhy1+ly1Kb0GWgvRrYHNBczXCYLRJr653LnmDY7/17/dPSOi6ovPlZrSzwGinG9smd/uM3r2THi+pYsxYrAASwPZgeQBK3yTzfOmoVOPPTwr5vnjJSbRpenf+57ZQpEE7MfNWzQCB5nHTV09OvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960008; c=relaxed/simple;
	bh=/9zQlxPmQrIeI57KtYGtRA8CmrOn2y9HXROLD8BxMi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl0+q4wXz0Rq9j/Th7nRlAcU/Zy0UDXkZUg1jCFI2PVLPcr9mtUM+Xy5C+WInAPlZ8oF/wMQN/sdlmtoI8lhg9k0p9wqpbFIj8vGJ3BLXw14H62f0VHK7lucdZhRCEqdUxor/tnEN8pTeshnUb1j2LKGyYpebVn2Z+ghqo+oHjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfBrADRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfBrADRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439FFC19423;
	Tue, 31 Mar 2026 12:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774960008;
	bh=/9zQlxPmQrIeI57KtYGtRA8CmrOn2y9HXROLD8BxMi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfBrADRSUT/aAWvM8crK/XwVswe5f4OG0k8MJNmu+zPvSyWfbYo0S2chCx4eMJEjn
	 DF0tOR8vyoXhP5oHk3mNUZhpIM9Ba0NxBk9nAmKlKjnkOZjiuse/gaVpyMcq6wb2+x
	 DU7QJ2ShljTZZlZi/XKEgRZMQmkoQ/fJBXxlaoAc21aJZzpf1PSwVKsgnB9A2bf5mU
	 M2cLSnRIku+i/VjQOjKvHHjgp/ZlhyGhexxGiwB2BKvRVoo7MeWwUNfRYlWjhcZeuu
	 O8dBpl1xPM96cdj/emNbaYYYjhy7RkvDRqSKyMo7kiwH15Uk+yQpQljjxM/FpJdVbO
	 bn4SxRhb3TPfA==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v3 2/2] fsr: always print error messages from xfrog_defragrange()
Date: Tue, 31 Mar 2026 14:26:31 +0200
Message-ID: <20260331122639.100956-3-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331122639.100956-1-cem@kernel.org>
References: <20260331122639.100956-1-cem@kernel.org>
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
V3: Rebase on top of patch 1 changes
V2: Update commit description

 fsr/xfs_fsr.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 390f7c5276df..24617f55e329 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1464,19 +1464,14 @@ packfile(
 		case 0:
 			break;
 	case ENOTSUP:
-		if (vflag || dflag)
-			fsrprintf(_("%s: file type not supported\n"), fname);
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

