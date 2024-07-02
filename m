Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9DB4C8B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883049; cv=none; b=tWdBLPzJWLmssGhnfa28dn5SWVvGlKC31BXqHRh6CQCxRinnJL+VIvFLDd8UwlJpu1Sg+r46Asr4D6h04+S++/vSpap0zKK6S0Y252K6+7oQAee0fhH53MBVXBQ38pXZKytSOis3X9ApO0uW0krYSkSu22k9mwNihpxq+F02SCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883049; c=relaxed/simple;
	bh=24KcNbhG0WoKjDoV29M0LYyph4nCDtaS9TAjWt7/Os8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGANsY4EUqZfTvP64gHyv+iWQ2uAt7wrdOo98Wi6CzSGeauYniGnJ1mLgSKZ8wvNXBoMm+gzysecdz139Kt0mOG1yTI/MurgE+R45+dOlP24V9iuJIu8h0uIqxCo7t2+//4ofhmhI32ihAC3r3quJBbydSfDePkaaybTwzxWlp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pP0nmYsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pP0nmYsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26FCC116B1;
	Tue,  2 Jul 2024 01:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883048;
	bh=24KcNbhG0WoKjDoV29M0LYyph4nCDtaS9TAjWt7/Os8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pP0nmYsCU4QrQPeGtxO6Xh6Aew7ftd8g0vDBDaeUHy4+IjU0K6LO3srVYyFBPngph
	 fuZ76RvaNfb3Lz8LS7620d4U/cuFx9xUE2/Sc6j7jnYB3+6KgQ97NiRRKLvvgLxmAe
	 9ZWTJiUK+WHdvux2IT8kYFS7HmZshLtj8ue+z08YVCJj/CwYhyObpvXDFGXTZLkJWi
	 Bkyvg3ZdpWc4IZkqulxTnUc8r7mYkbPjsTU0skgxcd7v2yWREhUACPYY24JNIrAxw1
	 /EDrVhofQgFD/TtCQ1Q1iFA7TdUakTlWBA2KOzl6PO+twnMr2NRq0WL2WB4GsTs+es
	 WehLWL9bD5sEA==
Date: Mon, 01 Jul 2024 18:17:28 -0700
Subject: [PATCH 2/2] man2: update ioctl_xfs_scrub_metadata.2 for parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121805.2010091.649906778403805436.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121771.2010091.1149497683237429955.stgit@frogsfrogsfrogs>
References: <171988121771.2010091.1149497683237429955.stgit@frogsfrogsfrogs>
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

Update the man page for the scrub ioctl to reflect the new scrubbing
abilities when parent pointers are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_scrub_metadata.2 |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)


diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 9963f1913e60..75ae52bb5847 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -109,12 +109,11 @@ must be zero.
 .nf
 .B XFS_SCRUB_TYPE_BMBTD
 .B XFS_SCRUB_TYPE_BMBTA
+.fi
+.TP
 .B XFS_SCRUB_TYPE_BMBTC
-.fi
-.TP
-.B XFS_SCRUB_TYPE_PARENT
 Examine a given inode's data block map, extended attribute block map,
-copy on write block map, or parent inode pointer.
+or copy on write block map.
 Inode records are examined for obviously incorrect values and
 discrepancies with the three block map types.
 The block maps are checked for obviously wrong values and
@@ -133,9 +132,22 @@ The inode to examine can be specified in the same manner as
 .TP
 .B XFS_SCRUB_TYPE_DIR
 Examine the entries in a given directory for invalid data or dangling pointers.
+If the filesystem supports directory parent pointers, each entry will be
+checked to confirm that the child file has a matching parent pointer.
 The directory to examine can be specified in the same manner as
 .BR XFS_SCRUB_TYPE_INODE "."
 
+.TP
+.B XFS_SCRUB_TYPE_PARENT
+For filesystems that support directory parent pointers, this scrubber
+examines all the parent pointers attached to a file and confirms that the
+parent directory has an entry matching the parent pointer.
+For filesystems that do not support directory parent pointers, this scrubber
+checks that a subdirectory's dotdot entry points to a directory with an entry
+that points back to the subdirectory.
+The inode to examine can be specified in the same manner as
+.BR XFS_SCRUB_TYPE_INODE "."
+
 .TP
 .B XFS_SCRUB_TYPE_SYMLINK
 Examine the target of a symbolic link for obvious pathname problems.

