Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB51B424D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636782; cv=none; b=Z9tfv5mQ5wvAr43vHPPNngNUuAgzRFtBw6gnTqTSN7i7GpgjC5cb7yQgEMAZVB+8bQr0dDoU9lCzoUSJ65FDBGYmrJW9JEHlXdLBimN0znJV7fEDhFVWvjU5X87R4mnFKWiBOHUBInewUKey84YLTQC2G2oi8+R+hyKfjx7+AJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636782; c=relaxed/simple;
	bh=lcd94iGFG/RIGBiHplSu0ztAyKSUF0xlBN8YAaGQ/ws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfA16DDbQvbpDlTO16pjRuzXTfmXwXV7Z/pDo6pFd/kbzugcfnQxPkj+iHxrBd8MPA55bNG16+AUvcMWeCmU43ZlY2RZt6rsbzPMwmYSHqjbe/kyU16zpVcintFUQkBv4ZddUMOZ2TP4t7/l+s1TWE65rORbvZIlM152Lp3rubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUlaPAbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUlaPAbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50FFC4CECE;
	Thu, 19 Dec 2024 19:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636782;
	bh=lcd94iGFG/RIGBiHplSu0ztAyKSUF0xlBN8YAaGQ/ws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XUlaPAbUTR7tbbgiUWWah0eApWQJSfPBnpIDxX4ssZCCjiMVSg515J1xpgNvLkC9G
	 QIuOKrHz7OrWgaUJjWwwJ5cUkGrueX0I4g9Kk/92FZOVXHFyeJjlMpd0cB0GgQ6iO1
	 B3ULPgQ7m/Yc76obIBslEgKfObrf45VRIQmScpHeb5N9Obx46cjGxo6nHLkU2Ew24D
	 nsH9PNg3YbqX0wCtQOX/6/QTtXxgWbcZTY6+ogMhp0GOcvw/Rj4b0+0/kEksBy30nq
	 xEYXji8Vh3hfdhct+h6QSZtTM//5lt2qHB0nHolntTOlBsiMFOsGXMxuOKSpm0uxFl
	 lOzG5lygOGpGg==
Date: Thu, 19 Dec 2024 11:33:02 -0800
Subject: [PATCH 37/37] xfs: enable realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580394.1571512.11770786654773758153.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Permit mounting filesystems with realtime rmap btrees.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   12 ++++++++----
 fs/xfs/xfs_super.c   |    6 ------
 2 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3c1bce5a4855f2..a69967f9d88ead 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1282,11 +1282,15 @@ xfs_growfs_rt(
 	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
 		goto out_unlock;
 
-	/* Unsupported realtime features. */
+	/* Check for features supported only on rtgroups filesystems. */
 	error = -EOPNOTSUPP;
-	if (xfs_has_quota(mp) && !xfs_has_rtgroups(mp))
-		goto out_unlock;
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (!xfs_has_rtgroups(mp)) {
+		if (xfs_has_rmapbt(mp))
+			goto out_unlock;
+		if (xfs_has_quota(mp))
+			goto out_unlock;
+	}
+	if (xfs_has_reflink(mp))
 		goto out_unlock;
 
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 394fdf3bb53531..ecd5a9f444d862 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1767,12 +1767,6 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_has_rmapbt(mp) && mp->m_sb.sb_rblocks) {
-		xfs_alert(mp,
-	"reverse mapping btree not compatible with realtime device!");
-		error = -EINVAL;
-		goto out_filestream_unmount;
-	}
 
 	if (xfs_has_exchange_range(mp))
 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_EXCHRANGE);

