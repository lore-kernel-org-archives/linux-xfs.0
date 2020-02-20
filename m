Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4152FC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 02:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12DDF2465D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 02:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUaB86ue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgBTCQ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 21:16:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727576AbgBTCQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 21:16:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582164987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/Wx1kre2anoJleINDVKTvTHOkkPOyvlMGQa1E/boV0I=;
        b=CUaB86uewyDkXMqyGjs+e8KIG6so01tRlvhR8fofYMC9QR4zBIfetJgwcX1wd+OB1FRFz5
        UqAmKv9qYBj2/xDToObf6G/d8arE+26odr1fmXdtnqy19m05c4bJlHBjVjQuhAQSvL21Be
        NeLxIHuBJlmF9WxIj0GfgMzmcTlkVK8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-2IwNvp4xPvu2RE-3Pp9hBA-1; Wed, 19 Feb 2020 21:16:25 -0500
X-MC-Unique: 2IwNvp4xPvu2RE-3Pp9hBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63B59100550E;
        Thu, 20 Feb 2020 02:16:24 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C544863A5;
        Thu, 20 Feb 2020 02:16:23 +0000 (UTC)
To:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     "Luis R. Rodriguez" <mcgrof@kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs/030: fix test for external log device
Message-ID: <d3b3a65e-3575-f153-98ca-4a34e170ab78@redhat.com>
Date:   Wed, 19 Feb 2020 20:16:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Several tests fail if an external log device is used; in this case
the xfs_db invocation fails with a clear indication of why, so fix
that as other tests do by testing for and using the external log
option if present.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/repair b/common/repair
index 5a9097f4..cf69dde9 100644
--- a/common/repair
+++ b/common/repair
@@ -9,8 +9,12 @@ _zero_position()
 	value=$1
 	struct="$2"
 
+	SCRATCH_OPTIONS=""
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+
 	# set values for off/len variables provided by db
-	eval `xfs_db -r -c "$struct" -c stack $SCRATCH_DEV | perl -ne '
+	eval `xfs_db -r -c "$struct" -c stack $SCRATCH_OPTIONS $SCRATCH_DEV | perl -ne '
 		if (/byte offset (\d+), length (\d+)/) {
 			print "offset=$1\nlength=$2\n"; exit
 		}'`
diff --git a/tests/xfs/030 b/tests/xfs/030
index efdb6a18..e1cc32ef 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -77,7 +77,10 @@ else
 	_scratch_unmount
 fi
 clear=""
-eval `xfs_db -r -c "sb 1" -c stack $SCRATCH_DEV | perl -ne '
+SCRATCH_OPTIONS=""
+[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+eval `xfs_db -r -c "sb 1" -c stack $SCRATCH_OPTIONS $SCRATCH_DEV | perl -ne '
 	if (/byte offset (\d+), length (\d+)/) {
 		print "clear=", $1 / 512, "\n"; exit
 	}'`


