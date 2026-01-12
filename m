Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17552701CB
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229521; cv=none; b=kEvMZMhyampO7svc3Pe+vl85NrJOC6qylLrb3ZV5WFUnyoIzy3fKCKGWRaPS8tPB3li45U/8vPXThVl4ZO4txH+w5B6dDJEeV50bGh1fyCRrAya2Ka+uo33niQRHuVmeBwpFA1liOaMM3Col07GZgPV168DNcnqBymxoJc35cSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229521; c=relaxed/simple;
	bh=IdS1PwWWIbUYnlpXP3SRI6nzxO4Ju/UrhGGqho3KZ74=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QATt4R+W9BfMOK0ViBD6WMzVzTDsTD6eb/o+gnHgS0uvAsVeyspbSDBE8e26GI4jEsYaBR6OHPck6AsDlXbvEBo+OB+P9pmKg38KUwNXdEcuUr2NN6WJ1U2+rqOXO2i2w+F4gQKQ1nKcCztGvVCSTIfLhYjt9Ep5L4Qt4uni+4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gXqIpqjJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9pc0QRh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gXqIpqjJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9pc0QRh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2hRRWYJKC2OgUTczWLcM4Cu6uVK2A3Bp7WXnQxkC11Q=;
	b=gXqIpqjJv7I70gqCy6B4jX5lCYYEWEzb2UUv8sCzxPhMRCRAEPjOVbi4Pwi0fgzvJ1hBui
	snd36VZCj5TdvKHX8e5ltLpZ0AxYdg8D67/Xgob6VkyA0D+AxBMVUDsubfxmRMwPX5NquA
	6CtInPI3J9hv+hegUdh02FB4uL+jqmw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-DO-0ff3XN-SUxmezLq4tyg-1; Mon, 12 Jan 2026 09:51:52 -0500
X-MC-Unique: DO-0ff3XN-SUxmezLq4tyg-1
X-Mimecast-MFC-AGG-ID: DO-0ff3XN-SUxmezLq4tyg_1768229511
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b870870f1aeso123662066b.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229511; x=1768834311; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2hRRWYJKC2OgUTczWLcM4Cu6uVK2A3Bp7WXnQxkC11Q=;
        b=g9pc0QRhv2Z2rEdmaX7ydfRThxlQvfWpWEGtVhtUYXPcUtY3qe2le3k9/9/SmBSnPM
         Udv3BGVtQSl29xM/J50xU0JTzpI+cGAuHXD2YR5HPplG42QNL48+3efBUPu2MFJ6ps+O
         qZdpIBGNFpA5tt4jf5mdDNupxY2cKOp43cCzGPXv4olWGKhuQC1vhnhEktnIhi57dUw+
         BZfKvv4zJVHsu/A3Rn47/FbMdRcBMe50EG1nt4DquK4Yw+sT4xqM3+jYuNw0pVW/Rr3r
         i0XYPe07Y0LyWzBY2ssVJ5+H1I32uZsIr/e1bCLzX5jaCmjfMM3HTQxo2Hrz556vkfmr
         YefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229511; x=1768834311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2hRRWYJKC2OgUTczWLcM4Cu6uVK2A3Bp7WXnQxkC11Q=;
        b=PueMGblMFhD5kMF6IbFp2tGcvBfNFGWt8XBXSdc8Z2o3zOQg6Boa+n1MOM69YD2SxL
         BZrerIKmYZDJMe7O5u14ca5NGqzRzAlgR1ozvsrow7q6hL3YexWoG0F3HragM5QuA8PQ
         vzCSstUhVWsqQmcBTfc4dqgqqUn0xtUGn/KCj+Kve3qCQfBxBEJM7kuYiDOzeJllmUd0
         wHOjmlEha0TrGQ6/JyjLCK7kBFYqye3IehyjdKSKThb69DND+1Wk53vngL8+jP1/MiJP
         jNJGRaYExwK4zubjILDoDyLf+12PJ+5TdIeOs/EYgT9NxbTWRnxf6NTpTaGtCjnOv0G6
         orJA==
X-Forwarded-Encrypted: i=1; AJvYcCWGrHKf7RtStbY66op8brF5hSE/NZcCEm8of55E0DsPiNr4vB8RQskptbQuSQkqj7bxyFPzmg1C/pw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr62X6bP+f0Tbh3WZWBOv2CgN9+QKnCE6E3DXyLXpLcbUHDz6c
	A6U1V0q4RGAZe2IhqAZEJpVuK4mESvLRV9tyoq1DgmzplWGMsOXoXyPHyr/Mq/fKbrIRKD4xbLD
	KA18hS6emgZBNiexP4C3O2qWKENoEsyqN7KJmVsBvIvafLZkYhSB+tN3Ohelc
X-Gm-Gg: AY/fxX6bGnROPoyPLGtU32lncqXwecWDdEwFp+VcSbpriT6T3ygqS8jMZI5B9/jbCNI
	zXzZxaxnJzhRinM9/JyqlVAKtsvhGZ1ZMUiF3XF7X+XVnTlxCYK+RIhzwGNN08sV1eyEcLkGcJH
	PyfW3xaNxCkH+B/F04d7FkrhcfemdEoC7sOXJZx84JvkerEOe9IB5ct/lUt0WTtJLmXHJ30eyYz
	56QvF2SUhwAXkddMnbtLifsLnuejf5hBGy/bdMGCFAlxLHDyOaTVX90452XIqyFaEIDmcy/jDAQ
	TLk+ST7HzF/WIkMGMIZlOC+f/DgT1HlMWOcWQKkgP50J9SkzqN3pl5k0tWUgaLahMaIrst7zD+I
	=
X-Received: by 2002:a17:907:c04:b0:b87:191f:4fab with SMTP id a640c23a62f3a-b87191f52a1mr368288766b.26.1768229511324;
        Mon, 12 Jan 2026 06:51:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGBJU3+0OUhT73HxEYbdA8zvcwaYMtAwM44w7eMExzMrFyUpX/1W3ti3CNeNrDDtWZWpx+S8g==
X-Received: by 2002:a17:907:c04:b0:b87:191f:4fab with SMTP id a640c23a62f3a-b87191f52a1mr368286366b.26.1768229510855;
        Mon, 12 Jan 2026 06:51:50 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b870813a9efsm505866766b.38.2026.01.12.06.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:51:50 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:51:49 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 17/22] xfs: add fs-verity ioctls
Message-ID: <j2sexom3szsvxqwtlzhk7hywzjp3sd3du4sycr6aglv73otodn@ydtl3rqh62xi>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

[djwong: remove unnecessary casting]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 59eaad7743..d343af6aa0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -44,6 +44,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1419,6 +1420,21 @@
 	case XFS_IOC_COMMIT_RANGE:
 		return xfs_ioc_commit_range(filp, arg);
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, arg);
+
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, arg);
+
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}

-- 
- Andrey

