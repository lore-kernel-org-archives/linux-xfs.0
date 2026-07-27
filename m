Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2971432E7A
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187504; cv=none; b=dSw/AlpumgMi4hKHFUSr0D9kd0S5G8s43cXBDVcb5XKfDFkY+fBYB3iwFdA8xsUEJohD9jOz4nv3lZbWePq7OplTibzxJ87TOYhRWLR9iioq2gdXVBe9ao5BQZ3I1a6giyp/9nvav/Wizv1gDPz8FvXz3knfCmpdZwkENqCyW8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187504; c=relaxed/simple;
	bh=bAIl0EYJtqhiY+G9Xwxws/qkXqkeERtNBUa0GVKm6tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JP6qVaYmKYcMv7pcbSUmZTQMrJLYkK86M84qPjCTJVC5vV+of4PDbw/gyA9Fl5nee62TifV8hvqQ5rNjsUTHQmdrpBxt/cw8cEwPV/c4rIIfvFATXChDE2fexBmv/oyOc65LOIv2APNqzZ9wjDq10lC8CS7yiexeLENiIW+o1ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P3Ucnxfs; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3Ucnxfs"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84536ecfc5bso3687895b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187501; x=1785792301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=P3Ucnxfs0Tt0opNvR5KixqqyPjRUXWwKTfsspysTalwXYX7UA2+/e8xfO5OJZ6ozwf
         zrLjcCsiz5uGfrdCqWBrtg9l4wExQEL0iJkl9SC+EfFz5WPsDzjRTG+PU+MC1sfbfp17
         obh7hEGzuUh48o5cLdPE0sz44w3GigVGkUP9DfT1gmpogd3MiJ2q7g6o3HdTCs6tEsiW
         6LmJG1jtc9ipEzjpUiVySyyYzLCrdba5S2Bs//8m0+XOL4vttDyqh3TQ03nWXMP25NEb
         65inHwFkpJPYKHa0+26sS1lSIlALfGzWCoY+FdXJAVeFLZxv3fsfo0snxKB1RTsyHdHO
         8zZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187501; x=1785792301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=DFJb5kHrbLVvZJ5o9UCgvsvEXIRY3YR7B36gphXP1Qs9lzM5tM3J3YqyDMeKQ3n83i
         ULKszwvln0coPBFPU9DQpASHJ4ZNDHWzIzH2I+5VWZiwYns2X2d5hUZc4UnhTXAxIr5v
         aVIrunzqk8JnxnABUO1Y8VB5KBctIi7BLKZfTWFnGxztpYht9begGoMbwGgmvECNeZK+
         FtvyE2rRuXgpHaY7rpVP0xCvlTd48ff/w/mWPmKunYIbxg5BT25rgOjt9NEAr0qmMndr
         ZkTADKeKeqJ1i24Vn6rCdSVlJTV7TAqs8Kp8OSGdZHYbhSFQXmuUG4rfHVXGYrGLDrLU
         Lu3g==
X-Forwarded-Encrypted: i=1; AHgh+RqDUurdYKN72bkj0ZRttwRHOW3iajQiIH6fZ7H5kMCEEbmbg5A8ssaSg5zh2+PqaHsODSsD01LxWQE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3akTuqugVogBzkdlTujV0VAflu2z53LRAPBTklsyh2cboURfj
	MAbHkni3cOrVb1tkOBr6/v9ByZcU7us4eOC8qEeVXraRRUi/NvUnog3U
X-Gm-Gg: AR+sD11y/272atypYfRWmUrWZSP0V39p5wE9KDVbIL9I8sfX+H/7IJ2CAKkEVgfLyi8
	KXh+YhJDuQcJd/9jJHOEFP9PCdFX9RXOBK7k97erapQ0NPruFhP4g/sdwSTNkbmk6piZYebH1jG
	dCTlZ2Z7ku5kUJoRnxsZVNN7BeL9+YJ1ajy894pQSmNN9T+2eICMbr8LJJ8PV+pG5e8caqFMCoN
	c1wPB+N2R/ot50vlyVNG8rI8IEeufN2jH0aCPExgGm1Gm1O2GwfiQzhqYKccuRAORozw4RB0GdV
	F8aQzanuFlkLM/Xo+N6ngnXlc2fMWLG2dEBLtyum0i+puY5I23Ddug8weXOTcnX2NewOwmxovJR
	rLnC5aIY2Q66xADU70e6sjOguNirvfs9t2C4TIZzmPoJTsu3K3zT7WlqvHNAYcJATJ+vUB6wtlW
	IixatcqvnEWKwPUgEL3aaZjA6c6ZrG2+YGHMHCXxOue/Pv+IpW97+w
X-Received: by 2002:a05:6a00:b83:b0:82f:9d21:d352 with SMTP id d2e1a72fcca58-84e59425aa8mr8011998b3a.9.1785187501097;
        Mon, 27 Jul 2026 14:25:01 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53426628sm3568830b3a.49.2026.07.27.14.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:59 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 16/21] hpfs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:53 -0700
Message-ID: <20260727211758.1116539-17-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert hpfs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/hpfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 29e876705369..6a629ab956fc 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -156,8 +156,10 @@ static int hpfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(hpfs_iomap_next, hpfs_iomap_begin);
+
 static const struct iomap_ops hpfs_iomap_ops = {
-	.iomap_begin		= hpfs_iomap_begin,
+	.iomap_next		= hpfs_iomap_next,
 };
 
 static int hpfs_read_folio(struct file *file, struct folio *folio)
-- 
2.52.0

