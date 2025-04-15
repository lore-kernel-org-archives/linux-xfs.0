Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23A1235371
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744743189; cv=none; b=XXcHCkL+sjjZA6oO/+W4LfQkDlvaB1iQlhnFDoFoCX+kvHo+9slGVrdWCmmXKv9pxdJ3dQG069K/24Mz+XwLdoO4QjIYDpK2ptJu7VMD2L8LfWIrU1kdq9YuNZha0Q9eXpVKi3erwau0Op+vLeBHJ8g5Negu2S33ozn4GITWA24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744743189; c=relaxed/simple;
	bh=XAo8NgSfTf7eAA3ggJO7RMQ4rG7rOHI3IAYW+y0GFDM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M9McbntWkHqY5i5d8n0wWweCCuVMXx8oQxbNoYZoNcLNCzO1v8Z+wFIHfE2h3cITNXyo7nTDib5oNtL+bn/cL42kDu47l4viDI0nsOzhDIfajt1OZku2FAkSOsRanRq4Oae844AVnN9gILx2vYtLaw5JDKNwJuAOQMiVnLXiNuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EheeS4sz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EheeS4sz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744743186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c63EC3oV1uXNAMzRXTpQXfb8n1/po201i3RwOuY+VHk=;
	b=EheeS4sz4DDLnicJPTuQuS0HR9N5vMDxM1vdxn0/GEAv1/9qxA7GKVtf1cU94s2wkco86q
	+qwoDgYCVSxHvNSebKTiKC9I6qIituSrRKAhQN8oxCfOg9FNVW/lEYfHTNejuJMlhTUo6F
	6rf1rtSslFX2xmSTyrhJfjKaFauEEho=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-lzGcO-fuMwC4ZNj3CTrS_w-1; Tue, 15 Apr 2025 14:53:05 -0400
X-MC-Unique: lzGcO-fuMwC4ZNj3CTrS_w-1
X-Mimecast-MFC-AGG-ID: lzGcO-fuMwC4ZNj3CTrS_w_1744743185
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c0b0cf53f3so913755285a.2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 11:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744743184; x=1745347984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c63EC3oV1uXNAMzRXTpQXfb8n1/po201i3RwOuY+VHk=;
        b=EonZnT54qr548N6dAG/slnAgOpC/m0200bUo73R9uSKvAXPxt+nRMtqZShNb/yycCE
         0W8cl60cbAmBoxNUCaPGcQW2jdiU3MrpUpwF+oHr26tm+ro5oHUy3ZgFXXWLbmC/8XBU
         XWWmwG0WIK4x+UTfId98vQxwlK7ywScyeHqaL/B/U1f8UqouIdgF29XgoCptFAB3UGBU
         Hzk0Dfn/9gNSQ5JFPq4nXTlKE0y87yHTDYrvzvmlD7kJRIb5Wrc9cxqYVLEb8xh3/EkI
         J76p4c82GetZdkSiQkWSOxnti4D4f3BWkjFWQ/lWSfzmOL6Be+RwQnM3rZBtVjyqa4Sq
         weXQ==
X-Gm-Message-State: AOJu0Ywo9cWBcLQ2qjBbVS8P8J1votaPOffXHWl5mM0/KutotsuqWA02
	bwIt2yvlbSCOiQZpI3PTpOm79nMpO5lud6/HH6JnwGHY2ScXJOJG3WteNol6Osa+02UHg511PKQ
	y1PCgHDVUTX3I6QBXDTh6w2s/0FjQRYQy69XguD5aEokG6H83EPR4NIEA0giFg2+mBpcwpjwy12
	T1Y5SlkyifWj9hykmWmwpR4aysgDDsaeSNjiSkCpyrEw==
X-Gm-Gg: ASbGncu2b+ITKSkwG0XujwgHSvtGC/uh22Oi/Dk60LdhrRXQPl+TFRkjErkJ6szCjhH
	IDxd208qHTzLLCiOTz+vQQHb6d3b2TMLV+IddOOxRVFSyrnQERkNXV3SYE4Sa9kARcWM7gabXZ1
	9A3e+l2PMu/yuF6b+uJJ0S8UjazjuQNqoEfPtNSxiPwF/IeJ8/sjt+nDdIFgCpIs92hF8QnIKg4
	Qddb20oGW44W6BQTKVzXfS7ksYWdJk0Kdbh4zspfMbn2zbb/a1dmoq1YpcblPh5E5CmF+6zyarr
	6GDME/gMMIlX7D5DRCU1HQmzcYDpn5mYMzCBW43tn/wnf7HWU36I1Q==
X-Received: by 2002:a05:620a:17ab:b0:7c5:56c0:a8 with SMTP id af79cd13be357-7c91419efa3mr91229785a.1.1744743184383;
        Tue, 15 Apr 2025 11:53:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAdP0bW0mzHh26DpWRlCd0qLomfqpjzXuR17c8xppKJT/b0F8AQRVbrtrYeTF59tjpIQ7sbA==
X-Received: by 2002:a05:620a:17ab:b0:7c5:56c0:a8 with SMTP id af79cd13be357-7c91419efa3mr91224185a.1.1744743183930;
        Tue, 15 Apr 2025 11:53:03 -0700 (PDT)
Received: from fedora.redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c7a8a1c798sm933980585a.116.2025.04.15.11.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 11:53:03 -0700 (PDT)
From: bodonnel@redhat.com
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v3] xfs_repair: fix link counts update following repair of a bad block
Date: Tue, 15 Apr 2025 13:48:49 -0500
Message-ID: <20250415184847.92172-3-bodonnel@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill O'Donnell <bodonnel@redhat.com>

Updating nlinks, following repair of a bad block needs a bit of work.
In unique cases, 2 runs of xfs_repair is needed to adjust the count to
the proper value. This patch modifies location of longform_dir2_entry_check,
to handle both longform and shortform directory cases. This results in the
hashtab to be correctly filled and those entries don't end up in lost+found,
and nlinks is properly adjusted on the first xfs_repair pass.

Suggested-by: Eric Sandeen <sandeen@sandeen.net>

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---

v3: fix logic to cover the shortform directory case, and fix the description
v2: attempt to cover the case where header indicates shortform directory
v1:



 repair/phase6.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index dbc090a54139..4a3fafab3522 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2424,6 +2424,11 @@ longform_dir2_entry_check(
 			continue;
 		}
 
+		/* salvage any dirents that look ok */
+		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
+				irec, ino_offset, bp, hashtab,
+				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
+
 		/* check v5 metadata */
 		if (xfs_has_crc(mp)) {
 			error = check_dir3_header(mp, bp, ino);
@@ -2438,9 +2443,6 @@ longform_dir2_entry_check(
 			}
 		}
 
-		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
-				irec, ino_offset, bp, hashtab,
-				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
 		if (fmt == XFS_DIR2_FMT_BLOCK)
 			break;
 
-- 
2.49.0

