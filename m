Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792526197;
	b=tf1bdJZB2pt3tSP7amEj1ea+uJmFgRDm4ArFHnCBLna9I7xI1XfcqxXvB8E0/h67C3Ic
	 pWWeBferI7ybAOdLLU+wYExcZz0tfVXbbLDMLVAeCM+6KBeGcgq5viHTVlIoCFieg4MZw
	 hwkERndmpi/QkgvI+nLLeExWh8ueNMJFgnBuHhwsSSWGXLH6EUXGRTjXB7Vf22Jk8A5yK
	 Gx13cxtyhP4AP4G8pR7vLWHmJ/QmmwVBknRR15EwM/a/ro49yLvlgfESC5FNtv3baUcwa
	 P3zUpDBgToaS7zbAARM7IaZhVRlX2rOSeWHeYGKqgI5uteNGBD+TPBvISIM6EPeRIqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792526197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mpQ3RiWaLmkacBrX11wLWQ7ZHjfXoVlldjLf+y4vUcc=;
	b=Z9iLThkofas/E81N480k1fiU9g+brdY80S9Dl616dddhMFBSpLMKwz00SZzRbK0UdX1l
	 EzsFGHUFDxsSRxhvsS7el8yV/rt/Im6cr0ZJKQhwVq8JvghzDdDNRj5K/68nKKEIxIr8m
	 FWYT7bXAi9NMtExPPu9OQpSjrHSFWojR8PVdzx3bq/r2a4QICbU9v6kBb6aLPM3tqvntG
	 dBVq7xwHB91jBFQ9ubVXgR8Q+4y7p14XXfB2Kqc6FZ+5YVA4sWRDMV8urjmtFQIaWNL8N
	 Mjg7p80pvP3ddcnqIEwrwjqZEWqI0yhj/9nzr9Hv7xKfFgYYckSyl9x0AHlW1sbCUnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZwpWDIKt;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DED6606A319
	for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2026 19:56:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DED6606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZwpWDIKt
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1e3098ee2so31541425e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2026 12:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792526195; x=1793130995; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mpQ3RiWaLmkacBrX11wLWQ7ZHjfXoVlldjLf+y4vUcc=;
        b=ZwpWDIKtt08y2XY2XJbdbDMsdI3O3ojs/U6Qb5zbdYWZiPXpPE9gF89HadmJa1jcrM
         8VeRguG42uIlGtJ93H16GwgPsu+R1sIK1VAUwBv8/9CfVvs/lP/7je7CL8uigPPekNo9
         szIUhsIU6mG8dyUKvAl49igo8+SXGa8ov9PBEmlGFLkYGEDoNly3aHI3CLcLGGH8vgXG
         XkMLBrXGCDWO7ZB5AhlXFvb+yI5r3kcK11X1HLs4podPeQxPDDbQmXqTasZ3nDU+jE2f
         KVTa9IiMM5wcSh1WUePySQ/cdhLDaZ0t6oFnmhimDtrPE1W0KRivezpX7LFnXKp17sRt
         b5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792526195; x=1793130995;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mpQ3RiWaLmkacBrX11wLWQ7ZHjfXoVlldjLf+y4vUcc=;
        b=2woKx7zqhvb8S4webmxwjE39mxx5ansuyzCYtqPdGAbyw0tqKbbDa4NbsGeOSqQoWW
         fDE0Sd6GSUUz+DB6w6CUMf93bqEtKPzGFjyOClrv+VWcQmNT0iI1tkPlzny+NKcxUIkU
         UwkcnODzOQr8x4mU56wrcX708EibTu10aeoAdqkEqEk32EZflcTJg+yMdkPF4GXIsgX6
         X6E3QpjXIHlw+crQ0FlRGe7B1nwaV28wTzFDGuwXC+jMCcMxQ+sJmAu8fCbzlfQuQrlK
         a/d8TqebOz/TMyzQLx0WMEJe2whK38q4cQBXXJMP+jfvO4JDIUDgcCkxHVuX4Y/YMUW4
         f9kw==
X-Forwarded-Encrypted: i=1; AKwUvBwZXeZ407ELK4dQRSGs2ZwK54oS48yrfDZTWiA7b7VaWf3OoMSPeF+TYO+L40uerajzq2litNzN7rw=@vger.kernel.org
X-Gm-Message-State: AFq9FYLUQnKwxJaN6quMU11H3ZKnz7c7bm4vctuQROEHkA+6XzCP4Ce6
	vN2kgeV2lvl9uLGk4cBpwEtRsVD2B4pAmPNsqcruD84xojsLd+Ko/zRt
X-Gm-Gg: AYBFou2yzaO+Bz6MYUzeKD+5jcIK9sweCr8NhzD4u16rf9GC9CAcedZaaBqoYeB44mV
	/4F1hG7PhEwMxtqxmmIXGKn6Vl+xwttXRYfch/h18gjkD7eNX3a3SGzQtD1jXNe7zKLGCT7g6e1
	q99VtVh5hB/s0xrs8/EiFLFtAK2rBAb5nsKahdap3A41I0alufV0yhTB5XF6y6gh4Bioj4S5hRB
	MOGrxzQ5oSQEg5FCbGAawvQIgf5U4bsUuEp+EEFIIRNcTfSv3o4AgpC56syx+04zI035i4Z2TrB
	G1VMHSa8eg8Lg8r49CrOhlkKlU/xQ7R335RxpQFhNTaFQHjUcL4eaHwojJVzQTXdjTNPJ0IABo0
	LerrCf3aTwqR0xr3kaA2UUk9wNpe/pTHd/gaVdBbwHJ3wwFvjSxaUNAiDHvbrB3kuc82TcYJDFT
	aGcMmbaQ19BqEIIowgk/b4AvaAedz/0jmJdu9w8W66JFJ01gVYxWnK807bAmgCh7NZsFaNVEv/p
	SniaBZ8AV0=
X-Received: by 2002:a05:600c:190e:b0:4a1:90d7:88a8 with SMTP id 5b1f17b1804b1-4a1d76106c0mr259156705e9.25.1792526195325;
        Tue, 20 Oct 2026 12:56:35 -0700 (PDT)
Received: from ADRIAN-PC.lan ([171.22.87.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d699dasm103092035e9.12.2026.10.20.12.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:56:34 -0700 (PDT)
From: =?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
Subject: [PATCH] xfs: add __printf attribute to xfs_buf_alert_ratelimited()
Date: Tue, 20 Oct 2026 21:56:28 +0200
Message-Id: <20261020195628.248878-1-adriangarciacasado42@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

xfs_printk_level() and _xfs_alert_tag() in fs/xfs/xfs_message.h are
annotated with __printf(3, 4), but xfs_buf_alert_ratelimited() in the
same header is missing the attribute.

Because xfs_buf_alert_ratelimited() formats its variadic arguments via
struct va_format and %pV, the compiler does not suggest the format
attribute under -Wsuggest-attribute=format, and callers do not get
compile-time format string checking.

Add __printf(3, 4) to xfs_buf_alert_ratelimited() to match the other
logging helpers in fs/xfs/xfs_message.h.

Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>
---
 fs/xfs/xfs_message.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 811b885f41..bfae8dddc9 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -87,6 +87,7 @@ void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
 
 extern void xfs_hex_dump(const void *p, int length);
 
+__printf(3, 4)
 void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 			       const char *fmt, ...);
 
-- 
2.39.5

