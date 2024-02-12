Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5362941775
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757228; cv=none; b=Xe+ZU/SBsLPLUTby7U0kcWl+FJjPr0tD4z+Iii1/jTTvh6KT5Us5r0acoYEdCKrUrWRK6VGXPn5OphRbw2fQAFB1tdCmM9tRKSI9F5uVIkeDPwOeeflpb+/Ek9p4IGpwDDiWL1HXaJIEDapTP3t0o7pTYogWLgAFHeBsCOnyNbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757228; c=relaxed/simple;
	bh=QdzJQ1kBU4GhtNmWFv/v5q2u9OPK6bqQ8YoEEN+UHm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GvJolZ8TbCE0Djd3ihPIF5CadxCrJ340jfaTNTZJwSQULJz2vz38UharhGwGqMXcFjy80eb4PO91S82/YbI285CS1ncIAy2Khtq/zls58AUiABVVaInf78XLLS3W8gBhe27L23c3FikG1nK6Rg+/qVf2ai8FhyvY9qG5Eaet6VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JgW9LGCn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JgW9LGCn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CCVu6C3sA7ElU4nB0aYXUKm+yvCdjGTpJNzXHRX3ZOA=;
	b=JgW9LGCnZDiFFS+5oFXz9kfjQzIUQJlFgpFprnFoUh7qloSO3DWO+vVsjDZ99Y3Iah/GLF
	aeW8/qrUhC1mWLwBVqNdT0wdk91++mzg6Ojs4xaPu2QQClZ5YwrAU0l7fD1U3HKBosmQn+
	xuGxd0ns4RYoiXM3ns/CadIJ4DQ+YPI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-e6_y9y2YO_WEX7yAEBp6rw-1; Mon, 12 Feb 2024 12:00:24 -0500
X-MC-Unique: e6_y9y2YO_WEX7yAEBp6rw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-56001d4c9c8so2107868a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757223; x=1708362023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCVu6C3sA7ElU4nB0aYXUKm+yvCdjGTpJNzXHRX3ZOA=;
        b=QanXXI2h/8E0/WoYsCqXa1lPoP2DB70yu4ZteHoHS5ICOTfTwlP8bYFeY9WlZUZ77j
         WmyJcaTb5v8TBVem9U5t4g3KlA0E4zqpRBFbP3wjVd6cZghJExiw/knVrs8/gaLq7C0c
         mPFdAA9rXs2A4e5meK1J1Myxxehr7JhXcRQdVOMC9SNQQ/za9BdmrcyURuJFM2LWgoXj
         ih4lSLkpXzVj2HYw3FKI2NZyG4lOffyUuhBbVMMrbqYOinoKW8liZO33dCfXxWTi1UJV
         K75IEUvV/MM3hw5Z9opqMOvP2JFr2iTyZgtjJe3+vqJofisuWjLnILEhpOLdPMMLsMUH
         82rQ==
X-Gm-Message-State: AOJu0Yw7zfil8a2uOgoSQ7/Qqg2T6iC87GDxtw0teylyGiJOcPeqGYnA
	iDQ6xa3gmh4k6gBZyx+ok1zUeXGbZa0FZDtrk7/4QwEJLwuK127JyKu1xnkshC7knpNOVweWtRx
	1Fe5Dfct2qmwl9mo9Il3K+O/2xIjhcfg7sRoGxO/vOQzoLKv34aUyYwRR
X-Received: by 2002:a50:fa86:0:b0:55f:fd61:b08f with SMTP id w6-20020a50fa86000000b0055ffd61b08fmr5444430edr.4.1707757223185;
        Mon, 12 Feb 2024 09:00:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGX4QsV2jwPgEK3ppOb+fAmuTGxzi5pj46ICsgxsM5V1RWud/SUlTZ9QaiHLZpC1sd63X9YYw==
X-Received: by 2002:a50:fa86:0:b0:55f:fd61:b08f with SMTP id w6-20020a50fa86000000b0055ffd61b08fmr5444416edr.4.1707757223016;
        Mon, 12 Feb 2024 09:00:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVbixGwNn2/iQes+rCvgVp/F3RjBSehosjFCAIvdLXWSMONtUscMUhdVZvz2ojDIXeQtTNHdhZ8OVZwgnN/hd7k6GmI5Ryp54qW3fmznAn2ASgRznKnI1XzfIgGrVB3dwYWfYVzmpZ0hy2OW2vDHkBCu2jmZU1UIQXfV1xRLXQkWg38QoXASDkPImLM3obGk9jg3wyKszAXbZUxea+dMcCgzt2VQyuH8wp/
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:22 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 23/25] xfs: make scrub aware of verity dinode flag
Date: Mon, 12 Feb 2024 17:58:20 +0100
Message-Id: <20240212165821.1901300-24-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity adds new inode flag which causes scrub to fail as it is
not yet known.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9a1f59f7b5a4..ae4227cb55ec 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -494,7 +494,7 @@ xchk_xattr_rec(
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
+			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT | XFS_ATTR_VERITY);
 	if ((ent->flags & badflags) != 0)
 		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
-- 
2.42.0

