Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C7910E9;
	Fri, 11 Oct 2024 01:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611141; cv=none; b=rhO28D5q2KQEfjDap9xbF3X2FF4eGWywaGASNnsSDzSIPAbiutbFF5udTW/oN+iOKL5v2wdW6ys9Jh2arG6ZIUvcKxkzIQngHm2jgSIOBzedy2u1RzwdbhYvHMTZ7z5RN8AEwlWCnlwDpfxMnmF0szsoOYLEYrJbcKBU74L+NUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611141; c=relaxed/simple;
	bh=DTYKBwEqFZZSw5FMkfwkAKepyF1So9fXMZK7WGG1mWM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cp/UlDQOMVqdBalqHoL/Pwfnw4dV0BkGv/OXuaKThSHqquGGOn/MmD5pNpW07CJ9gkrTOETpWsr4lxS+SjivsDvoyjMuWnI8mRP6DrEhCbhz3kVxV2AueydYc0aeNi8TZplju4xunNS4FIT3bsjL++H6TqjnBsAx2ZMKO3J7Hkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVU3ENlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVU3ENlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8001AC4CEC5;
	Fri, 11 Oct 2024 01:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611140;
	bh=DTYKBwEqFZZSw5FMkfwkAKepyF1So9fXMZK7WGG1mWM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jVU3ENlES64JAcBwgac9tZKdxXCz0qRavts4/eIeItxKGpW+lE23Zieo0qbwQTIiJ
	 H/qYK1J1RqSOp+yA6TRpEkERkIGmZk/sRz5igKx9/USFr+Kph1JbL3bhSfq7/d960j
	 JNujSjCUveD0wUHCYBN0Hbq1xEaDI41xCKa5CVDUUoIf3BN/gyJHeSwWxFg8LwIkDc
	 YVg59tLo14DIhxZ9oKzAHNx2BUwdKSphmz9t+Ia1uA9kZ0FvgGCn9fYgpelx3jOBpy
	 iu/go+MhSbP5yBxAo7MDpmyz4SN6L8B130bPCDIho4O0OMZGH/ErwFRovhUhoGTWBi
	 vgGXwAHDUOgSA==
Date: Thu, 10 Oct 2024 18:45:40 -0700
Subject: [PATCH 2/4] xfs: update tests for quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860659125.4189705.14212623337550950472.stgit@frogsfrogsfrogs>
In-Reply-To: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
References: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
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

Update fstests to handle quota files in the metadir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/common/xfs b/common/xfs
index 6bd411cad67f5f..7198a5579d4cfa 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1949,6 +1949,24 @@ _scratch_xfs_find_metafile()
 			return 0
 		fi
 		;;
+	"uquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/user"
+			return 0
+		fi
+		;;
+	"gquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/group"
+			return 0
+		fi
+		;;
+	"pquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/project"
+			return 0
+		fi
+		;;
 	esac
 
 	sb_field="$(_scratch_xfs_get_sb_field "$metafile")"

