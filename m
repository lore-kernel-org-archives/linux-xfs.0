Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C2FC05027
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 17:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjBARYV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 12:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjBARYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 12:24:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8E021294
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 09:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675272219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gl8JtfbCPD2oMnWYpQohdsm3TqMEk2HyWlZ4bh0XKeM=;
        b=Un4LTzxT6Qfr4b/KdF2tTuJelFhuDil6lkCfbNHbHsM8uDOrxE0d/jdAJBlE9I7xE7rsTT
        2kl+A92Pa4jeagTYC0TAdSkmRSxapVNbYt0X1lcfFCT+SuwlO74/s5BSNOEtIybiHSLMi5
        MuZvNtceW8a8QoJWbrtSGbT86ka0Io4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-W9U6W2MfP9yO98cBk3jPew-1; Wed, 01 Feb 2023 12:23:37 -0500
X-MC-Unique: W9U6W2MfP9yO98cBk3jPew-1
Received: by mail-ed1-f71.google.com with SMTP id f11-20020a056402354b00b0049e18f0076dso13216893edd.15
        for <linux-xfs@vger.kernel.org>; Wed, 01 Feb 2023 09:23:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gl8JtfbCPD2oMnWYpQohdsm3TqMEk2HyWlZ4bh0XKeM=;
        b=8BRzab9i3xK0TfnTuB3Lq6xXJDWPiXMEpQs22G+jemkoIIbu+szgccdsIil/ehxSK4
         ERxnW27fTMcVTZhHTA73qw7d0v9qJJIPd6Bpyo2qZSYf82Lo8PJLWGzXPjUv1u18bwwM
         uwZEqnHXSaPL4YRwupQBm8ixF0MPr0fXgqCtBYbk57pLZS+AyPrN70fkWl7U7NXNG/p8
         uNwUVyN5BPxzTeRK28tvAToo4e9d2ZWBakJeFuQl8lavwWZ708Oh0dWriUmbu1J7n5yb
         rIRqH3MhTXIr9oAfdS1oC1kyWnJvtBUE6UiB2bX51ny3qdew2s4EUy+9dCpKXvUHevBS
         4ILw==
X-Gm-Message-State: AO0yUKXLhj6jNDe9kwFRDwdDRKJ9vfneRsFpwfMo8MXKrVioGDtO1n5D
        9RiY2tkisr1NnqED2Fzts7GKnn/igg+c1ZkXIE9hW812hx6BJeGq93LdlWs8QSx88jHWrZye0tU
        Hx8413A/HuJ6L3rL/YOyh/2o0u0ES0dWco2RGVzHHYaC0UHI7C9F4OquMdYRgPSY3qpfbtZE=
X-Received: by 2002:a17:907:8a04:b0:872:27cb:9430 with SMTP id sc4-20020a1709078a0400b0087227cb9430mr3606515ejc.74.1675272216199;
        Wed, 01 Feb 2023 09:23:36 -0800 (PST)
X-Google-Smtp-Source: AK7set92X57ejg5ZnAeSbNWw4AQKfsPu8ktqCbcjeWWVYSKXL+hsiG8X86Udi4u0wxFKzVuOfl1ENA==
X-Received: by 2002:a17:907:8a04:b0:872:27cb:9430 with SMTP id sc4-20020a1709078a0400b0087227cb9430mr3606494ejc.74.1675272215940;
        Wed, 01 Feb 2023 09:23:35 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id f19-20020a170906391300b0088452ca0666sm6805554eje.196.2023.02.01.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 09:23:35 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cem@kernel.org, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs_db: make flist_find_ftyp() to check for field existance on disk
Date:   Wed,  1 Feb 2023 18:21:47 +0100
Message-Id: <20230201172146.1874205-1-aalbersh@redhat.com>
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

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 db/crc.c   |  2 +-
 db/flist.c | 13 ++++++++++---
 db/flist.h |  3 ++-
 3 files changed, 13 insertions(+), 5 deletions(-)

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
index 0bb6474c..d275abfe 100644
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
@@ -420,11 +423,15 @@ flist_find_ftyp(
 		fl->fld = f;
 		if (f->ftyp == type)
 			return fl;
+		count = fcount(f, obj, startoff);
+		if (!count) {
+			continue;
+		}
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

