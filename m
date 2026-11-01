Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550480;
	b=0LGFSgZZd/JP5OMVM1L0F1r6CZjVjsBp63qhl/uWYVm/dOr+M/QT/T8Rc28cduzuOwTR
	 hdh1jF6r3lakFqpzxfyo63ILvttcSsbuql6cZ2WeXdIpmbwh9nCsIAAiLhLVg3KC8oM54
	 rbvm33DzseCMvNl9H1W6kbup+g+ru7IT+xrfWMNVMKwGXLsYDacmmPpKF+CM6LC/Gv7Oq
	 YDLPJtB0B5s4AB/BSH/I7OhB6U5Ftv1PwHvz50bNgkZ8OVDPODbNu5r1mVrh6Hgdinb06
	 4XoiSl67/TIzCORZdqyL9KAeJxAkXomI1lGFuK8W68D9B5O/DY1sYOMB/jxHeXJF3+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Lp3PD+Wc5gwkcUVzOJ9F6L0GnIZkLFC/kLgvNsq48cQ=;
	b=m5gckc5HNQi6+1DLPr3vuZRRvf+h4sKCoIsq4sCbs7PIj8Myuu/NGB/LQPgtFfLlDGFT
	 XMhy0FMvdSztm8DhZFfMsG9gYnxXS9u6gignNtc/sjVzBDw3iyD69RovIF86SgsGhJdMw
	 fjcccEe+2XJVV43xqRIcES6UYaE0AfkZBoXz9+NhEw7UcyqCHeIPCs++g44TJfRcopNKr
	 vtezCXZdDbnNC616bq+kzzZv1QuY7dcAESJE0Ap4ZQjYDameqQdg1eBP9z1GRqKI3Q/i9
	 iuUFsgvAu2CafqEA0606LErIVeIO+VciMsllPUyIavhzfpoOoo1nlFp2z0Idc+sSa/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fjDmj4Kw;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29216606A325
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29216606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fjDmj4Kw
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so19378755e9.0
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550478; x=1794155278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lp3PD+Wc5gwkcUVzOJ9F6L0GnIZkLFC/kLgvNsq48cQ=;
        b=fjDmj4Kw/7wK2PWf+CEE+h23Ji8u4sZWOSO/m7R+MM3qL5YmAmz7rSH8b0h0C/GlSc
         FHkRGLh8L0ySCczKNsMxFguTf8AxqPQfjc35OeCLpZe/b2O6DnBNsIERxZVJ3069VMGd
         StkqcdbVbnFJzW0iNyuTiD4u3HYKeFmfIIFrTmKcEB+MKXXGyxIPx2AU0bw4p3yEX2iv
         hpcYe4fCgdyJRg+2VD9fd9n+XOJGpK9kXxRIW0bKxCKhtNiUPgBIqtj0cqUOuK23IN3l
         kq6QuXOMg3liNE1J7sJep9XT785/gaK28W/0MVdKeUYLiBAoo3GNOcIJ03RQc4UVt+83
         Z0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550478; x=1794155278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lp3PD+Wc5gwkcUVzOJ9F6L0GnIZkLFC/kLgvNsq48cQ=;
        b=gRLhii9vL/YpMVZizY6AIKvUsT96ngHYDI9lDpAq/DDleCN5m118lq34rk3xzcyzmA
         m2Vr/BG24tGjjr8ryUXaS6R9wPtfXRLsghjVFIDasCbUjKjPwbXFbxUgS5lR4ZeK61yQ
         ASyS4mpG7Lg+p0QSflObUWv+ltLDMUjPpmjT5y0FEq2CIeEYJ7xBrmlb/xa0vQgx/5g3
         Q/h/8J9DL9uQdbl4Sv4t/avM2QjotjnquTmflAct3p7VVdEhIz7qIHQA5DzUewkyt7Yv
         E0FeDNo/oe7ePianSaiqDxKYl9qnscLez6KYGUPWOEW+qhhdQRckih/St7D/Dd546Gms
         M/gw==
X-Gm-Message-State: AFq9FYKABSPG4slR+9FLBlzmDjsm1V9H8hRv+0yzFZQmzugUzSQo6yXV
	vq2I4OrIxygBK8uilS1PRIATb80m2sc4cNLiBt0BOsih0U/VwOOeLXT1DBar
X-Gm-Gg: AYBFou1uTWPhlgsLFCX1g8l7Fh0WSMaDi76TN5tEAFGpZ1pvaaZ/SMT16ADk4n3UnlF
	hfPcDIbqzqIKyi4Ab+nQNj7w88pOAbnM96O0Z8xbpknScYbjCzOieOPgD4uwWmuvKPVUsfaFQba
	v2/OShtwqG/ClSrXX/sS5LnonYMExaoz9HunRe8EK7hpg+m4huasM4ZAhyXQXCTSH41b4HRnplY
	VZl4PR3NCjCak5117mTDVXFSy0A/V0nBbyBKxbt3mUXZaIwiJpssOxU0kyA65hH2K3cZsBNnF5U
	nPf3gTNT+audqNNn9wO0iBOmYzuP8FpSYoWzHiEWynhD+HSsx0qQO0Aprq5bsQSSG1D9PYWRwrB
	N7txDmrOvTtXFUN/nhnH/nFPSA/gPsioragf8BDGpxc2S30XOPm1vJF/t0Dp6noRr9hOcrc1ilX
	gwccNPtP65v+6YlX0Peb5bOLkVsiA5IfqVFSWu1yrdChmSmxnb1O5ZBJbgA/nIp1tffvO3iDkSK
	+BtYaWuX9QKRM6qkTToxx2ajd28Z3WERH9CJeLMRRSucXHxprnlJ9WoWsPIFGjn5qLcFcihug4v
	cstAtllDHr4=
X-Received: by 2002:a05:600c:1d11:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4ac174712admr187680465e9.10.1793550478383;
        Sun, 01 Nov 2026 08:27:58 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac0a66caefsm167095245e9.5.2026.11.01.08.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:27:56 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsdump 2/2] xfsrestore: validate ah_sz in restore_extattr() before reading attribute data
Date: Sun,  1 Nov 2026 16:27:53 +0000
Message-ID: <20261101162753.1443201-3-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101162753.1443201-1-tristan@talencesecurity.com>
References: <20261101162753.1443201-1-tristan@talencesecurity.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

restore_extattr() reads extended attribute records from dump archives
into a heap buffer. The ah_sz field (uint32_t, up to ~4GB) is read
from the archive and used as the read length, but validation was
assert()-only and compiled out in release builds (-DNDEBUG).

Replace the two assert() calls with a runtime check that rejects
records where ah_sz exceeds the allocated buffer or is smaller than
the header size.

Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 restore/content.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 9074c34..ae769f6 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8667,8 +8667,13 @@ restore_extattr(drive_t *drivep,
 		}

 		recsz = (size_t)ahdrp->ah_sz;
-		assert(recsz <= extattrbufsz);
-		assert(recsz >= EXTATTRHDR_SZ);
+		if (recsz > extattrbufsz || recsz < EXTATTRHDR_SZ) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+				"corrupt extended attribute record "
+				"(ah_sz %zu, max %zu)\n"),
+				recsz, extattrbufsz);
+			return RV_CORRUPT;
+		}
 		nread = read_buf((char *)&ahdrp[1],
 				  recsz - EXTATTRHDR_SZ,
 				  (void *)drivep,
--
2.53.0

