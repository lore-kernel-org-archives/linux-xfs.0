Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D98C636CC
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 11:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjBHLEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 06:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjBHLEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 06:04:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBEE4491
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 03:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675854236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LdPKlJ/Kd7Fe6YgCPdgdCUc947RC0NbzYbTuZ5UoVw0=;
        b=Rjji39HTbMRY70vL7/gCUv1iV8Q0PXaei1kZdBL/fc6V2O2MUWpLiYS7jiYFh140RJudgk
        s7eF0HG00wvuvTdZGCPD8/d048nGmvkalX7Ewm0TW93RqbUvjdonCwQP5xcJOdUb3FSYsz
        ASSJbXN2gdcOHAwIl1Gp30C0srQ0/6o=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-112-jb6gr4ZWNqKfQUR5F-oOQA-1; Wed, 08 Feb 2023 06:03:55 -0500
X-MC-Unique: jb6gr4ZWNqKfQUR5F-oOQA-1
Received: by mail-ej1-f70.google.com with SMTP id p16-20020a170906499000b0088c5a527c89so13103892eju.23
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 03:03:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LdPKlJ/Kd7Fe6YgCPdgdCUc947RC0NbzYbTuZ5UoVw0=;
        b=JU4QFDXrsBCmxOwqkdr5jJVU2PrG1p7n5S6rVjNDT5MEYQ7nssFQu0msAx+204SOOL
         oC9HgttrLkN2cFdFaCrwD8QRnMCGF9qCKmjFOCKa6KroFniIbVLkMRQwbKmZlZKhUo4d
         Y++gVMX82MvUGkMrfIQDinhJGubN1FLUMfh0eRYh3Ibx/toJ8fxG7BNzbWAECfwTERcp
         pTCkDrss+o4E360Iv86U/KuWDp1LGmDfWazVOWaz41jp2Jw6erwEgpaooY2YE2GebaiU
         kYqPRpKL+9ngYp7Ry9LgFN971L869ZMw0gTHJ0xo/nvmhJaDHo+v7C2wrg0FDtRPL5oA
         OYmA==
X-Gm-Message-State: AO0yUKUP/94HdPfAON89vewlZwcyvdUnkRFvD8wvRnrZzmEIJ+YEu+KV
        Uv2yc1YFFvPAKsoynyNOwnagT9BktAoaKgaF5GCFPbrwvxZGEbxVYZuU1a7xOxAdqqzepyC6iu3
        VZiybgJa4ZWaNzXIlJl+Bx5Mr8F91LJLhzNyM62zL+yUHESvYTiIWhMkH2BY2rfGt670abh9W86
        Gi
X-Received: by 2002:a17:906:6448:b0:877:6713:7e99 with SMTP id l8-20020a170906644800b0087767137e99mr6637278ejn.58.1675854234302;
        Wed, 08 Feb 2023 03:03:54 -0800 (PST)
X-Google-Smtp-Source: AK7set9WYIwS2myBIMJg6p2nPPht8MO0JgWecogeYqBP9joVGCj+PvjvCKDO1MRrFOzD0FrX+L7S3w==
X-Received: by 2002:a17:906:6448:b0:877:6713:7e99 with SMTP id l8-20020a170906644800b0087767137e99mr6637258ejn.58.1675854234055;
        Wed, 08 Feb 2023 03:03:54 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id y22-20020a1709064b1600b008786675d086sm8122135eju.29.2023.02.08.03.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 03:03:53 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cem@kernel.org, Andrey Albershteyn <aalbersh@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfs_db: make flist_find_ftyp() to check for field existance on disk
Date:   Wed,  8 Feb 2023 12:02:22 +0100
Message-Id: <20230208110220.2664995-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

flist_find_ftyp() searches for the field of the requested type. The
first found field/path is returned. However, this doesn't work when
there are multiple fields of the same type. For example, attr3 type
have a few CRC fields. Leaf block (xfs_attr_leaf_hdr ->
xfs_da3_blkinfo) and remote value block (xfs_attr3_rmt_hdr) both
have CRC but goes under attr3 type. This causes 'crc' command to be
unable to find CRC field when we are at remote attribute block as it
tries to use leaf block CRC path:

	$ dd if=/dev/zero bs=4k count=10 | tr '\000' '1' > test.img
	$ touch test.file
	$ setfattr -n user.bigattr -v "$(cat test.img)" test.file

	$ # CRC of the leaf block
	$ xfs_db -r -x /dev/sda5 -c 'inode 132' -c 'ablock 0' -c 'crc'
	Verifying CRC:
	hdr.info.crc = 0x102b5cbf (correct)

	$ # CRC of the remote value block
	$ xfs_db -r -x /dev/sda5 -c 'inode 132' -c 'ablock 1' -c 'crc'
	field info not found
	parsing error

Solve this by making flist_find_ftyp() to also check that field in
question have non-zero count (exist at the current block).

Changes from v1:
- Removed unnecessary curly braces

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 db/crc.c   |  2 +-
 db/flist.c | 12 +++++++++---
 db/flist.h |  3 ++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/db/crc.c b/db/crc.c
index 7428b916..1c73f980 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -114,7 +114,7 @@ crc_f(
 	}
 
 	/* Search for a CRC field */
-	fl = flist_find_ftyp(fields, FLDT_CRC);
+	fl = flist_find_ftyp(fields, FLDT_CRC, iocur_top->data, 0);
 	if (!fl) {
 		dbprintf(_("No CRC field found for type %s\n"), cur_typ->name);
 		return 0;
diff --git a/db/flist.c b/db/flist.c
index 0bb6474c..c81d229a 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -408,11 +408,14 @@ flist_split(
  */
 flist_t *
 flist_find_ftyp(
-	const field_t *fields,
-	fldt_t	type)
+	const field_t	*fields,
+	fldt_t		type,
+	void		*obj,
+	int		startoff)
 {
 	flist_t	*fl;
 	const field_t	*f;
+	int		count;
 	const ftattr_t  *fa;
 
 	for (f = fields; f->name; f++) {
@@ -420,11 +423,14 @@ flist_find_ftyp(
 		fl->fld = f;
 		if (f->ftyp == type)
 			return fl;
+		count = fcount(f, obj, startoff);
+		if (!count)
+			continue;
 		fa = &ftattrtab[f->ftyp];
 		if (fa->subfld) {
 			flist_t *nfl;
 
-			nfl = flist_find_ftyp(fa->subfld, type);
+			nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
 			if (nfl) {
 				fl->child = nfl;
 				return fl;
diff --git a/db/flist.h b/db/flist.h
index f0772378..e327a360 100644
--- a/db/flist.h
+++ b/db/flist.h
@@ -38,4 +38,5 @@ extern int	flist_parse(const struct field *fields, flist_t *fl, void *obj,
 			    int startoff);
 extern void	flist_print(flist_t *fl);
 extern flist_t	*flist_scan(char *name);
-extern flist_t	*flist_find_ftyp(const field_t *fields, fldt_t  type);
+extern flist_t	*flist_find_ftyp(const field_t *fields, fldt_t  type, void *obj,
+		int startoff);
-- 
2.31.1

