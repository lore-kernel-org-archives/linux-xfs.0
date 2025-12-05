Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229A63446AA
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947082; cv=none; b=fe9jxKmv/n5h4amh4WQFpI3Du7VuXMl7mhn37VpERtia91K+D7W0MbaLbL0VSebEIZQBXsmG3kRakZ1AH/Gqufq4NaxoW3H4u3JW6yBZFOm1BSkN0KNje9hSaDyWkWdXUmXjPvqAMO8SBkC24CFxWrZLQEtVHbA8GZLw16s0FZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947082; c=relaxed/simple;
	bh=Y3/Ez2xF2X7RvpEKSW825Mp3reyM+ed2oszdU9U7vOo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4FPc6u1zEAawrZUgVYemy+4BIS6xmGNCdvJs5lhK4rWpE3AwMOK4uczst/tea/4LRhdGqzGJ9ECOyb/EcUE79iPRwN0cwRx0KyNnoWYWCUuTXrYH1ENKa7xPPL4lYEfYllY+tnP/GLNDf2ji/YfccY8di0k7Sp97CFRrwoePfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YzkJ/719; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ugf8lfaN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YzkJ/719";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ugf8lfaN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cob4u7mtS8QUgMEpOn/0Juck29I7WqGCT0WHW0VRKsA=;
	b=YzkJ/719ysKMuY1sdy1FciN5juMTBIAAcqGT7q+LQCjw2nVC8H9YXCJl6GQSCjWlyGex0Z
	mJ9i4Jbb4u3mhkXv9SqG98+0PEDyaIXRNQ9r6ND9TlfpRDZOKwOkhjJAMezt+u8ywlHhNz
	zwcc5/5XslfpufO6odjissBNItld9wc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-tAnyHbBZPSipDY7oONlYQA-1; Fri, 05 Dec 2025 10:04:36 -0500
X-MC-Unique: tAnyHbBZPSipDY7oONlYQA-1
X-Mimecast-MFC-AGG-ID: tAnyHbBZPSipDY7oONlYQA_1764947075
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42e2e448d01so2208204f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947075; x=1765551875; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cob4u7mtS8QUgMEpOn/0Juck29I7WqGCT0WHW0VRKsA=;
        b=Ugf8lfaNF6UJV/uAVmp1ed65sYBJc2HqZK+L6PUqv9nnDkLocvN2kolzGRutyKkltO
         gvUA/B0XVRxs3/S7HQm4RI1jCd5d69I96n9ybA72scYPcEJryUt5XM4KFU2vV/TeZT5G
         FlZeVTJEI2VCcJCAYT7sO5eMaZ1SY/OXKocNA2Z6P3sopqw+/QisfX1FcsaKakXeXhcH
         cUojS3cKq9wK7RIyYTT8tGMl+5QOEx7J00WhWgAM5FoMFQVtMpxNciXs9CAi2VvXOteb
         HUkZ24WP8q003KOKyp3OEppgcQUfxWXTb2kUACXEZtDnRYBvLp0s5eDAz8X8GLbbNZQw
         4TOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947075; x=1765551875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cob4u7mtS8QUgMEpOn/0Juck29I7WqGCT0WHW0VRKsA=;
        b=Hc1w4KF4iuPcorHIqcwP9qTywBJT16dSMuQ0dTiiMwcAK6YoEIi1mdxP+Y/GTscbDY
         jeaDwZDWxQG6R6TX8VfuRtAOym8cGpcYPtpDRmZ3AHoAGM+fXI0A/BSBJ082BnM8XBcn
         +Sy4Wz4FTl8L82oBpiZpAAqFsW055flu/gmj4S+sNtkER7tAPBCN9atYM+S7+iJl7X/J
         b2jZsRPbEAxu/ClZABoLAVhYc03E6ZzCpyzu4DHrZsiFKLXw9ILCaw+aPH7e+DoZEASY
         mpuRMaOjyb4+BMM0zO1Xfp6+k6qhM3PmLIy4sss6UWVJml3rHi7u2irn3B8k0aiXK3Dl
         UEWw==
X-Gm-Message-State: AOJu0YyZP3y4Tq9AcVI81VagDz6IdTYns6Nxjk/QiKO4mMN9GayrBdS6
	q8/9gEoGTaQiIwFadZaYYrFs6V5s6nf4cILAECJKbyGCnRxRzYlrLCkRwzdNUXItf0zsydVBywk
	2ugpM8NFW32fpH86xtoyOoKIsUv8uXvlEbdxIgvIi03hxWRZwt39G38gjikCOEjuqiuuJSdh5Uc
	gEZU2tpxc/nGqChwbeIj71LCSAW6D4YMYD6FPIpqPh7AlJ
X-Gm-Gg: ASbGncvec8e6S5Q7x7qkm6Dpm2RskmL3SKqYOt/H3CldCTFHBG180EZOnT4HtTCI/t1
	+Pu3I3g4MNnEzg1dt3Vw+LBEl2pr+BzoGG4HXisCkqGzHLDUyOLJ2RXZJguOiDApr97BS5nJT7K
	wJB3vldTx+pFVzDyhkRXjZe694BJkD/eB+2mzxpZDzjEY2vwWxvk95nQDf7RaZz9DAacYBd4mWE
	0SbZK34Vcer6/LRjcnlnRhfJpgoKM3N4lTJudEfPo7N62bh8YgWRI7QpNy9fWT1AxNk5663utee
	aU4Ozo6bbdxQFFvdsKnZ7eZDZ2Lmka8bTxyGnmEWf7RPqTdl9THF4dJHK5F0zPpAJiZn7/21sAg
	=
X-Received: by 2002:a05:6000:4014:b0:42b:39d0:6377 with SMTP id ffacd0b85a97d-42f797fdf66mr6570431f8f.17.1764947074902;
        Fri, 05 Dec 2025 07:04:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQy9Yk1ElEGS6iIOT5O4/Ul9bOW8Whv6JOJ4WJ1gkcmobgeuz3nLyq7DtPkRbI5eI6oym/iQ==
X-Received: by 2002:a05:6000:4014:b0:42b:39d0:6377 with SMTP id ffacd0b85a97d-42f797fdf66mr6570378f8f.17.1764947074271;
        Fri, 05 Dec 2025 07:04:34 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee71sm9057057f8f.15.2025.12.05.07.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:04:34 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:04:33 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 33/33] xfs: prevent gc from picking the same zone twice
Message-ID: <mxn6l2o4hpyi22ulbgn7zfpe6az26wajhnbfqzz6uzdj7kzrwt@fsqqxljhnuc6>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 83bac569c762651ac6dff9a86f54ecc13d911f7d

When we are picking a zone for gc it might already be in the pipeline
which can lead to us moving the same data twice resulting in in write
amplification and a very unfortunate case where we keep on garbage
collecting the zone we just filled with migrated data stopping all
forward progress.

Fix this by introducing a count of on-going GC operations on a zone, and
skip any zone with ongoing GC when picking a new victim.

Fixes: 080d01c41 ("xfs: implement zoned garbage collection")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_rtgroup.h | 6 ++++++
 1 file changed, 6 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index d36a6ae0ab..d4fcf591e6 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -50,6 +50,12 @@
 		uint8_t			*rtg_rsum_cache;
 		struct xfs_open_zone	*rtg_open_zone;
 	};
+
+	/*
+	 * Count of outstanding GC operations for zoned XFS.  Any RTG with a
+	 * non-zero rtg_gccount will not be picked as new GC victim.
+	 */
+	atomic_t		rtg_gccount;
 };
 
 /*

-- 
- Andrey

