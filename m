Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DB81802DD
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479613; cv=none; b=LnINNOqq9esgCUFu2WJLW+MYnyFGumn2Vv+T+vflLEE5eit8336BHe5mdniLS3cgIUEpMUt17ifUQG72/ME35i5JCrwvpP7xwm3Wi5qH/hXc+5GXCz0REwVTQF3+bAcmrH3TbGImG07Tx3pi78HQqclc7l1SfG9kqXbJVZXR0iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479613; c=relaxed/simple;
	bh=N8RVdmpPnZBuMa5Pfn5hVuX/MEjByoo7Thk+QXfgBF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssqpOUZQCQf5afslCW/GOlLpahBXUZ0pKUVgwXXkBKYJo/WMPOBOzALcZFff3Clo8uldYAI+GG7gkNd9pEDWutiiMYB4kQu06n8TmccYqxxNK+MW5u7vG2ASANgmke8ImwyaJNOjF8MWi0q0rlmUor0ks//47zeIgTH6hIQH4Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ej7MYXg3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ej7MYXg3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SKqvGMHV0G2e1Wn/lNtT2JOVfUfOsFAA3Jr+OPEhvqI=;
	b=ej7MYXg3IKBh9TbEmbRHHqGJwpNlAtsuzwjfbScu1eGI6KeN6ggXA/RaqssSJH0U6QavaI
	CqiZwc+n54AUsAZc0wY6u170JSXL35exhY+di4H6i3p2de9qLHqtYZ3+e5Z0+WTqfF9JI4
	r3RLlQbsXLR+7GtNl5th3isbv6ojvw8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-Impo84X2PQK8MOP5Egz__Q-1; Sun, 29 Dec 2024 08:40:09 -0500
X-MC-Unique: Impo84X2PQK8MOP5Egz__Q-1
X-Mimecast-MFC-AGG-ID: Impo84X2PQK8MOP5Egz__Q
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa689b88293so168772566b.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479608; x=1736084408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKqvGMHV0G2e1Wn/lNtT2JOVfUfOsFAA3Jr+OPEhvqI=;
        b=pPm8v8eBBGhoEWQS0mvit4n7qoNm5h2lmlgQqQl9FYT3mWSQenepWWDKvi8ac/NmUD
         HGAL3xmPqWJsYK1Rn0P338SpfVNb3M7b4ROUd6dci5VPTNHQ2csGkrpnPAZM8RuLwbdq
         69szMnHtJIsVdHaiR7fKuPSMJSQ98TXA0lxXQt4KZI9BDfO2sOiN/0u6ue6vDXtpb1CG
         Mfq2AsdSgfYF0mPFa5AnAneIjJmVYQig1DIdMfRAEUO1owem/T07k7UPtIFtTaCl0RaY
         cgcctqwbVljxWAbCJSWFzwfJvF89scfbJjMnX+qkrSaA0ExPRjAhRUWQZrb+NrL7ydBR
         NeSg==
X-Gm-Message-State: AOJu0YyyWS61Mc81Y7F/qyFlYDd5VutjRo973cQ4Iyyhaye8gZyQ1J3q
	RbS4OG7I50Wl5VfqCoTDAPVnpF8GIhWm836oyKvlMWeZW0lJvjlmn6OgksGLZv1tF9wv9l4DuVT
	uc0jO80BZA1NY5RFmCZoKPyuX4jrabCdp2ZiIKia0jijzreuTq+OfkvLNecQLuLaCP6uaFAw+xy
	V95YRXKBiLEDxN4A/8OoOlfSrngTub+UaHf55WiBjT
X-Gm-Gg: ASbGncs89y0cU00XSv/U0WI+0noxENnjTEvKQa84ebiGoncwYHFisKbyZRF7+F7lfAN
	RgXNbqYZxEfJ9QMhtaiCKJ8Dfwp+D0pEaLdcB4oAAmlT7nZ8Ob06gv545gNYE0kKEjpno7Pslkc
	iovKOTDviadygghVJFgZsppZaI+ZhQtoLPMpUoMnTmORGOt2HUZUP3WQ9kYyG8v/Mb0LJuvPvv7
	pnP/tY9RO7ets0TD4sKiqBR8O4tm8h3YWv24JsWjrPn4Cp3x7vNGqwlNdbmN9Ur0oZNCUA+/oOj
	lAHsTP7T2FUHyDM=
