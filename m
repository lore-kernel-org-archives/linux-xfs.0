Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35B8370D4F
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 10:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784026409; cv=none; b=Z9t/QoU22XRM5zSyx7zpq0/8AXSMjmXTLwO57ws6Fir77KaOscDTzDCD8qOvSXgCgiP1zLhIDuWcovsrLBdeAg+ZdE8xqHm9bq0rdb+0Ip6BBS2kyYipqqN6f4lKpQL8PVN9LhmMjA0qjWDyBw80kkeZQh8SDMmwT/WWrR8GG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784026409; c=relaxed/simple;
	bh=K0pspBB5tELj174biR6SFNCGMMaaodFHyK14ob7cAfY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TKKVLUqd4cqurDRqxHWkiSneabRtjOgHnYDJwPfACc6CKEsTCGGZjAVlaoB0FqduAssB10TmzAm9WOltWIt2rkgSqLNI8M6Scm8WKElHhl+qZIX74t2fntGUTNsb9JVdyyBbrRlI5OzjFelbsiF9Jo08xFLnLENlxpvlGsaqnAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4gzx426NlFzKnf5;
	Tue, 14 Jul 2026 12:53:22 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: aalbersh@kernel.org
Cc: pankaj.raghav@linux.dev,
	djwong@kernel.org,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	gost.dev@samsung.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] fiemap: add a nosync option
Date: Tue, 14 Jul 2026 12:53:14 +0200
Message-ID: <20260714105314.413402-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4gzx426NlFzKnf5

io/fiemap adds FIEMAP_FLAG_SYNC by default. There are some test cases
where adding this flag might have an undesired side effect on the
results [1].

Add an option that does not pass FIEMAP_FLAG_SYNC flag.

[1] https://lore.kernel.org/linux-xfs/ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com/

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 io/fiemap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index b41f71bf..7aa8868d 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -36,6 +36,7 @@ fiemap_help(void)
 " -a -- prints the attribute fork map instead of the data fork.\n"
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " -n -- query n extents.\n"
+" -s -- do not use FIEMAP_FLAG_SYNC.\n"
 " -v -- Verbose information\n"
 " offset is the starting offset to map, and is optional.  If offset is\n"
 " specified, mapping length may (optionally) be specified as well."
@@ -242,7 +243,7 @@ fiemap_f(
 
 	init_cvtnum(&fsblocksize, &fssectsize);
 
-	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
+	while ((c = getopt(argc, argv, "aln:sv")) != EOF) {
 		switch (c) {
 		case 'a':
 			fiemap_flags |= FIEMAP_FLAG_XATTR;
@@ -253,6 +254,10 @@ fiemap_f(
 		case 'n':
 			max_extents = atoi(optarg);
 			break;
+		case 's':
+			/* nosync */
+			fiemap_flags &= ~(FIEMAP_FLAG_SYNC);
+			break;
 		case 'v':
 			vflag++;
 			break;
@@ -393,7 +398,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
+	fiemap_cmd.args = _("[-alsv] [-n nx] [offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 

base-commit: e80b048d87fdc5735e0d03ae29b497b402ea8bbe
-- 
2.51.2

