Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941772E06EA
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946971; cv=none; b=lUS/ESpvN5Ji84O1G8fH8xjAWzG9mNU04C79UYEDZS6FvhF8S/lnPPjsQNMHSXCcn/VntdJI5dsNE2jXNMOPZSpOAIQuMWtmVPA+WX5YRQrmrHEIB/ydMoqnf1YLcu+7EmNiAMJf4U/MDmh0b4HxoTkTmeu/7EUVn0wwmf7xEzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946971; c=relaxed/simple;
	bh=bjmCQju9hFpv6PameSZ4+sJuOILpW+FNz7yOClEk/Ls=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOD9mJ/eU1Ih1aY88qs3iHOxpKvtg+1+yHZYkeeeL7Gtc/hxAIrPTWIFeXl6/DAzqi8caV3T5dkIYG3ptWoi8x7gHAes+gp7WnB76GcF9B63ibi8wQPVsICExf8FMwGF749uPELOOLJQsSahkpyO53EYqcWw1ph/sh5/b10uZ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MhjiON9g; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZWrm0Hd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhjiON9g";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZWrm0Hd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r3vstktrxlALiDnoiLLjTZhUvoxu7dGqUcOK7OIAecM=;
	b=MhjiON9ggBVJxJhhUSKyYc1O5OXCw+K7nlMEAJJC/kS7RCT4HIDnF+cS1vEPN4BSaNWojW
	BYHIoC+8Uvrt0WQFVypKwX6j38+T00O8rC91oIiEKYl6UBF5n4QsDDUrVNtO2Zqz+WNOH2
	bV96dBNN0MJi5KspVggedQDtYHoSwow=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-D4ThHiVaM1-sU_6hicTgrg-1; Fri, 05 Dec 2025 10:02:45 -0500
X-MC-Unique: D4ThHiVaM1-sU_6hicTgrg-1
X-Mimecast-MFC-AGG-ID: D4ThHiVaM1-sU_6hicTgrg_1764946964
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b30184be7so1054655f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946964; x=1765551764; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r3vstktrxlALiDnoiLLjTZhUvoxu7dGqUcOK7OIAecM=;
        b=aZWrm0Hdnjfz8V6IA1ZElYCX124jHNhy9DumaGNTTmMRzZt5HhIpmsiOdG3ANSYZzv
         Qm8iMFOrM81REI+ULNWqzjm7Irf5uMC+vxkJMh6d6V7vOzkIWgLv5AuiQjIrEPZiBm9M
         EmvehryN9ce9C92scUNU4oOvxr5BER9e2ZsGKSAL9LuaCe2a4o5ZjmXRwE7BgZ/F8E0B
         25klZQ0/1aHJVWX9HoWDjORP4aRHe6HzT30tmwhw/db3zLEy3NBG+pF9So9A43Mv+N8Q
         p1UAMBYd23Qfb90Kb4fgE6bjLe4Hm6SdimTVYkFOBCyZdDU3ONZVwXFZdl6yEzTiRbvL
         zUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946964; x=1765551764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r3vstktrxlALiDnoiLLjTZhUvoxu7dGqUcOK7OIAecM=;
        b=ExCgfWCBo2SQ2gsUVw2XytB9/YYFbwc6Rh8jhw4pZ1a2ZhS5+p/n4kDx+ZxO1fn8B7
         9bFHUS+yM4bI3vku8fY8VNYtlWkVcF2NpfWXLJW2yOp9pqeLnDCJt1gIo6EmVz/VsVA5
         i0Hb60Z46GI3huYYU/Wo7Nz5PbMG9iCsNfDxezJAe0MfnFuom0fNJgx5Ee7wz7VS9WBu
         FepQI4sqd7cn+plZgsowThdm/HdjS14ETw/OKIYEBbP0JxbHFAXu5rn9Ai0LrfFfOPJG
         IuCpmUnFIsHqGOUcDCoNNZK5CWp4NPY22TvpDJAZJF625UmwiYO9qmZ9/gzhsLpKJfPT
         xgMQ==
X-Gm-Message-State: AOJu0YyLtPeo2zO80sYfjJRWx/OM7+URLMjZpNe6DY7JmtNmAp25+AmJ
	ucZrz3P+4oL9JciOQnREdWHESpasQBFoPPQoHq/0gZ3JSzZnsvXCOPvBAC+0m4hgRDJWEoLdrS8
	Ta1UmZ9MjeUw3mo7thJYOj4klbIi0E3GGnU0uWVQFxH8Y89JWc7fXyVTW8M2SMATePGvcT0vMt9
	jape5bDsrlU8FS5aTxoC9q0x0Mw0CtCpo3frNYU83Z7OTj
X-Gm-Gg: ASbGnctxM641AomfdZfOY1yfxx/buirFL4Bj4tb3egcp/3ql+Gv/3TkajML9p+iaJiI
	nXYt96NxGSfGHuu9xlWZYILZfMQQ7JuEoKwT6JgFTVZEoVMG/cj+eeqZ7/QCa1jOHbtC/ogDXvL
	1v6cLe1UqmxWkZyzfTZBqqsGJ+u3OTeKuHxwIq5T8ELmLgkx0uVAw8KqTeSj++0o4yVRjDKigu5
	vV1U3jYQCeL/OGRfZVQc39QGJ6Bbgy4JYmwk8cm6fSTkLMvKomcGPxAVWQfjToolS7lBdFPdVF7
	FTOl3pDEc7oplEVoZ6ycRYKlQS3fKg1sTk+ae6BbdmbGqCEQlKILKBDk3F9t3bEd5cXTbQNlxYM
	=
X-Received: by 2002:a05:6000:144c:b0:42b:30f9:79b6 with SMTP id ffacd0b85a97d-42f731ee8e3mr11065990f8f.58.1764946964001;
        Fri, 05 Dec 2025 07:02:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHW3lzZMNTCk5sKS0Tw9WYyJPXXGJnmPR+Kphr3upOS99l4CibedmkpeIhsvKOT1gsjbOmX3A==
X-Received: by 2002:a05:6000:144c:b0:42b:30f9:79b6 with SMTP id ffacd0b85a97d-42f731ee8e3mr11065915f8f.58.1764946963291;
        Fri, 05 Dec 2025 07:02:43 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee50sm9269869f8f.14.2025.12.05.07.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:43 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:42 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 14/33] xfs: remove the xlog_op_header_t typedef
Message-ID: <ck7ooq24lxhdxgorjp2apcg524mmoi3uqltnqxhnameu6agfvs@zrbr2od3erpu>
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

Source kernel commit: eff8668607888988cad7b31528ff08d8883c5d7e

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 0d637c276d..367dfdece9 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -141,14 +141,13 @@
 #define XLOG_END_TRANS		0x10	/* End a continued transaction */
 #define XLOG_UNMOUNT_TRANS	0x20	/* Unmount a filesystem transaction */
 
-
-typedef struct xlog_op_header {
+struct xlog_op_header {
 	__be32	   oh_tid;	/* transaction id of operation	:  4 b */
 	__be32	   oh_len;	/* bytes in data region		:  4 b */
 	__u8	   oh_clientid;	/* who sent me this		:  1 b */
 	__u8	   oh_flags;	/*				:  1 b */
 	__u16	   oh_res2;	/* 32 bit align			:  2 b */
-} xlog_op_header_t;
+};
 
 /* valid values for h_fmt */
 #define XLOG_FMT_UNKNOWN  0

-- 
- Andrey

