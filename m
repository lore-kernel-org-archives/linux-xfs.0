Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DA6411664
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186739; cv=none; b=RjLFvFvbICgsAfHosriX25DFhmTB+OKo8MLza2r4gJSRhM5TJtwuQ+UR+KuGmnCOY1BfcJj2v4LUcDUAH/981cGgx9I9cpuXpJWbLceTRix9Y3U1IN8QwYYgV7qmHT8619bfslNVi2k+W7hS8MfPz+jkxql4d0XwN+4RuQfsy04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186739; c=relaxed/simple;
	bh=py/VYKXAticp4CLi4Ewk9FYGBTro7E/UlkXaPz+OBWI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LUiU2x2u6Of6Cn+WP4ngAB6f1f23u1JewTvuYrLlIPpVJtCyLlC3XXbG9DhfJ4IGH3j44AP1TSTvc97uGkSoguoz/SKR0Up7xprJi1XDzw7Ysowz31X9qgbEfRefDI50hnYlLHZ2xCguqotP49tb5dZkucnf9YbSkGEumky9vac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+hXWMdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+hXWMdy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B5D171F0089C;
	Thu, 11 Jun 2026 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186737;
	bh=yRODLjZV2W90lbb2gU6TR0prtaITvwSNJFJjIITibN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=g+hXWMdypJfgk8/MnrnvjqR1aVzpoQ9XzlNZM3ISmJYyzsFgcBSBRh7tiZMa/6z+t
	 wMY51kfXjOEKQAIvNX8Hb+pBM/jjt/BmjKGnFQPxrOdMUxqYaLP9uYzuau5TPhobHT
	 kyFgWMubmqo9/K61XhZJWimM+PM7NiqFyI1Ok0vPWZQU9Rgx9PD/CwEIkSUNlrx9Ng
	 jonVSsHYvC5sE9Z1IJp74wUR29dcG0wkza2E1eeUB20+/ovrCVVM/v6w/vRZkDjj8F
	 YPK/qAYnzecVp7aZlEBdQdRS34b6/G1H5scDbcoxeuN8LoinzuL3MWe9mzex8S6i+n
	 f0Pk9GAqmY24Q==
Date: Thu, 11 Jun 2026 07:05:37 -0700
Subject: [PATCH 3/6] xfs_healer_start: check listmount when doing a --check
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118661298.728615.3080573416824854151.stgit@frogsfrogsfrogs>
In-Reply-To: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex noticed that xfs_healer_start doesn't try out listmount() when
it's doing a --check.  Because systemd uses --check for an
ExecCondition, if it's run on a pre-6.9 kernel (very unlikely) then the
service will fail instead of simply not being run.  Fix that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer_start.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)


diff --git a/healer/xfs_healer_start.c b/healer/xfs_healer_start.c
index 19fd132808611c..6bf2b9bf854e6d 100644
--- a/healer/xfs_healer_start.c
+++ b/healer/xfs_healer_start.c
@@ -157,6 +157,28 @@ handle_mount_event(
 	}
 }
 
+/* Make sure listmount actually works so we can start up existing mounts */
+static int
+check_listmount(
+	int			mnt_ns_fd)
+{
+	uint64_t		mnt_ids[1];
+	uint64_t		cursor = LISTMOUNT_INIT_CURSOR;
+	int			ret;
+
+	ret = libfrog_listmount(LSMT_ROOT, mnt_ns_fd, &cursor, mnt_ids, 1);
+	if (ret >= 0)
+		return 0;
+
+	if (errno == ENOSYS)
+		fprintf(stderr, "%s\n",
+ _("This program requires the listmount system call."));
+	else
+		perror("listmount");
+
+	return -1;
+}
+
 #define NR_MNT_IDS		(32)
 
 /* Start healer services for existing XFS mounts. */
@@ -336,6 +358,10 @@ main(
 	}
 
 	if (support_check) {
+		ret = check_listmount(mnt_ns_fd);
+		if (ret)
+			goto out;
+
 		/*
 		 * We're being run as an ExecCondition process and we've
 		 * decided to start the main service.  There is no need to wait

