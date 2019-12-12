Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24E2C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 23:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81EFF214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 23:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3rKK9vC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbfLLXdH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 18:33:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49043 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730934AbfLLXdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 18:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576193585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HdKhJh/qqAzHDwkzLqaUqRtiDHeAJoTAJQ63f9ozLGM=;
        b=g3rKK9vCnnSfv8SH/Phl70MXe97J5y0pjzgDb+DNGogYMkc6qn6dC4/+9RLZTnfx/Bpofc
        McuvSPpqZUrNyK19AtWW0VmQwtojYrTy1Z3TgiYExHD5BKWZxQasKhVpRLslmo3kO7F/4f
        dNpJaWQ/9W9T7QsUNJG3caxAyn86j14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-7Leh20vzPAqrE9eZ1sR5Jw-1; Thu, 12 Dec 2019 18:33:01 -0500
X-MC-Unique: 7Leh20vzPAqrE9eZ1sR5Jw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F99A107ACE6;
        Thu, 12 Dec 2019 23:33:01 +0000 (UTC)
Received: from hut.sorensonfamily.com.com (ovpn-118-17.phx2.redhat.com [10.3.118.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D07C67668;
        Thu, 12 Dec 2019 23:32:50 +0000 (UTC)
From:   Frank Sorenson <sorenson@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, sorenson@redhat.com
Subject: [PATCH] xfs_restore: Return on error when restoring file or symlink
Date:   Thu, 12 Dec 2019 17:32:48 -0600
Message-Id: <20191212233248.3428280-1-sorenson@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If an error occurs while opening or truncating a regular
file, or while creating a symlink, during a restore, no error
is currently propagated back to the caller, so xfsrestore can
return SUCCESS on a failed restore.

Make restore_reg and restore_symlink return an error code
indicating the restore was incomplete.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 restore/content.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index c267234..5e30f08 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -7429,7 +7429,7 @@ done:
=20
 /* called to begin a regular file. if no path given, or if just toc,
  * don't actually write, just read. also get into that situation if
- * cannot prepare destination. fd =3D=3D -1 signifies no write. *statp
+ * cannot prepare destination. fd =3D=3D -1 signifies no write. *rvp
  * is set to indicate drive errors. returns FALSE if should abort
  * this iteration.
  */
@@ -7486,12 +7486,13 @@ restore_reg(drive_t *drivep,
=20
 	*fdp =3D open(path, oflags, S_IRUSR | S_IWUSR);
 	if (*fdp < 0) {
-		mlog(MLOG_NORMAL | MLOG_WARNING,
+		mlog(MLOG_NORMAL | MLOG_ERROR,
 		      _("open of %s failed: %s: discarding ino %llu\n"),
 		      path,
 		      strerror(errno),
 		      bstatp->bs_ino);
-		return BOOL_TRUE;
+		*rvp =3D RV_INCOMPLETE;
+		return BOOL_FALSE;
 	}
=20
 	rval =3D fstat64(*fdp, &stat);
@@ -7510,10 +7511,12 @@ restore_reg(drive_t *drivep,
=20
 			rval =3D ftruncate64(*fdp, bstatp->bs_size);
 			if (rval !=3D 0) {
-				mlog(MLOG_VERBOSE | MLOG_WARNING,
+				mlog(MLOG_VERBOSE | MLOG_ERROR,
 				      _("attempt to truncate %s failed: %s\n"),
 				      path,
 				      strerror(errno));
+				*rvp =3D RV_INCOMPLETE;
+				return BOOL_FALSE;
 			}
 		}
 	}
@@ -8021,7 +8024,8 @@ restore_symlink(drive_t *drivep,
 			      bstatp->bs_ino,
 			      path);
 		}
-		return BOOL_TRUE;
+		*rvp =3D RV_INCOMPLETE;
+		return BOOL_FALSE;
 	}
 	scratchpath[nread] =3D 0;
 	if (!tranp->t_toconlypr && path) {
@@ -8045,7 +8049,8 @@ restore_symlink(drive_t *drivep,
 			      bstatp->bs_ino,
 			      path,
 			      strerror(errno));
-			return BOOL_TRUE;
+			*rvp =3D RV_INCOMPLETE;
+			return BOOL_FALSE;
 		}
=20
 		/* set the owner and group (if enabled)
--=20
2.20.1

