Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199772BAF3;
	Thu, 20 Jun 2024 20:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916938; cv=none; b=hNpvdR0QqNsO7ej+xfjlL7FaEvTyBFJ4SO2zNa7yPm32aEoQW71/FTV2kFznkE9P66d6vTHbrxUt7zENWQMVZCfPzSujcYqCkUrq3dyAr9WQVjyg8zMjkJ3q6K/vFkDiOhXk0TUtMqF8LkJY/gyaZG8RBue+x45C6K/hS3qVlow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916938; c=relaxed/simple;
	bh=vKAKE6I1hbafZWd8FRpT3SI0azoqr0JyJnT7VcL4x/s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UbiCovlYbJPD+UPLBEkKabvE769v9u22dR2T72ZD2spk2G3PMJEfQQatjq2dlvBuUnuoyw+gLcB3FALMWZJsz9MJmq5yGN+XI1EX1JXg0vRTH6NqZzP6rs8FLz/2k9Q2cBGy3E1HltOK9Xu0+KxBYfla+N8c8JQP8BeHjKAFYPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMek0EZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMek0EZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E738AC2BD10;
	Thu, 20 Jun 2024 20:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916938;
	bh=vKAKE6I1hbafZWd8FRpT3SI0azoqr0JyJnT7VcL4x/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SMek0EZLaD3Y5VDibfuBMHuZfvi68CNSnAPXrcUFig7Xgzya5thHq1TmkvI1P0YcD
	 dtF9AbxXiGkvy011ZWHZKqiqRDNaD8erFPaBMcm7/bVQVH/M8hcVovFq6Z9bGi6Oq3
	 cBzcD7YYHFOyvqojphXN9+Xh5aeqUPtLNYwqV+2nqju6undxvv90hsTO4gCHAY5+hg
	 alpOgjRTKHAS9ar4XHoJynpzYHQSdTz8V8Ocl9bdU+fGC95xHapzV0LEMSn95DqFno
	 sTm3mGdBi400VnbbesdpAjzw1av6EOv2aAz5gGEyMEVOV/V/r2Du2remI4sk3RfexU
	 L41vEOGWwbKvQ==
Date: Thu, 20 Jun 2024 13:55:37 -0700
Subject: [PATCH 06/11] ltp/{fsstress,fsx}: make the exchangerange naming
 consistent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891669204.3034840.12862965793300424312.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
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

xchg_range/xchgrange -> exchangerange, since that's what the name has
become.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 ltp/fsstress.c |   24 ++++++++++++------------
 ltp/fsx.c      |   24 ++++++++++++------------
 2 files changed, 24 insertions(+), 24 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 9d2631f7f9..70e0616521 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -143,7 +143,7 @@ typedef enum {
 	OP_URING_WRITE,
 	OP_WRITE,
 	OP_WRITEV,
-	OP_XCHGRANGE,
+	OP_EXCHANGE_RANGE,
 	OP_LAST
 } opty_t;
 
@@ -273,7 +273,7 @@ void	uring_read_f(opnum_t, long);
 void	uring_write_f(opnum_t, long);
 void	write_f(opnum_t, long);
 void	writev_f(opnum_t, long);
-void	xchgrange_f(opnum_t, long);
+void	exchangerange_f(opnum_t, long);
 
 char	*xattr_flag_to_string(int);
 
@@ -343,7 +343,7 @@ struct opdesc	ops[OP_LAST]	= {
 	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	1, 1 },
 	[OP_WRITE]	   = {"write",	       write_f,		4, 1 },
 	[OP_WRITEV]	   = {"writev",	       writev_f,	4, 1 },
