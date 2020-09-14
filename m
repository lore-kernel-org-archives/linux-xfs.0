Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E3DC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 18:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDED321D7B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 18:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MD8LqTCa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgINS0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 14:26:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725964AbgINS0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 14:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600107965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=J9dxWNSDhdG7mTbNPGu4m73YuFOU0xQgJDdVX1X/CEM=;
        b=MD8LqTCah4F2xX5vajAXnuGa+Xr3HF+z5uItBaujKzaEQIVoTZhVJVgkC47lYXqW6ZdPdw
        krm6GzynA6SIfEpGq/ECQOK73uVPhIYn6/qiHRqzHYnEaKXcKKaBb1QJgFzII+K6WMd8Qs
        7V6xPiKeB46ql245tSKpEZQy0xrCP3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-HiUl4a9aNACGIGQY91cskg-1; Mon, 14 Sep 2020 14:26:03 -0400
X-MC-Unique: HiUl4a9aNACGIGQY91cskg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 945E418C5203
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 18:26:02 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BB837B7BF;
        Mon, 14 Sep 2020 18:26:01 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs.xfs: fix ASSERT on too-small device with stripe geometry
Cc:     Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
Date:   Mon, 14 Sep 2020 13:26:01 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When a too-small device is created with stripe geometry, we hit an
assert in align_ag_geometry():

# truncate --size=10444800 testfile
# mkfs.xfs -dsu=65536,sw=1 testfile 
mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.

This is because align_ag_geometry() finds that the size of the last
(only) AG is too small, and attempts to trim it off.  Obviously 0
AGs is invalid, and we hit the ASSERT.

Fix this by skipping the last-ag-trim if there is only one AG, and
add a new test to validate_ag_geometry() which offers a very specific,
clear warning if the device (in dblocks) is smaller than the minimum
allowed AG size.

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a687f385..da8c5986 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1038,6 +1038,15 @@ validate_ag_geometry(
 	uint64_t	agsize,
 	uint64_t	agcount)
 {
+	/* Is this device simply too small? */
+	if (dblocks < XFS_AG_MIN_BLOCKS(blocklog)) {
+		fprintf(stderr,
+	_("device (%lld blocks) too small, need at least %lld blocks\n"),
+			(long long)dblocks,
+			(long long)XFS_AG_MIN_BLOCKS(blocklog));
+		usage();
+	}
+
 	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
 		fprintf(stderr,
 	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
@@ -2827,11 +2836,12 @@ validate:
 	 * and drop the blocks.
 	 */
 	if (cfg->dblocks % cfg->agsize != 0 &&
+	     cfg->agcount > 1 &&
 	     (cfg->dblocks % cfg->agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog))) {
+printf("%d %d %d\n", cfg->dblocks, cfg->agsize, cfg->dblocks % cfg->agsize);
 		ASSERT(!cli_opt_set(&dopts, D_AGCOUNT));
 		cfg->dblocks = (xfs_rfsblock_t)((cfg->agcount - 1) * cfg->agsize);
 		cfg->agcount--;
-		ASSERT(cfg->agcount != 0);
 	}
 
 	validate_ag_geometry(cfg->blocklog, cfg->dblocks,

