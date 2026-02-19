Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95142E6CAB
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544829; cv=none; b=i20/0X1p8PYt1f3zbQiWPfvYBi7AYu5PUpwQ/6npJAdNA8uhA9BS/WeTtgywPd4+DBUFcJy+5v99kHTYEvwzlHQOSvMvWAyacLAUI1M71aPLO/HMPZZwyg08VilQlik1zvnfrpH4ipTFLfVV4Gwysm70+kdBs5iEoq6jfVmzf7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544829; c=relaxed/simple;
	bh=XpWl8v1JWuxmYm5FQAiHMdBkq4xVx0qlyXyhWaGNOaE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lX5cFPOmULRdzM+RmmGeTra2ice+lrsWY5xJikJxfrAbrGS6ZrZexZfniEN1GS857n2QezlLoI9fdFsu3v1O2oPNl+w785rorKFdDPIL5LaS5ClTbgC/KNA2bkiyrXL4yeFl897fgaktg4/I2pLtaQCFLL5hp2IMbzsPxR27Eas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5609iYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5609iYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B23C4CEF7;
	Thu, 19 Feb 2026 23:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544829;
	bh=XpWl8v1JWuxmYm5FQAiHMdBkq4xVx0qlyXyhWaGNOaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i5609iYPgN9y2wNombmzpw4sYyOCSlfJLm6WxQ8xyJ/LnkBBndTfmhMdsPUYiM5LT
	 /AgLkSa+o7uL2XVMhc/m06/woCFo9hvv4I4APSwg3OQgasSuRobXJDhCzyp7mmfg42
	 eSyPiYuc+579O6WcsL8MXmSdRsmDbhqUg+e2cpk7fNV+CWBRimksulAnOeJDxDa8gm
	 hoaOG1omw3DvikR6mBKMo1aaSZQ+bugmqBWAt0kG0Lk4l4eylzkLLw/Ld1b+Wt8BMc
	 kIljNG5qTiPGZ/RgXL5WxS3ebmu385skNioX/VyViLD3rIHndGT7KsbkEeVcqumOuP
	 wsQlm7x1tX80w==
Date: Thu, 19 Feb 2026 15:47:09 -0800
Subject: [PATCH 2/6] xfs_logprint: print log data to the screen in host-endian
 order
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154457243.1286306.12744406304510860262.stgit@frogsfrogsfrogs>
In-Reply-To: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

