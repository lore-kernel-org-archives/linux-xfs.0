Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E96BC33C9E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 23:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51DDC21835
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 23:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/1ZFc6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgAQXRR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 18:17:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52078 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729354AbgAQXRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 18:17:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579303036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=o/hX7r4uphLExHqKzCfInfCt8YS9WeLH9TTy3KHKtGM=;
        b=F/1ZFc6lDR2SrA5k0x4ch7F/aVGWlwmXqp+2OXwNMSXHPgd5+1STCwaoBW7oYrEPWVD5tX
        x5rjOFH+nHSaYJHO8/9XugNFpkHtE9k+VIVq0NzoDSeUKozr4Cte1QgDLZmIuLBzoqQqwi
        8YpgH3Oxgx0NdusCGIKJGpMM88FdlgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-FZp0ulVLNJ2X0E0wSuQGbw-1; Fri, 17 Jan 2020 18:17:13 -0500
X-MC-Unique: FZp0ulVLNJ2X0E0wSuQGbw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DCB418C35A1;
        Fri, 17 Jan 2020 23:17:12 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D88461A7E3;
        Fri, 17 Jan 2020 23:17:11 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: stop using ->data_entry_p()
Message-ID: <2cf1f45b-b3b2-f630-50d5-ff34c000b0c8@redhat.com>
Date:   Fri, 17 Jan 2020 17:17:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The ->data_entry_p() op went away in v5.5 kernelspace, so rework
xfs_repair to use ->data_entry_offset instead, in preparation
for the v5.5 libxfs backport.

This could later be cleaned up to use offsets as was done
in kernel commit 8073af5153c for example.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I'll munge this patch in mid-libxfs-sync, just before the
->data_entry_p removal patch.

diff --git a/repair/dir2.c b/repair/dir2.c
index 4ac0084e..2494f3c4 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -580,7 +580,7 @@ process_dir2_data(
 
 	d = bp->b_addr;
 	bf = M_DIROPS(mp)->data_bestfree_p(d);
-	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
+	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
 	badbest = lastfree = freeseen = 0;
 	if (be16_to_cpu(bf[0].length) == 0) {
 		badbest |= be16_to_cpu(bf[0].offset) != 0;
@@ -646,7 +646,7 @@ process_dir2_data(
 			do_warn(_("\twould junk block\n"));
 		return 1;
 	}
-	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
+	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
 	/*
 	 * Process the entries now.
 	 */
diff --git a/repair/phase6.c b/repair/phase6.c
index 91d208a6..d61b2ae7 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1530,7 +1530,7 @@ longform_dir2_entry_check_data(
 
 	bp = *bpp;
 	d = bp->b_addr;
-	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
+	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
 	nbad = 0;
 	needscan = needlog = 0;
 	junkit = 0;
@@ -1590,7 +1590,7 @@ longform_dir2_entry_check_data(
 				break;
 
 			/* check for block with no data entries */
-			if ((ptr == (char *)M_DIROPS(mp)->data_entry_p(d)) &&
+			if ((ptr == (char *)d + M_DIROPS(mp)->data_entry_offset) &&
 			    (ptr + be16_to_cpu(dup->length) >= endptr)) {
 				junkit = 1;
 				*num_illegal += 1;
@@ -1659,7 +1659,7 @@ longform_dir2_entry_check_data(
 			do_warn(_("would fix magic # to %#x\n"), wantmagic);
 	}
 	lastfree = 0;
-	ptr = (char *)M_DIROPS(mp)->data_entry_p(d);
+	ptr = (char *)d + M_DIROPS(mp)->data_entry_offset;
 	/*
 	 * look at each entry.  reference inode pointed to by each
 	 * entry in the incore inode tree.
@@ -1834,7 +1834,7 @@ longform_dir2_entry_check_data(
 			       (dep->name[0] == '.' && dep->namelen == 1));
 			add_inode_ref(current_irec, current_ino_offset);
 			if (da_bno != 0 ||
-			    dep != M_DIROPS(mp)->data_entry_p(d)) {
+			    dep != (void *)d + M_DIROPS(mp)->data_entry_offset) {
 				/* "." should be the first entry */
 				nbad++;
 				if (entry_junked(

