Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A69C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNjnT0BL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCD2C433C8;
	Sun, 31 Dec 2023 23:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066064;
	bh=W7EaV+SZo5/9boffTuMfBXBm4JR9DxZ+BgjQTgAM4GQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oNjnT0BLg+SLP9x1dXoL5fFMPOk4Sz4l6XQ+u5y0OaZuEQnQeOjry1QBUo6MlU4A4
	 xHEKiE2T7PaxPU0XoNdrLVazM2/skcw2DDOUJ/2kX228eA0Ztgka1NSC9ujfbO9jJ6
	 Kkxjl3/KcOFsY4M575kMw769+uaSiwvqy52TIoQD2x4tHPM9NkXuf3XqVJxxYOr+AD
	 UNvqKzQZ9ryaOAR1UJ0RvmyDTkdoomQNMQB1Dji+/NLucUi3HfHEhqaG7NzrW5K6oR
	 lYZu5ZvJ0g1YnuCZcc4763YTbe1iICRKKracxES1vjql4OV3IGY6mQ0V84n6e43ePI
	 TA9AKDt+Dsa1w==
Date: Sun, 31 Dec 2023 15:41:03 -0800
Subject: [PATCH 44/58] xfs_repair: check metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010533.1809361.10226253768657395190.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Check whether or not the metadata inode flag is set appropriately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index f2da4325d5e..4af7c91d5c9 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2669,6 +2669,20 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			}
 		}
 
+		if (flags2 & XFS_DIFLAG2_METADIR) {
+			xfs_failaddr_t	fa;
+
+			fa = libxfs_dinode_verify_metadir(mp, dino, di_mode,
+					be16_to_cpu(dino->di_flags), flags2);
+			if (fa) {
+				if (!uncertain)
+					do_warn(
+	_("inode %" PRIu64 " is incorrectly marked as metadata\n"),
+						lino);
+				goto clear_bad_out;
+			}
+		}
+
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
 		    !xfs_has_reflink(mp)) {
 			if (!uncertain) {