-	[OP_XCHGRANGE]	   = {"xchgrange",     xchgrange_f,	2, 1 },
+	[OP_EXCHANGE_RANGE]= {"exchangerange", exchangerange_f,	2, 1 },
 }, *ops_end;
 
 flist_t	flist[FT_nft] = {
@@ -2604,7 +2604,7 @@ chown_f(opnum_t opno, long r)
 
 /* exchange some arbitrary range of f1 to f2...fn. */
 void
-xchgrange_f(
+exchangerange_f(
 	opnum_t			opno,
 	long			r)
 {
@@ -2634,7 +2634,7 @@ xchgrange_f(
 	init_pathname(&fpath1);
 	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
 		if (v1)
-			printf("%d/%lld: xchgrange read - no filename\n",
+			printf("%d/%lld: exchangerange read - no filename\n",
 				procid, opno);
 		goto out_fpath1;
 	}
@@ -2642,7 +2642,7 @@ xchgrange_f(
 	init_pathname(&fpath2);
 	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
 		if (v2)
-			printf("%d/%lld: xchgrange write - no filename\n",
+			printf("%d/%lld: exchangerange write - no filename\n",
 				procid, opno);
 		goto out_fpath2;
 	}
@@ -2653,7 +2653,7 @@ xchgrange_f(
 	check_cwd();
 	if (fd1 < 0) {
 		if (v1)
-			printf("%d/%lld: xchgrange read - open %s failed %d\n",
+			printf("%d/%lld: exchangerange read - open %s failed %d\n",
 				procid, opno, fpath1.path, e);
 		goto out_fpath2;
 	}
@@ -2663,7 +2663,7 @@ xchgrange_f(
 	check_cwd();
 	if (fd2 < 0) {
 		if (v2)
-			printf("%d/%lld: xchgrange write - open %s failed %d\n",
+			printf("%d/%lld: exchangerange write - open %s failed %d\n",
 				procid, opno, fpath2.path, e);
 		goto out_fd1;
 	}
@@ -2671,7 +2671,7 @@ xchgrange_f(
 	/* Get file stats */
 	if (fstat64(fd1, &stat1) < 0) {
 		if (v1)
-			printf("%d/%lld: xchgrange read - fstat64 %s failed %d\n",
+			printf("%d/%lld: exchangerange read - fstat64 %s failed %d\n",
 				procid, opno, fpath1.path, errno);
 		goto out_fd2;
 	}
@@ -2679,7 +2679,7 @@ xchgrange_f(
 
 	if (fstat64(fd2, &stat2) < 0) {
 		if (v2)
-			printf("%d/%lld: xchgrange write - fstat64 %s failed %d\n",
+			printf("%d/%lld: exchangerange write - fstat64 %s failed %d\n",
 				procid, opno, fpath2.path, errno);
 		goto out_fd2;
 	}
@@ -2688,7 +2688,7 @@ xchgrange_f(
 	if (stat1.st_size < (stat1.st_blksize * 2) ||
 	    stat2.st_size < (stat2.st_blksize * 2)) {
 		if (v2)
-			printf("%d/%lld: xchgrange - files are too small\n",
+			printf("%d/%lld: exchangerange - files are too small\n",
 				procid, opno);
 		goto out_fd2;
 	}
@@ -2745,7 +2745,7 @@ xchgrange_f(
 		goto retry;
 	}
 	if (v1 || v2) {
-		printf("%d/%lld: xchgrange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
+		printf("%d/%lld: exchangerange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
 			procid, opno,
 			fpath1.path, inoinfo1, (long long)off1, (long long)len,
 			fpath2.path, inoinfo2, (long long)off2, (long long)len);
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 777ba0de5d..6ff5e3720f 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -176,7 +176,7 @@ int	check_file = 0;			/* -X flag enables */
 int	clone_range_calls = 1;		/* -J flag disables */
 int	dedupe_range_calls = 1;		/* -B flag disables */
 int	copy_range_calls = 1;		/* -E flag disables */
-int	xchg_range_calls = 1;		/* -0 flag disables */
+int	exchange_range_calls = 1;	/* -0 flag disables */
 int	integrity = 0;			/* -i flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
@@ -272,7 +272,7 @@ static const char *op_names[] = {
 	[OP_DEDUPE_RANGE] = "dedupe_range",
 	[OP_COPY_RANGE] = "copy_range",
 	[OP_FSYNC] = "fsync",
-	[OP_EXCHANGE_RANGE] = "xchg_range",
+	[OP_EXCHANGE_RANGE] = "exchange_range",
 };
 
 static const char *op_name(int operation)
@@ -1393,7 +1393,7 @@ do_insert_range(unsigned offset, unsigned length)
 static __u64 swap_flags = 0;
 
 int
-test_xchg_range(void)
+test_exchange_range(void)
 {
 	struct xfs_exch_range	fsr = {
 		.file1_fd = fd,
@@ -1425,7 +1425,7 @@ test_xchg_range(void)
 }
 
 void
-do_xchg_range(unsigned offset, unsigned length, unsigned dest)
+do_exchange_range(unsigned offset, unsigned length, unsigned dest)
 {
 	struct xfs_exch_range	fsr = {
 		.file1_fd = fd,
@@ -1473,7 +1473,7 @@ do_xchg_range(unsigned offset, unsigned length, unsigned dest)
 	if (ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &fsr) == -1) {
 		prt("exchange range: 0x%x to 0x%x at 0x%x\n", offset,
 				offset + length, dest);
-		prterr("do_xchg_range: XFS_IOC_EXCHANGE_RANGE");
+		prterr("do_exchange_range: XFS_IOC_EXCHANGE_RANGE");
 		report_failure(161);
 		goto out_free;
 	}
@@ -1487,13 +1487,13 @@ do_xchg_range(unsigned offset, unsigned length, unsigned dest)
 
 #else
 int
-test_xchg_range(void)
+test_exchange_range(void)
 {
 	return 0;
 }
 
 void
-do_xchg_range(unsigned offset, unsigned length, unsigned dest)
+do_exchange_range(unsigned offset, unsigned length, unsigned dest)
 {
 	return;
 }
@@ -2231,7 +2231,7 @@ test(void)
 		}
 		break;
 	case OP_EXCHANGE_RANGE:
-		if (!xchg_range_calls) {
+		if (!exchange_range_calls) {
 			log5(op, offset, size, offset2, FL_SKIPPED);
 			goto out;
 		}
@@ -2330,7 +2330,7 @@ test(void)
 			goto out;
 		}
 
-		do_xchg_range(offset, size, offset2);
+		do_exchange_range(offset, size, offset2);
 		break;
 	case OP_CLONE_RANGE:
 		if (size == 0) {
@@ -2936,7 +2936,7 @@ main(int argc, char **argv)
 			insert_range_calls = 0;
 			break;
 		case '0':
-			xchg_range_calls = 0;
+			exchange_range_calls = 0;
 			break;
 		case 'J':
 			clone_range_calls = 0;
@@ -3199,8 +3199,8 @@ main(int argc, char **argv)
 		dedupe_range_calls = test_dedupe_range();
 	if (copy_range_calls)
 		copy_range_calls = test_copy_range();
-	if (xchg_range_calls)
-		xchg_range_calls = test_xchg_range();
+	if (exchange_range_calls)
+		exchange_range_calls = test_exchange_range();
 
 	while (keep_running())
 		if (!test())

