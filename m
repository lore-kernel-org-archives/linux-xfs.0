Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13623C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 07:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E46DA206DC
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 07:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bt/3U1Kw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfKNHpp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 02:45:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45724 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725852AbfKNHpp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 02:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573717543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rzSMKodyGhPRjFFhoPJZENJjXFnwDOkBc7ZUSyhkT+g=;
        b=bt/3U1KwkwSfaBO7dM8fvMfvQ8A7Dp1YxRCc1VUFfWKIRFHCcideXhv5hoiHxgE9EglYU7
        xaSYZzBmonfLxK/r9c4QlSwkIY2tDSiNLkVOvLk8pUMORp4SLpEEd9szDih3/wWk7e/P7x
        OYNSnVwwYc/Qs0fxAmyWgc6zGcB0iO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-TI_W6yTWOT-pKJgJy6lg9A-1; Thu, 14 Nov 2019 02:45:42 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D94D3805A65;
        Thu, 14 Nov 2019 07:45:41 +0000 (UTC)
Received: from hut.sorensonfamily.com.com (ovpn-116-27.phx2.redhat.com [10.3.116.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2C6B6953F;
        Thu, 14 Nov 2019 07:45:38 +0000 (UTC)
From:   Frank Sorenson <sorenson@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, sorenson@redhat.com
Subject: [PATCH] xfs_restore: Return error if error occurs restoring extent
Date:   Thu, 14 Nov 2019 01:45:38 -0600
Message-Id: <20191114074538.1220512-1-sorenson@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: TI_W6yTWOT-pKJgJy6lg9A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If an error occurs during write while restoring an extent,
no error is currently propagated back to the caller, so
xfsrestore can return SUCCESS on a failed restore.

Make restore_extent return an error code indicating the
restore was incomplete.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 restore/content.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 6b22965..c267234 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8446,6 +8446,7 @@ restore_extent(filehdr_t *fhdrp,
 =09off64_t new_off;
 =09struct dioattr da;
 =09bool_t isrealtime =3D BOOL_FALSE;
+=09rv_t rv =3D RV_OK;
=20
 =09*bytesreadp =3D 0;
=20
@@ -8496,7 +8497,6 @@ restore_extent(filehdr_t *fhdrp,
 =09=09req_bufsz =3D (size_t)min((off64_t)INTGENMAX, sz);
 =09=09bufp =3D (*dop->do_read)(drivep, req_bufsz, &sup_bufsz, &rval);
 =09=09if (rval) {
-=09=09=09rv_t rv;
 =09=09=09char *reasonstr;
 =09=09=09switch(rval) {
 =09=09=09case DRIVE_ERROR_EOF:
@@ -8665,12 +8665,13 @@ restore_extent(filehdr_t *fhdrp,
 =09=09=09fd =3D -1;
 =09=09=09assert(ntowrite <=3D (size_t)INTGENMAX);
 =09=09=09nwritten =3D (int)ntowrite;
+=09=09=09rv =3D RV_INCOMPLETE;
 =09=09}
 =09=09sz -=3D (off64_t)sup_bufsz;
 =09=09off +=3D (off64_t)nwritten;
 =09}
=20
-=09return RV_OK;
+=09return rv;
 }
=20
 static char *extattrbufp =3D 0; /* ptr to start of all the extattr buffers=
 */
--=20
2.20.1

