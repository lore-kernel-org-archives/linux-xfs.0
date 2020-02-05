Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6BEC35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 22:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7675217F4
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 22:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MNjlhtt/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBEWs0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 17:48:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727604AbgBEWsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 17:48:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580942904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wR5HRYcM5uIHBhBeX4VTBixBrxH10MbVv1tab5F2B7Y=;
        b=MNjlhtt/alMa2Mu3QkQR02vVR2uYPqIBcRpKslVHNEkCPQHlPFEhQLBDg8wH+WqNh5qvqA
        LRAte+Y6rZhz/rwpfC2I671snqvOW8wK7VQdtPh1rr/QOoNbhFk++bHIHtx+IVxgdrJC0F
        1fNdNseeh3ejkSSR3alqMoM4gbnHl74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-wdQJQxF3NOyPxJUEGsh1cQ-1; Wed, 05 Feb 2020 17:48:22 -0500
X-MC-Unique: wdQJQxF3NOyPxJUEGsh1cQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64592190D341;
        Wed,  5 Feb 2020 22:48:21 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 498075DA7C;
        Wed,  5 Feb 2020 22:48:21 +0000 (UTC)
Received: by segfault.boston.devel.redhat.com (Postfix, from userid 3734)
        id 4F927208D0E6; Wed,  5 Feb 2020 17:48:20 -0500 (EST)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/3] xfs/300: modify test to work on any fs block size
Date:   Wed,  5 Feb 2020 17:48:18 -0500
Message-Id: <20200205224818.18707-4-jmoyer@redhat.com>
In-Reply-To: <20200205224818.18707-1-jmoyer@redhat.com>
References: <20200205224818.18707-1-jmoyer@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The test currently assumes a file system block size of 4k.  It will
work just fine on any user-specified block size, though.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 tests/xfs/300 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/300 b/tests/xfs/300
index 28608b81..4f1c927a 100755
--- a/tests/xfs/300
+++ b/tests/xfs/300
@@ -50,8 +50,9 @@ $XFS_IO_PROG -f -c "pwrite -S 0x63 0 4096" $SCRATCH_MNT=
/attrvals >> $seqres.full
 cat $SCRATCH_MNT/attrvals | attr -s name $SCRATCH_MNT/$seq.test >> $seqr=
es.full 2>&1
=20
 # Fragment the file by writing backwards
+bs=3D$(_get_file_block_size $SCRATCH_MNT)
 for I in `seq 6 -1 0`; do
-	dd if=3D/dev/zero of=3D$SCRATCH_MNT/$seq.test seek=3D$I bs=3D4k \
+	dd if=3D/dev/zero of=3D$SCRATCH_MNT/$seq.test seek=3D$I bs=3D${bs} \
 	   oflag=3Ddirect count=3D1 conv=3Dnotrunc >> $seqres.full 2>&1
 done
=20
--=20
2.19.1

