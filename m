Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFA9166F06
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 16:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727454052; cv=none; b=KDTg0kMLuXgtz2UeqjQKbRD6o7WdkNtvMcJPkkOLe11BlRbEEvne6V8Zs9V2Hykhsi/9vYZbnyyhZPZVJi52yIihZqWFfFXTW8K4RgaH6R+WE2eXd9f2Le7Jcc20q2CZ2Nq0+Tiv1d2GEUYEz3o4nipRgK+RQB53amvBz7A8GMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727454052; c=relaxed/simple;
	bh=8bbbNVFH8fseR42WXFZpKxt45Ex12IoB7jbtz6NdCIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfM7Sgl5ZXRQiAF4ES+YdWBcLfzJZsmCeYlOWBQD1loGDsAVkBtezVBM6M7xuNHzetHIYmGik7X9AKJkL6t8EDzG/erdB/F01DYuupoNYNo5pFSYi5GacYH+UDLIYR1sBNrWpxFnesJjGlmD75gYr9xz8CDrdIl3QHkQBPj/TI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bjc12AAr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjc12AAr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727454049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bJuvEJhIMeAQ+Uqh+fckDa2jBS95bRVN69kAwmnaUo=;
	b=bjc12AArInQPTi5Y1e6KO/dpJV3hmjWaGCmlo24qBaC/pmJeE+1ZEgyOsIU9udPYdYCl27
	Kf/6MAcQa8LPOYOveV+Xyb1GcjkvTjZYxhE3NSBxM1/kyKDu21RZsKufdIRCysPZIl2CtI
	qZCTPF9hJ1NxdQJbcEtlYGi3Ti4shwg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-AzCQ_2W3PYe5SlIMqxnhzg-1; Fri, 27 Sep 2024 12:20:48 -0400
X-MC-Unique: AzCQ_2W3PYe5SlIMqxnhzg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cb050acc3so12583065e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 09:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727454046; x=1728058846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bJuvEJhIMeAQ+Uqh+fckDa2jBS95bRVN69kAwmnaUo=;
        b=b4BCVNr5LT7L0QeMuMHIJJgkb1zih9Bx+57jOfscNXPkmdaGOqIs/v53VYWDzEEw6W
         7MbV6sI4QEDlvWEgKeIRLgnQb4zdOqbd8XOxrxMZalfzja7jomLoxYQ2fL5n9+1rmrcv
         3E0YrHCx/xnLPU+woXMjRwYIZrcJdS/LjrRBRgRD/G4jAEbWRGWOCyain9De9VVU5ul3
         hycI+jhkOzSWM9ZIemSxUneA+v00aaKmrLuJMQAWpP5+TT2F9NjxLj+UCyRIng+xYEYY
         VcFw+r0oNjQ5HlqRAcZCXjlPxPdBBOMmgIeYLuz9Ip0JmK+9eLOHaH5zxEOR5LPVFqwZ
         8m3w==
X-Gm-Message-State: AOJu0YxmOW3rDR9SLu1y+va2MZLj5nGLRBaa96EvQGHdcx1DqUEvg6n4
	5WwVGydbYJb/8R7nERfzTqfaWpS2d2qzQQm3aoJpPrdLTJQXuc/dr5qIWnaVfvwk24BT9CHGQN8
	FimG5EfvhpZ6Nj9Eh4Yp6faPS9h8rIkG8Ywp0yXowymMeQvVc02NiT1afG/VtmXf6EmN3OZKRYh
	oLgolXbbb/VHJ6Cm2tBslzU7GLgto7l8k8WzDp9Pxr
X-Received: by 2002:a05:600c:4fd3:b0:42c:bd5a:9471 with SMTP id 5b1f17b1804b1-42f5220856cmr48063585e9.16.1727454046029;
        Fri, 27 Sep 2024 09:20:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ5jEcxR74seojx+mYMlRtD5kykP0zNTDlBXbAnwFjRwF/j1d3O1BLfTSiWhOoiKcc6i5UIQ==
X-Received: by 2002:a05:600c:4fd3:b0:42c:bd5a:9471 with SMTP id 5b1f17b1804b1-42f5220856cmr48063395e9.16.1727454045616;
        Fri, 27 Sep 2024 09:20:45 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f57e2fe7dsm30650475e9.46.2024.09.27.09.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 09:20:45 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 1/2] xfsprogs: fix permissions on files installed by libtoolize
Date: Fri, 27 Sep 2024 18:20:39 +0200
Message-ID: <20240927162040.247308-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <20240927162040.247308-1-aalbersh@redhat.com>
References: <20240927162040.247308-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Libtoolize installs some set of AUX files from its system package.
Not all distributions have the same permissions set on these files.
For example, read-only libtoolize system package will copy those
files without write permissions. This causes build to fail as next
line copies ./include/install-sh over ./install-sh which is not
writable.

Fix this by setting permission explicitly on files copied by
libtoolize.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 4e768526c6fe..11cace1112e6 100644
--- a/Makefile
+++ b/Makefile
@@ -109,6 +109,8 @@ endif
 
 configure: configure.ac
 	libtoolize -c -i -f
+	chmod 755 config.guess config.sub install-sh
+	chmod 644 ltmain.sh m4/{libtool,ltoptions,ltsugar,ltversion,lt~obsolete}.m4
 	cp include/install-sh .
 	aclocal -I m4
 	autoconf
-- 
2.44.1