X-Received: by 2002:a17:907:3d86:b0:aa6:8e72:e50b with SMTP id a640c23a62f3a-aac3366a0c0mr3359335766b.56.1735479608294;
        Sun, 29 Dec 2024 05:40:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTJbzfsEvk0lee+SMjszHI1ukq8N6+6R9Qot4wYaWPbb9EauV1k02a6dWvvKDNoBozLjaLJQ==
X-Received: by 2002:a17:907:3d86:b0:aa6:8e72:e50b with SMTP id a640c23a62f3a-aac3366a0c0mr3359333566b.56.1735479607915;
        Sun, 29 Dec 2024 05:40:07 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:07 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 18/24] xfs: add writeback page mapping for fs-verity
Date: Sun, 29 Dec 2024 14:39:21 +0100
Message-ID: <20241229133927.1194609-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Data from severity region is not mapped as file data but as a set of
extended attributes.

Add mapping function which removes region offset and map n-th page
to attribute with name n.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_aops.c | 85 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index bcc51628dbdd..976d77277e95 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -20,6 +20,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_fsverity.h"
+#include "xfs_attr.h"
 #include <linux/fsverity.h>
 
 struct xfs_writepage_ctx {
@@ -132,7 +133,8 @@ xfs_end_ioend(
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
 
-	if (!error && xfs_ioend_is_append(ioend))
+	if (!error && !xfs_fsverity_in_region(ioend->io_offset) &&
+			xfs_ioend_is_append(ioend))
 		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 
 	/* This IO was to the Merkle tree region */
@@ -472,14 +474,87 @@ static const struct iomap_writeback_ops xfs_writeback_ops = {
 	.discard_folio		= xfs_discard_folio,
 };
 
+static int
+xfs_fsverity_map_blocks(
+	struct iomap_writepage_ctx *wpc,
+	struct inode		*inode,
+	loff_t			offset,
+	unsigned int		len)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+	int			nmap = 1;
+	loff_t			pos;
+	int			seq;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_da_args	args;
+	struct xfs_merkle_key	name;
+	loff_t			xattr_name;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	pos = (offset & XFS_FSVERITY_MTREE_MASK);
+	/* We always write one attribute block, but each block can have multiple
+	 * Merkle tree blocks */
+	ASSERT(!is_power_of_2(len));
+	xattr_name = pos & ~(len - 1);
+
+	xfs_fsverity_init_merkle_args(ip, &name, xattr_name, &args);
+
+	error = xfs_attr_get(&args);
+	if (error)
+		return error;
+
+	ASSERT(args->dp->i_af.if_format != XFS_DINODE_FMT_LOCAL);
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = xfs_bmapi_read(ip, (xfs_fileoff_t)args.rmtblkno,
+			       args.rmtblkcnt, &imap, &nmap,
+			       XFS_BMAPI_ATTRFORK);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (error)
+		return error;
+
+	/* Instead of xattr extent offset, which will be over data, we need
+	 * merkle tree offset in page cache */
+	imap.br_startoff =
+		XFS_B_TO_FSBT(mp, xattr_name | XFS_FSVERITY_MTREE_OFFSET);
+
+	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_XATTR);
+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, IOMAP_F_XATTR, seq);
+
+	trace_xfs_map_blocks_found(ip, offset, len, XFS_ATTR_FORK, &imap);
+
+	/* We want this to be separate from other IO as we will do
+	 * CRC update on IO completion */
+	wpc->iomap.flags |= IOMAP_F_NO_MERGE;
+
+	return 0;
+}
+
+static const struct iomap_writeback_ops xfs_writeback_verity_ops = {
+	.map_blocks		= xfs_fsverity_map_blocks,
+	.prepare_ioend		= xfs_prepare_ioend,
+	.discard_folio		= xfs_discard_folio,
+};
+
 STATIC int
 xfs_vm_writepages(
-	struct address_space	*mapping,
-	struct writeback_control *wbc)
+	struct address_space		*mapping,
+	struct writeback_control	*wbc)
 {
-	struct xfs_writepage_ctx wpc = { };
+	struct xfs_writepage_ctx	wpc = { };
+	struct xfs_inode		*ip = XFS_I(mapping->host);
 
-	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION)) {
+		wbc->range_start = XFS_FSVERITY_MTREE_OFFSET;
+		wbc->range_end = LLONG_MAX;
+		return iomap_writepages_unbound(mapping, wbc, &wpc.ctx,
+						&xfs_writeback_verity_ops);
+	}
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
-- 
2.47.0

