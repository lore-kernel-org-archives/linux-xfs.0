Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2219138A;
	Sat, 24 Feb 2024 01:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737225; cv=none; b=ZOe7nMAiS1H2LIUTcMeZQqbS6RePmTyniWdoZI5wxS6tF5ABfiSKvKc5Tf9SA0zY1f26fxWqHIESNBBPWVb1DSKyRSiFIHL7PFHQsLEM1R+t1Qe+K7jCg96BNHgx65njoNyCd76a4te4lGytzy4QWxwmqHGWIAsg8bNVlABvREg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737225; c=relaxed/simple;
	bh=knLP2zr5fAXP6Cpmw5RzHnQSPecMuovlF/AwUgBFOo8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFITW/x1/se+sQ60SZ/sIFR82O9Rorz+Y6lCcgmL4lBZCpGL1uxtmuLuaFxB6FXmXqXkCZpXUyV5LcSiKHuKLlZWw1nLQ/ab/bjU+j2S2ajlHr62PbaohAU7cXAeL9ffQ/Ve/3QVOhplX4pY3rzkkr/SGEYonO9ubgeq3a9zmFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMgYci3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMgYci3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F264C433C7;
	Sat, 24 Feb 2024 01:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737225;
	bh=knLP2zr5fAXP6Cpmw5RzHnQSPecMuovlF/AwUgBFOo8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UMgYci3iSWzWUCKqNPe2LjT8yUUaPSgiJroJJGSELoNoDgar0TeXU+HhyWV1Bsm+k
	 bLpR8sLx9gxcnwWNapzDzofGynEIgrcAiZXlc8XMu3OGRzZmuWcSAIH06iVGvKQc79
	 KEcgMg2Neir/nRmXJpzh/TQy8tqrkn4zUlETcKtuT/A7xzS7ZGEWkXI6XHScm6+Maw
	 RGidKXTiRVeargN/g+D+TDFJ620f4k4bb0phjXaRiT6wG3wc1KbYiXWAsKfqmrJyVB
	 qe/rWxzVHWUPiGrrunwqneRFKEf/G4jhY0U113r2oeBSzR2HnfvFoWA1euQRtc2nr5
	 NeKgJxgPB3/Pg==
Date: Fri, 23 Feb 2024 17:13:44 -0800
Subject: [PATCH 4/4] xfs: create debugfs uuid aliases
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873668513.1861246.6254947828078279848.stgit@frogsfrogsfrogs>
In-Reply-To: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
References: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
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

Create an alias for the debugfs dir so that we can find a filesystem by
uuid.  Unless it's mounted nouuid.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   11 +++++++++++
 2 files changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7cfd209404365..63649c259b9c5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -235,6 +235,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct dentry		*m_debugfs;	/* debugfs parent */
+	struct dentry		*m_debugfs_uuid; /* debugfs symlink */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 69f1c1d85edf6..29a53874490cc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -768,6 +768,7 @@ xfs_mount_free(
 	if (mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_ddev_targp);
 
+	debugfs_remove(mp->m_debugfs_uuid);
 	debugfs_remove(mp->m_debugfs);
 	xfs_timestats_destroy(mp);
 	kfree(mp->m_rtname);
@@ -1799,6 +1800,16 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
+	if (xfs_debugfs && mp->m_debugfs && !xfs_has_nouuid(mp)) {
+		char	name[UUID_STRING_LEN + 1];
+
+		snprintf(name, UUID_STRING_LEN + 1, "%pU", &mp->m_sb.sb_uuid);
+		mp->m_debugfs_uuid = debugfs_create_symlink(name, xfs_debugfs,
+				mp->m_super->s_id);
+	} else {
+		mp->m_debugfs_uuid = NULL;
+	}
+
 	return 0;
 
  out_filestream_unmount:

