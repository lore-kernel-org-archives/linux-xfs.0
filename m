Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617901CC156
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724337814; cv=none; b=San4/FYwnDHmjMx8zRLRnbv9ZjZukDl9mC48NyA3/WY48Zv9mwCesw3ob8Ov2VIsodoo2pq9tCJo0q0VlqkB2keN5RQQG0L+NDs6BDIL2cS/h8D56f5vXEwtoJD1hFyLUcFK92+vsi8+BUpFzpj4ZFlrEc2ln298BFS91iYnHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724337814; c=relaxed/simple;
	bh=4DbLCv0FOxOQxg+mWq/PzeDSWfw5ancqHBXanz4F/ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PraYe/8Ev39LetmHrQn/D/iw3qnmXXAuFcqXDV8PmL384LNLXo02dvx68ap6ayCYx+t2fSgGq2IiSFcPcq/hf9HISVg01vAVRO6f4ogpi5/QZdKfWMdnpPTNTtRIiTuZyP2+LHyQ3GFHDO0NRZg1L20u+yiDwPS+okuf+NFAEVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d00kANQe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d00kANQe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724337811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/W8WvyXJ60+OaZU3sIPBlplKGGwrBzHYg3dZWzZWX+8=;
	b=d00kANQehVT9KPJTAE75gm8oIXbXSEqVXOiArJhBZG+Yti5Xdo8EC9HR+gz0o42kNg9BRV
	OLkQW/rB4FppGyD3CSbMuNjo6RWd5lIub/ra05TsrUtJ7AIrxlzt6eUHObLChfGaWHyUll
	VwZOx4cKSLni7XKLjIBJD6BwCY7gAyo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-gXmamw1TOQiLJQmgY7koGg-1; Thu,
 22 Aug 2024 10:43:29 -0400
X-MC-Unique: gXmamw1TOQiLJQmgY7koGg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A60E61955D4E;
	Thu, 22 Aug 2024 14:43:28 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.33.147])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6759E19560A3;
	Thu, 22 Aug 2024 14:43:27 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH 2/3] fsx: support eof page pollution for eof zeroing test coverage
Date: Thu, 22 Aug 2024 10:44:21 -0400
Message-ID: <20240822144422.188462-3-bfoster@redhat.com>
In-Reply-To: <20240822144422.188462-1-bfoster@redhat.com>
References: <20240822144422.188462-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

File ranges that are newly exposed via size changing operations are
expected to return zeroes until written to. This behavior tends to
be difficult to regression test as failures can be racy and
transient. fsx is probably the best tool for this type of test
coverage, but uncovering issues can require running for a
significantly longer period of time than is typically invoked
through fstests tests. As a result, these types of regressions tend
to go unnoticed for an unfortunate amount of time.

To facilitate uncovering these problems more quickly, implement an
eof pollution mode in fsx that opportunistically injects post-eof
data prior to operations that change file size. Since data injection
occurs immediately before the size changing operation, it can be
used to detect problems in partial eof page/block zeroing associated
with each relevant operation.

The implementation takes advantage of the fact that mapped writes
can place data beyond eof so long as the page starts within eof. The
main reason for the isolated per-operation approach (vs. something
like allowing mapped writes to write beyond eof, for example) is to
accommodate the fact that writeback zeroes post-eof data on the eof
page. The current approach is therefore not necessarily guaranteed
to detect all problems, but provides more generic and broad test
coverage than the alternative of testing explicit command sequences
and doesn't require significant changes to how fsx works. If this
proves useful long term, further enhancements can be considered that
might facilitate the presence of post-eof data across operations.

Enable the feature with the -e command line option. It is disabled
by default because zeroing behavior is inconsistent across
filesystems. This can also be revisited in the future if zeroing
behavior is refined for the major filesystems that rely on fstests
for regression testing.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 ltp/fsx.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 1389c51d..20b8cd9f 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -178,6 +178,7 @@ int	dedupe_range_calls = 1;		/* -B flag disables */
 int	copy_range_calls = 1;		/* -E flag disables */
 int	exchange_range_calls = 1;	/* -0 flag disables */
 int	integrity = 0;			/* -i flag */
+int	pollute_eof = 0;		/* -e flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
 int	aio = 0;
@@ -983,6 +984,58 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
 	}
 }
 
+/*
+ * Pollute the EOF page with data beyond EOF prior to size change operations.
+ * This provides additional test coverage for partial EOF block/page zeroing.
+ * If the upcoming operation does not correctly zero, incorrect file data will
+ * be detected.
+ */
+void
+pollute_eofpage(unsigned int maxoff)
+{
+	unsigned offset = file_size;
+	unsigned pg_offset;
+	unsigned write_size;
+	char    *p;
+
+	if (!pollute_eof)
+		return;
+
+	/* write up to specified max or the end of the eof page */
+	pg_offset = offset & mmap_mask;
+	write_size = MIN(PAGE_SIZE - pg_offset, maxoff - offset);
+
+	if (!pg_offset)
+		return;
+
+	if (!quiet &&
+	    ((progressinterval && testcalls % progressinterval == 0) ||
+	    (debug &&
+	     (monitorstart == -1 ||
+	     (offset + write_size > monitorstart &&
+	      (monitorend == -1 || offset <= monitorend)))))) {
+		prt("%lld pollute_eof\t0x%x thru\t0x%x\t(0x%x bytes)\n",
+			testcalls, offset, offset + write_size - 1, write_size);
+	}
+
+	if ((p = (char *)mmap(0, PAGE_SIZE, PROT_READ | PROT_WRITE,
+			      MAP_FILE | MAP_SHARED, fd,
+			      (off_t)(offset - pg_offset))) == (char *)-1) {
+		prterr("pollute_eofpage: mmap");
+		return;
+	}
+
+	/*
+	 * Write to a range just past EOF of the test file. Do not update the
+	 * good buffer because the upcoming operation is expected to zero this
+	 * range of the file.
+	 */
+	gendata(original_buf, p, pg_offset, write_size);
+
+	if (munmap(p, PAGE_SIZE) != 0)
+		prterr("pollute_eofpage: munmap");
+}
+
 /*
  * Helper to update the tracked file size. If the offset begins beyond current
  * EOF, zero the range from EOF to offset in the good buffer.
@@ -990,8 +1043,10 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
 void
 update_file_size(unsigned offset, unsigned size)
 {
-	if (offset > file_size)
+	if (offset > file_size) {
+		pollute_eofpage(offset + size);
 		memset(good_buf + file_size, '\0', offset - file_size);
+	}
 	file_size = offset + size;
 }
 
@@ -1143,6 +1198,9 @@ dotruncate(unsigned size)
 
 	log4(OP_TRUNCATE, 0, size, FL_NONE);
 
+	/* pollute the current EOF before a truncate down */
+	if (size < file_size)
+		pollute_eofpage(maxfilelen);
 	update_file_size(size, 0);
 
 	if (testcalls <= simulatedopcount)
@@ -1305,6 +1363,9 @@ do_collapse_range(unsigned offset, unsigned length)
 
 	log4(OP_COLLAPSE_RANGE, offset, length, FL_NONE);
 
+	/* pollute current eof before collapse truncates down */
+	pollute_eofpage(maxfilelen);
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -1356,6 +1417,9 @@ do_insert_range(unsigned offset, unsigned length)
 
 	log4(OP_INSERT_RANGE, offset, length, FL_NONE);
 
+	/* pollute current eof before insert truncates up */
+	pollute_eofpage(maxfilelen);
+
 	if (testcalls <= simulatedopcount)
 		return;
 
@@ -2385,6 +2449,7 @@ usage(void)
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
+	-e: pollute post-eof on size changes (default 0)\n\
 	-f: flush and invalidate cache after I/O\n\
 	-g X: write character X instead of random generated data\n\
 	-i logdev: do integrity testing, logdev is the dm log writes device\n\
@@ -2783,7 +2848,7 @@ main(int argc, char **argv)
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
 	while ((ch = getopt_long(argc, argv,
-				 "0b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
+				 "0b:c:de:fg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'b':
@@ -2805,6 +2870,11 @@ main(int argc, char **argv)
 		case 'd':
 			debug = 1;
 			break;
+		case 'e':
+			pollute_eof = getnum(optarg, &endp);
+			if (pollute_eof < 0 || pollute_eof > 1)
+				usage();
+			break;
 		case 'f':
 			flush = 1;
 			break;
-- 
2.45.0

