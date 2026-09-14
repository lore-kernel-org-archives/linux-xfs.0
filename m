Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A85E38332A
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365074; cv=none; b=uWBPkDFZGqRnbyVTUGjhRoU8lcKpWKwnqpYMjB78Oj1sX5JlUj3iFBxxeCG+zVc5Dvoilan/r1HZD3NxB8gXBEuMrwttYJ8cHxiti85PAExqz/609KKdH+MHxFp175V1ys81GEiXW0m/GN4IUdku7dMy7o1qTCeN6H/rafNT56Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365074; c=relaxed/simple;
	bh=uagFbP2s4BbfjBWc8Vci2Y0aupbB/QBW55tHQEllVPk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlOPphuq5q7dzsxbZ+oATSNN6gzMa7W2yLVF/s0WdmMH+I94ehYXTLTpLbsYGtpUsneltxvx82SNgdnauC3D0LIKnrzTndY6jtNE6rVoZldTItzv1BHj4XWdiY+t3NzWEzgNeds7/SbJf03G2sxAQu63Mge+gbKwR6r/aa87/Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxyyMCIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxyyMCIb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 675F01F000FF;
	Mon, 14 Sep 2026 05:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789365069;
	bh=pQNgHAswxa5zuZBb2UqSftxjRZKv0pnnOAeMoZGoSfs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AxyyMCIbqgbw66bLkrTB8pl5Qa8Hb37XXjEU7wTACflhJWeLLB51ZDTjkhJc4xzrd
	 cg1eRldhQRcBjME9/AlYEhHWLyHCli9Oy7Wo9y8ZIxhMI/JVx2AfF/GHvG05OKW8Sd
	 SBuXra/YB5Y8jgrR6QQZSRAbEHT+vMlHciP/LLe3cRTS56hM1uDNuCUOEI1HnaXtef
	 f7PFFLPWjv36W+wMgH2YoYeMGIVj8jC+8QF4Rfa6IhUsDcnsMP/xYxY5UC0XayakTs
	 PZKkbHROQ+aync4TbDRHpXeUPJCLN5rLGT0bpu0Fb+LrH4TcP4/smrqjL5A6J0NXVv
	 04qMBmqWdMOhg==
Date: Sun, 13 Sep 2026 22:51:08 -0700
Subject: [PATCH 6/7] xfs_quota: open the filesystem mountpoint for quota
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484918.2108717.4779652680175945955.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Change xfs_quota's behavior so that it tries to open the filesystem
mountpoint when it's starting up.  This enables it to use the
quotactl_fd system call instead of the kernel having to do a path lookup
of the data device.  Doing so adds robustness against the data device
getting renamed (e.g. lvm rename) while xfs_quota is running.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 quota/init.h    |    2 ++
 quota/init.c    |   15 +++++++++++++++
 quota/project.c |    7 +++++++
 3 files changed, 24 insertions(+)


diff --git a/quota/init.h b/quota/init.h
index 9191d822e55819..e85cfa45580cb2 100644
--- a/quota/init.h
+++ b/quota/init.h
@@ -19,3 +19,5 @@ extern void	report_init(void);
 extern void	state_init(void);
 
 extern void init_cvtnum(unsigned int *, unsigned int *);
+
+void open_mnt_fds(void);
diff --git a/quota/init.c b/quota/init.c
index 9425827591c798..e7fae917d641b7 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -128,6 +128,19 @@ init_check_command(
 	return 0;
 }
 
+void
+open_mnt_fds(void)
+{
+	int		c;
+
+	for (c = 0; c < fs_count; c++) {
+		if (fs_table[c].mnt_fd < 0) {
+			/* if this fails, we fall back to path-based quotactl */
+			fs_table[c].mnt_fd = open(fs_table[c].fs_dir, O_RDONLY);
+		}
+	}
+}
+
 static void
 init(
 	int		argc,
@@ -189,6 +202,8 @@ init(
 		fs_path = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
 	else
 		fs_path = &fs_table[0];
+
+	open_mnt_fds();
 }
 
 int
diff --git a/quota/project.c b/quota/project.c
index 33449e01ef4dbb..9b057df75b6aed 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -296,6 +296,13 @@ _("%s: cannot setup path for project dir %s: %s\n"),
 					progname, optarg, strerror(error));
 				return 0;
 			}
+
+			/*
+			 * fs_table could have been arbitrarily rearranged by
+			 * fs_table_insert, so we need to try to open any new
+			 * mounts.
+			 */
+			open_mnt_fds();
 			break;
 		case 's':
 			type = SETUP_PROJECT;

