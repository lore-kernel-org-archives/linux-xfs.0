Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C52C38AC8C
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783450865; cv=none; b=bEPjaVFXGSi2pGDny+FyTMzujMa46oBeG/qEXxSRDkBc+VVxj7H1OS7n2O1dSLxsMN1yPzxJeOJPcARrLSkvY5WpLbXPukRpwdBRD4wMQXj0wB3nyENEF7hcb0tGSP77+hk0g9VdCgGsCQLR8/gXFqXGAEDBYjTJr/HPntguGho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783450865; c=relaxed/simple;
	bh=g1HCBr8bsZcnUx3gO40OyrqGIOY7LwAa+VsmFs5/+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3A3Jl8G+MqsdyEx3UP7WlJr2Gckz9rcK0r9AyOPZEfEi+nkwKxtGGb24nYMskObw2Nd2JpVOy1KS8pr/qgum8DadkSESQl1kosTHqS0eqoAaSbwDc/3PoRkSrt6jdy5TkkVwC/0sOPMS5Dg+IsXRRFfcYHP5mEI9/pMyabCKF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d6biJs5W; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6biJs5W"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so3434941a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 12:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783450857; x=1784055657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lN2b/UwZ6UTOnQoQGsvb5dcfV+ZMY1X8+RCUQeVLWRk=;
        b=d6biJs5WL2W39/mWRte4YaVvkmFLFkQsNXihQs2Hy42ezuZ/3T3pgZ7nbCCCQGbEbX
         eS5oeljPWhGMedj9Je8hGaEj/1L3jbt8D5gqLgeVXhIZW4JqQQTMGtxVx/hGXnXLLZOQ
         05B3sFpRJHm19xwK8qxn3j24I2MbuWskVFZAgmA3HGDH4sWHbYNtPujzNbSNCqA0vrAY
         pUWEJPVnBdRPX7QAAdUqrC9nJt6mpOog/Ll7bBTRJZov+p72/SEt35AgfUqLgDuJ10vE
         H+Rs2Q4pRetJ4GO219GF6Unjf4xfdz4yTmTvW3jSR/lJ1O/lpn56tPt3LWDlzOdcPzQE
         V6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783450857; x=1784055657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lN2b/UwZ6UTOnQoQGsvb5dcfV+ZMY1X8+RCUQeVLWRk=;
        b=bXyL7E5Qw4ViHds/D2IFRJ5EfzmhNHSRplap8aK5xXmeOT9QG8SvThkA3fqudpCy5l
         CBf+4Ts+NbEqfxS5OkYSkpFvVytky1n4h8Zsk7ivf/kLlALGKSDyZma2qUQf2H9ThxzH
         lh7Hw+aux05QrrzNN7SlIiE7FXwrE/uqEn/ffcVvD5/RVA0qY3gnMKVP85AHlaFp745G
         rOeWyzLK9wa0dugd+yRPjWdORJvJ8C2NigN1hT19C7TAYAW2iHWD9bZpUUIws+4XfWdS
         aV4XKTGqpo9cOH7YNHEUEa8jpuc2oEjyK4CVq/kbtMMr/ieMS/3z5y4W3txKq5qkFJV6
         KS3g==
X-Gm-Message-State: AOJu0Yxy38oAcsvyqXrTjTS8mvSkU+3mZJMfySTEd1VZr2ztio4M5n0P
	BDankPPi3f7p6QIGTLWq+lH9R8lVBuytjpDPOJXxux4kNJcaJsBln0zK9plGrdixWcs=
X-Gm-Gg: AfdE7ck75klbkPXCyucfkYLYITHK666b3zytyt8/bZ9OzjXaruX0btxYPla/bGc9yaB
	yXQkQIB0pdxpv+uiAeYW/Hqvd3P2h53K8aFvooiU9sEaCNhoOC5cFwcQdFIbMwQKzCVC6AHxTzn
	u1JpA3bdSuATNzMZSBBJr+rhZ/lGhBlO+kIrTGgeds0MdP5fh2sTO4zOFtFSXeIJmA3iiPuLJsZ
	yURTAMEwqLE7hmu7x0OdDC5IBPjHGpWaYOkWPyKn/gdJNTpBacbvd2BFOEAKVN41CmnSn+V8hT4
	AQdO9aQ/f18u7Ayov6FC6Qg8bkFqgWS1fteZTQGtpbFDgPazKDEgXVSyGlQuLBTBp6C5cY/ufw2
	Ce/WBEcN0cJVh72GN+UNl707kZX4A+jc4IeWJHQB1EG4tFx2GPucdHaTUArsQH9XqoUdau+pjam
	ylgXQt
X-Received: by 2002:a05:6a21:3981:b0:3a2:dabf:fef9 with SMTP id adf61e73a8af0-3c08ed5558emr7556572637.27.1783450856632;
        Tue, 07 Jul 2026 12:00:56 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a583bcsm12305248eec.19.2026.07.07.12.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:00:56 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: reject remote xattr entries with an out-of-range value length
Date: Tue,  7 Jul 2026 16:00:38 -0300
Message-ID: <20260707190038.3811440-3-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707190038.3811440-1-qwe.aldo@gmail.com>
References: <20260707140118.3217585-1-qwe.aldo@gmail.com>
 <20260707190038.3811440-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
the verifier and the CRC.

That length is later assigned into the signed int args->rmtvaluelen
(xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
-ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer
then memcpy()s a full remote block into the small kvalue buffer
(xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
attacker-controlled content, from an unprivileged getxattr(2) on a
mounted crafted image.

Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
the leaf verifier, so the malicious block is rejected at read time.

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Cc: <stable@vger.kernel.org>
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
v2: cc stable (per Darrick).  Now 2/2 of a series: 1/2 fixes the signed
    value-length check in xfs_attr_copy_value(); this read-time verifier
    fix is otherwise unchanged from v1.

 fs/xfs/libxfs/xfs_attr_leaf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d0f7753659c9..948dc8b26fe6 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -339,6 +339,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)
-- 
2.53.0

