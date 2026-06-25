Received: from mail.camora.dev (mail.camora.dev [45.63.89.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9413524F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.89.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782426730; cv=none; b=OVmoJ8KlYRrCSHMrJDZC/+Y5BQBzJObzUl5pKrEAuAvMhOy4S00MIuyF/OwVuIzFwwREgcsORPg7Qh8y9AfVE+XOmJMnKIgKo0gjhSz2qswFbEnSDdJXrxO993ZKwxIpPEial0bbYm3FoBs3BhtyI/zNdTi1MwDL2BHjJvKOmW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782426730; c=relaxed/simple;
	bh=Fb4WmF/vA9OLO7RtaLZtR4zPyO7lrOX3CKtK7sJSQJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hsTuXB0W9GU8CHjMzdFeq1xKjPhVhbk2GIrMta2Z4htdWMKR3C6C6GYEuLmQH4fPoe0FbMmG+Tl2dxkSg1Ibv5zTPQcG0oqeVOv46Ri2Lhn3SfRiXga7DjzsT5bnzFjKuPKO9T8zAyGZExwV+Iv7a6EwKNuEFNrQ7T7elcINqNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=collar.sh; spf=pass smtp.mailfrom=collar.sh; dkim=pass (2048-bit key) header.d=collar.sh header.i=@collar.sh header.b=MRCeIEmU; arc=none smtp.client-ip=45.63.89.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=collar.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collar.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collar.sh header.i=@collar.sh header.b="MRCeIEmU"
From: vmfunc <celeste@collar.sh>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=collar.sh; s=mail;
	t=1782426218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D+HsYipQY9RQFQp52MuFxZeos8QYZ/++KBaW7r1f1rc=;
	b=MRCeIEmU/RQ9nkeg4IldqbdhWpgZfzsm9LasXWvIPOIttPuHsHZcA09hOKlSHd11fVwnQv
	qQXc0pEbKnskt/FjdyAP6mRvDUwv9N/ozyV2z/mvc/XLypTqR8dT+hDElXRvUOvGDIJi/p
	IcyAsJwSrXL3Ro2dQs8cFG/lMVKWA8rRCia02gEe7T5ffRmmGeVHWgn/V2ggjrp5HpD/3o
	xFjgKui1NKwnFNnbVEyHjM4k+3BGefjkcybaxXH7lprtS4hjCZiu+LM45Z8oEofwEsZWwQ
	Xv9aiwqFKZoHhgd4rtnwcnBJ+GwTc/v8RNaP4Zjqn1gjTJBrtW3pa5hJKTz+Jw==
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	vmfunc <celeste@collar.sh>
Subject: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on long dirent names
Date: Thu, 25 Jun 2026 15:23:37 -0700
Message-ID: <20260625222337.54449-1-celeste@collar.sh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

direnthdr_t and direnthdr_v1_t end in dh_name[6], which is used as a
trailing variable-length buffer rather than a fixed six-byte field.
dump_dirent() allocates each record with malloc(sz), where

	sz = offsetofmember(direnthdr*_t, dh_name) + namelen + 1

(rounded up to DIRENTHDR_ALIGN), and the "sz > direntbufsz" check ahead
of the copy guarantees the allocation is large enough to hold the name.
The declared [6] is part of the on-media record layout: DIRENTHDR_SZ and
the arch translation paths depend on it, so it cannot simply be turned
into a [] flexible array member.

When xfsdump is built with _FORTIFY_SOURCE together with
-fstrict-flex-arrays (increasingly the default in distributions), the
trailing dh_name[6] is no longer treated as a flexible array.
__builtin_object_size() sizes it to 6, strcpy() is rewritten to
__strcpy_chk(dst, src, 6), and dumping any directory entry whose name is
longer than five bytes aborts at runtime:

	*** buffer overflow detected ***: terminated
	#4  __fortify_fail
	#5  __chk_fail
	#6  __strcpy_chk
	#7  dump_dirent

The copy is in fact safe; only fortify's notion of the destination size
is wrong. Write the name through the byte offset dump_dirent() already
computes, (char *)dhdrp + name_offset, instead of through the sized
dh_name lvalue. The destination is then a plain char * into the malloc'd
record, which fortify cannot sub-object-size, so the spurious check is
dropped while the rest of the binary keeps its hardening.

Signed-off-by: vmfunc <celeste@collar.sh>
---
Andrey Albershteyn (Cc'd) tested this with fstests on the downstream
report and asked that it be sent upstream; the discussion and original
backtrace are at https://github.com/NixOS/nixpkgs/pull/533325 .

 dump/content.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index 6462267..8d482cc 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -5151,14 +5151,14 @@ dump_dirent(drive_t *drivep,
 		dhdrp->dh_sz = (uint16_t)sz;
 		dhdrp->dh_gen = (uint16_t)(gen & DENTGENMASK);
 		if (name) {
-			strcpy(dhdrp->dh_name, name);
+			strcpy((char *)dhdrp + name_offset, name);
 		}
 
 		dhdrp->dh_checksum = calc_checksum(dhdrp, DIRENTHDR_SZ);
 
 		xlate_direnthdr_v1(dhdrp, tmpdhdrp, 1);
 		if (name) {
-			strcpy(tmpdhdrp->dh_name, name);
+			strcpy((char *)tmpdhdrp + name_offset, name);
 		}
 	} else {
 		direnthdr_t *dhdrp = (direnthdr_t *)contextp->cc_mdirentbufp;
@@ -5169,14 +5169,14 @@ dump_dirent(drive_t *drivep,
 		dhdrp->dh_gen = gen;
 		dhdrp->dh_sz = (uint16_t)sz;
 		if (name) {
-			strcpy(dhdrp->dh_name, name);
+			strcpy((char *)dhdrp + name_offset, name);
 		}
 
 		dhdrp->dh_checksum = calc_checksum(dhdrp, DIRENTHDR_SZ);
 
 		xlate_direnthdr(dhdrp, tmpdhdrp, 1);
 		if (name) {
-			strcpy(tmpdhdrp->dh_name, name);
+			strcpy((char *)tmpdhdrp + name_offset, name);
 		}
 	}
 
-- 
2.54.0

