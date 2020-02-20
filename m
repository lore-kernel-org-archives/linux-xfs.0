Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4EBC11D24
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 20:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD43207FD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 20:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PGreV+6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgBTUGl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 15:06:41 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53663 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728988AbgBTUGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 15:06:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582229200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wR5HRYcM5uIHBhBeX4VTBixBrxH10MbVv1tab5F2B7Y=;
        b=PGreV+6covNF7MleRyvsPphLMbe1WzL/2kY9LFOGPiX2QdMMk/yP0cuuTYpJIvY47sj/Rw
        6dsVM9wdv0aGeudd9PU8mwj3AcROAEbIqHPADmy0lZ6TzSRPnMjSoa7TT+yMxv0cd3czn2
        XJ1RX8ZA8yMQi3DJn5u/xpoq/+PRR8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-j3A7chXyOqmVGJRm5sYKaw-1; Thu, 20 Feb 2020 15:06:36 -0500
X-MC-Unique: j3A7chXyOqmVGJRm5sYKaw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A2A713E6;
        Thu, 20 Feb 2020 20:06:35 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 716835C1B0;
        Thu, 20 Feb 2020 20:06:35 +0000 (UTC)
Received: by segfault.boston.devel.redhat.com (Postfix, from userid 3734)
        id 9DB572067400; Thu, 20 Feb 2020 15:06:34 -0500 (EST)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH V2 3/3] xfs/300: modify test to work on any fs block size
Date:   Thu, 20 Feb 2020 15:06:32 -0500
Message-Id: <20200220200632.14075-4-jmoyer@redhat.com>
In-Reply-To: <20200220200632.14075-1-jmoyer@redhat.com>
References: <20200220200632.14075-1-jmoyer@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

