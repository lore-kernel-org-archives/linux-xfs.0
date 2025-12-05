Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FD533C19E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947029; cv=none; b=tsg2qdYO2hn5woQp0HIAfwdki96cFw2sLzUzj39WezDXZ1vssXZ9d3b25s+Ks81NGRGWLzU+cotWg8JAwVD48Q8ZnjsuMm8JKpJADf/8P0vCHCLHv/Mo3qVKTzHF1hWNivcjySNQfd+P9xmBGyyu21StWk6xZaitg1M/i+idZRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947029; c=relaxed/simple;
	bh=VhXJRf7Df6l7Q8fnveLpLO/R4S34gz+S0t4u9iQcGes=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwEy2UbPsID4spJv9v3YrNx105GG+HLc4KOLWKPf2/VjtECP5C2fKwCYnIQ5zfu2L+lHK7VZwHMs9Gaz+hbBQR8CTryssz9SVxiz2A++l+fwfc2FvLNHXAGlGYO6SskEQh/mOkjqENVWfH3bLkOtm2aail2UCAASPfyToypm9OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WWcxJp/F; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oYz+DwaC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WWcxJp/F";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oYz+DwaC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yISSbdDkt26F205oNOj/y0M02KlI/wuWqA0CK/yH6Z0=;
	b=WWcxJp/FyTDtr2IafnohmV3QuY8E5QKVM5GdmmCapthTs5/5/ycO7ySZihBzWZw7JNlDrc
	1/W8rPdFCNmISX00zAVLVur4oNlcnXOUP2Z1I7B8Y93L92HCfkrNYzIEjUGpPW0gUYPPVN
	B4uNtxaza7XrtYjZf6QI3BRdaPU5eQY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-vJoQr6pLPTmzdckapY2s0g-1; Fri, 05 Dec 2025 10:03:41 -0500
X-MC-Unique: vJoQr6pLPTmzdckapY2s0g-1
X-Mimecast-MFC-AGG-ID: vJoQr6pLPTmzdckapY2s0g_1764947020
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42e2973a812so1351519f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947019; x=1765551819; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yISSbdDkt26F205oNOj/y0M02KlI/wuWqA0CK/yH6Z0=;
        b=oYz+DwaCMpE6fr+q/CgXJcde5G1HMLVm1eNkT1pArHVCygp8lru6VsjH/JGwD4+vRI
         rYUokFMJQS3gjZLfvuQsQYtt96yagQiV0vJCjAxpzbgt/vJaul45OhvNaUr70c2QcWl1
         Znd6KNgMOnwHLMroqD4rTkF/gOPJ32ExlWQtkTFLzmMMzgviCVX+Ot6JEKXJjhzRqH1E
         kNj/OexHsHtLg6vK+k8lUzDGgVaOtr2wIVmMdznoHccPbT8l4aUBXRGlzCBHjri+Jlw3
         MZxbtORPyIzJoQDwfsuTYOFyt2amDbHAo7ub9bSkvgnGMSO4dtAt+TckY7T+fhC9WWlu
         ZbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947019; x=1765551819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yISSbdDkt26F205oNOj/y0M02KlI/wuWqA0CK/yH6Z0=;
        b=bnlInFO/7nl9Uen+SPCAcDJLCzUTNg67HrVOw6Qr24tn6k09WSpsHVwKGU3kzUCdnn
         BHhg0IDLxghA5dd8kVJg4lJJbza0aOl1tQ0+oW0kQwqvML+S5nq73AM6fNnW0zIQ1i/T
         Xc0XgUjd7c6VdO6NQT/f/gnWUbivhy7zOGSA3PLKUFwrWT3/qxksvs8/oAu/K5jQtAM5
         vFuVRdF7rNJn8LmMPtyxXM11XXcnyxMIK97StBtJdtsK0TRL23vp6WAC20CLfFjjUhZV
         pLYdInlXHP790vnOVW/9Rb2m7SQU6zW57Fb95ZX6ONVyFoHdgWoxX5d/tqq2XCVx302B
         AZ2A==
X-Gm-Message-State: AOJu0YybfZtbsRbkeIevepGM+g3oF05mcaZ7bac6f+NQnBgeQsspSPi+
	PqylxJ2cTL0DG3LX28Iwrk5T6Igd+eF+DJjlTN/jmdOX8WbA92K9JO+gg/xmmwdRmi2CFLWoFzN
	wruEypG9hZybMoU6Y5IEFGJ1Biy03DlBI+U0ybuJ13CkkBWALkC81Q+SQdU4KJkWwyO3usv7FaS
	mnf/2VleTi/6urzzq6EZsBVqCRqZgZ6OChkp12uCogR+vV
X-Gm-Gg: ASbGncv30wRneCHTbIX+NtUX//pgKnFN6pYuZxPvOOmPLKDX+ZsGOzvqcQBRKA2Sqc3
	Jf7pwwUBrpWzn/TdzQFHFOOc34WmtB8/rDZOfSWbE1VbeaWqLNi3ICsd/75KjNcPk3kVCxQaSfE
	sccNr+hbjqkbIYSAchPxrw0U6Y+WWn2XttueXl+/ZmMj2CQZ+rvn7fqs6Swj4B8SYV2nuu7ZYph
	pTIwUQNObRgTjg5MMRil+xDkoyLJggdh0wMW5+JzqGZmYyjzRz5O1OlHan8tmsuIvGEcvrp3k03
	GrJpnzAbyKwX+LNT+ND8MTqN/GhlG7ALmwqmwA7P2+7Uz85IyJOKAC7xGVDaHd89ATKxDblSgLw
	=
X-Received: by 2002:a5d:4d12:0:b0:42f:8816:ee6d with SMTP id ffacd0b85a97d-42f8822f2c0mr309060f8f.31.1764947019486;
        Fri, 05 Dec 2025 07:03:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGRrF2nqNmXg3tw1iqOuUdR0p+Fo8XEkREPwm3BtYebXSuCYyX5SEHsqEDvXO25NUWgzh7L3w==
X-Received: by 2002:a5d:4d12:0:b0:42f:8816:ee6d with SMTP id ffacd0b85a97d-42f8822f2c0mr309006f8f.31.1764947018912;
        Fri, 05 Dec 2025 07:03:38 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222506sm10083474f8f.28.2025.12.05.07.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:38 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:38 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 26/33] xfs: remove the unused xfs_dq_logformat_t typedef
Message-ID: <volgduuje6twig66slkxj635mvypyumgmitl2l43mhmz6bjn7m@rh5rwyi7jcok>
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

Source kernel commit: ae1ef3272b31e6bccd9f2014e8e8c41887a5137b

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 631af2e28c..fff3a2aaee 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -957,14 +957,14 @@
  * The first two fields must be the type and size fitting into
  * 32 bits : log_recovery code assumes that.
  */
-typedef struct xfs_dq_logformat {
+struct xfs_dq_logformat {
 	uint16_t		qlf_type;      /* dquot log item type */
 	uint16_t		qlf_size;      /* size of this item */
 	xfs_dqid_t		qlf_id;	       /* usr/grp/proj id : 32 bits */
 	int64_t			qlf_blkno;     /* blkno of dquot buffer */
 	int32_t			qlf_len;       /* len of dquot buffer */
 	uint32_t		qlf_boffset;   /* off of dquot in buffer */
-} xfs_dq_logformat_t;
+};
 
 /*
  * log format struct for QUOTAOFF records.

-- 
- Andrey

