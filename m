Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C8943E9C3
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931466; cv=none; b=FM28ci+psi4vKfQO+XMnA2Sq8WqrqJwtTopYfCiA5zTx9h1auOknY1nB5J/1EQ9GnKQh+BhVItzxGFnL82q8ZL6kT+8E9dhK6dJAdVVzZKlV1XhSez90H1hKUCgSZhZbCVXyf2txirecIByydMKljJxRdBr+AnjgniIzn2Sb980=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931466; c=relaxed/simple;
	bh=y1xe6tHOK0Mrv0kZpC+VcRkHOJFaUfIyUx4aWJv9tQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5hY0hEVe1q0LRNZ1Rk2jauEPk6joVHTz89eMhPlpduBX/wWH2I4B9bSbuXXzSp1+OB77zfHL46ZaHJccoeYC8YQBGQsC0trcRFaT7GZEbq7TTbD0CCLa6pzLZCEJ6ZJa4EYbLOJIqI4ZHxIiiuJ1WtkaJilH5PlQEC9JMH/Z+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTeIhVnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTeIhVnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F63C19421;
	Tue, 20 Jan 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931464;
	bh=y1xe6tHOK0Mrv0kZpC+VcRkHOJFaUfIyUx4aWJv9tQ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PTeIhVnVnsKjcn5ALH5bKJjfPOWQAKlXqDcML9SgWuw4F+u/McZEhlcYZasCzsXOK
	 TbIopEMwip8PAS1u8MaZpQGmb7/Skxpftr4ZJ1uXw1UyMrL8Dq3wR8QJpe+05eFfkF
	 oyDEDmGv6luc8LB5BVoAxHP9foix/o8JBuNoxvHtCTIlJaHRVOZ64ZBmnU7snKyKd7
	 K3BYLLTO6loVa7IyO0ux3+HFNKZUaawMUzUODbOzSqNiHgqVcwe8Eb30pwMXLVnNvu
	 Bw7HHkQ8aoqk13MITwut45V+E0yWsrfV3hnGSy7dYXKSRWIwPoEQ/i6h946DSR4IT0
	 LcIfspwjkPrnA==
Date: Tue, 20 Jan 2026 09:51:04 -0800
Subject: [PATCH 2/5] xfs_logprint: print log data to the screen in host-endian
 order
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176893137107.1079372.3049439466012040581.stgit@frogsfrogsfrogs>
In-Reply-To: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a cli option so that users won't have to byteswap u32 values when
they're digging through broken logs on little-endian systems.  Also make
it more obvious which column is the offset and which are the byte(s).

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 logprint/logprint.h      |    1 +
 logprint/log_print_all.c |    5 +++--
 logprint/logprint.c      |    5 +++++
 man/man8/xfs_logprint.8  |    4 ++++
 4 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/logprint/logprint.h b/logprint/logprint.h
index aa90068c8a2af1..2ba868a9155108 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -16,6 +16,7 @@ extern int	print_transactions;
 extern int	print_overwrite;
 extern int	print_no_data;
 extern int	print_no_print;
+extern int	print_host_endian;
 
 /* exports */
 extern time64_t xlog_extract_dinode_ts(const xfs_log_timestamp_t);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 0afad597bb6ce0..5a01e049b8bb50 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -55,8 +55,9 @@ xlog_recover_print_data(
 
 		while (j < nums) {
 			if ((j % 8) == 0)
-				printf("%2x ", j);
-			printf("%8x ", *dp);
+				printf("%2x: ", j);
+			printf("%08x ", print_host_endian ? be32_to_cpu(*dp) :
+							    *dp);
 			dp++;
 			j++;
 			if ((j % 8) == 0)
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 7c69cdcc7cfacb..34df3400c8d544 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -24,6 +24,7 @@ int	print_buffer;
 int	print_overwrite;
 int     print_no_data;
 int     print_no_print;
+int	print_host_endian;
 static int	print_operation = OP_PRINT;
 static struct libxfs_init x;
 
@@ -37,6 +38,7 @@ Options:\n\
     -d	            dump the log in log-record format\n\
     -e	            exit when an error is found in the log\n\
     -f	            specified device is actually a file\n\
+    -h		    print hex data in host-endian order\n\
     -l <device>     filename of external log\n\
     -n	            don't try and interpret log data\n\
     -o	            print buffer data in hex\n\
@@ -171,6 +173,9 @@ main(int argc, char **argv)
 				x.log.name = optarg;
 				x.log.isfile = 1;
 				break;
+			case 'h':
+				print_host_endian = 1;
+				break;
 			case 'i':
 				print_inode++;
 				break;
diff --git a/man/man8/xfs_logprint.8 b/man/man8/xfs_logprint.8
index 16e881ee8f230d..d64af5963f1a8a 100644
--- a/man/man8/xfs_logprint.8
+++ b/man/man8/xfs_logprint.8
@@ -76,6 +76,10 @@ .SH OPTIONS
 an ordinary file with
 .BR xfs_copy (8).
 .TP
+.B \-h
+Print u32 hex dump data in host-endian order.
+The default is to print without any endian decoding.
+.TP
 .BI \-l " logdev"
 External log device. Only for those filesystems which use an external log.
 .TP

