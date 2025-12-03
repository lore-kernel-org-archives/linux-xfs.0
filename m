Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A42326927
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788953; cv=none; b=A3dfxRHnOkmPf9BaIIp/n/L5HOgCoLS6/iR+k7YfCy2l04rsJ9QKn1ZaKMyMsuDVdiNVG8wc14XM33mtbonWRIvR5RmLcl0jOHo9RtE0OuLPzIpC0VMkWcJZ3q/iI8c2NFyAkHvSkUkXkfLcVGPVv5JIKbz6vjxV6PdEYjqo6ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788953; c=relaxed/simple;
	bh=GRyjWHKvoqjBJegmQ704czDiVEwuaXsq0nP/xYbBxDo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXlEOs78DFZdvf49dIjjalT0TeJLRw1J/8nLTy/yEWCg1BuubPiS0FEzQFIY3/xiKtYq+Gil55yQxdJHUP9PF+2Db0hhArAu2CMSZbHpv9WZWJP5k29OP9U6xCFLwkfy+8aJdZ6GXZTsTu6TiJncQ+JBm7FqPrVBp+tOa2kAURk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fJKkkEf6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=m0vuBUK+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJKkkEf6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="m0vuBUK+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YC8qwZZ6nBtqCRZsypiTsrQmcwPySo3D2yCxPDASers=;
	b=fJKkkEf6Exb1Ru1msAX+59fW4zjms8uOm5jqDAy0oFXvwQk10XY6G6AWFRpV2siBX+Fi9V
	7TIiB0IEquJgtG3CqQ2O6bQapNJWhJKuexvUS6NEH5tz/j0N/OlIFcEbjV51fQdYIDlDeC
	I4Mgv/hGSnbl+rHkCT90uAh1KhMaNfs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-sDTeMUOZOh-Z_-r0c_aIhA-1; Wed, 03 Dec 2025 14:09:09 -0500
X-MC-Unique: sDTeMUOZOh-Z_-r0c_aIhA-1
X-Mimecast-MFC-AGG-ID: sDTeMUOZOh-Z_-r0c_aIhA_1764788948
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47904cdb9bbso10625795e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788948; x=1765393748; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YC8qwZZ6nBtqCRZsypiTsrQmcwPySo3D2yCxPDASers=;
        b=m0vuBUK++cgH7l1/q6I6J4PQ7kk2VQX15wkmW7aIxPcC+lMwpa1Vl/84ZPs6J0Q0z4
         FqOENHDBg4xmf379lcIWsJngB98iZPNApf9PgimrWS1sgfcVeRxtKoU30TQ+q0ARGLEx
         aPKLvGTSZUGE9faJnZz0To/hGAYRA02ucl9Gs+X55ZkXNdbIKvj12LE4zXViFR/XJfpK
         A2Doq1Pv0jikxpqYOHy5siU7j6CXfiiFA9iEdACpSKG4j9W8DARA/4/SJ3WJHoR5IOC/
         MG2WUHXrCH/ujlIPxQlrqfStAKxf2vAMb1454sir/DH8Ho8sHLCqXCa3eMLaijhXVtpv
         dMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788948; x=1765393748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YC8qwZZ6nBtqCRZsypiTsrQmcwPySo3D2yCxPDASers=;
        b=E4JeXDV/T/a7DQ0R5kJD5N8IJahfnIfQwuffml5xxfEtwHjBBt3axVNnCDKzpIWCLn
         ZO3dbsbJbC1IgFTx7faKlFqCXwtAnSLctt8AtKH4Avj7tRup9bLjG2LtDceDBJgyb0+D
         XdPon8lCIXwHBtYVw/+wpCpsKQFWxUEUTV2XHdZhFEg/3esyijqro/oDNhCfI9smKYRO
         NQBBjIw0zEcc5hpBwfRROAOTlmrRiwPpcAaj8L5tddq9nlSL4g9uUhVdKQvOln0YLbUj
         FKDVJNPReAw9fSmSN7QH9h+e3Bb2QyCLY7CNjBXSaOnnbAr3uhV2iufEmOODLhi0oE8v
         DC1w==
X-Gm-Message-State: AOJu0Yz/+LH/FKvREPdtkO/CgORQ5fSCPEtbxCLcofYtv4xidXcQoWzm
	g5Nn7nfXoXKueH9F3l9GYW6U4q2NagRR0MWtdagiUfiVLA07k9cRAoZ/NiB9AzeP47u19YLA+xG
	xDrHUZjDfO0BvX3uRZJgxN88MNy+ikJgVYKElz+lE53MnygjvGzgQFvLcYDS2V+OOtOt7FPH9G7
	7AGGDjsfzVCFewPxAmMF0rvhRPAxWP9y4c8DzAsgiwQL4W
X-Gm-Gg: ASbGncuHbuGYNFW5a2kop2wBI0+GKAYct6ljNztWWa+9aTAc7dCpNhMd0v1tr65EAI4
	ydhCuHKVX0OvrSlb55+Yl3wJnplcuG7CcAJrfk8BFZkJxt4XKZBUkpRPIUpHRLhokzDO0JQKOUH
	abXkPYxcKEIGqAFh+b+LrIdQW0hHdudpKqosMG9PpmkU7v5JytUneZD7PvRLh/6TH/0WRl2AHim
	p+k/LesPlc4x+c7mf59Kb7cGAZljY08tuVPiJ1ZBSoS7hbbA3cOzqeA74AEM6UH6sXRlL8EtpP4
	EPbq/4m5VLceuNFG/c7HuooJT156ZL8Ozca4XGL64bSDmbNH7ubfEICbCGNLXZI1e4+PBygM8sM
	=
X-Received: by 2002:a05:600c:1ca8:b0:471:665:e688 with SMTP id 5b1f17b1804b1-4792eb50fcemr5551345e9.17.1764788947859;
        Wed, 03 Dec 2025 11:09:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJZ0WFS3ExuBxQBCbtVMfdTtSkJB2nFz2Ewg5BxU85n2Zg1XptUWcT3JirlE6vH3ZysjTI9w==
X-Received: by 2002:a05:600c:1ca8:b0:471:665:e688 with SMTP id 5b1f17b1804b1-4792eb50fcemr5550985e9.17.1764788947428;
        Wed, 03 Dec 2025 11:09:07 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1ca7880asm41346950f8f.31.2025.12.03.11.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:09:07 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:09:06 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 19/33] xfs: move the XLOG_REG_ constants out of
 xfs_log_format.h
Message-ID: <ueguawsypxhk6tq25hvy6cqkhfvpeaawbnwrtr2toa3wxaddul@tnyikrm4ue7b>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 42c21838708c20dd8ba605e4099bf6a7156c3362

These are purely in-memory values and not used at all in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 37 -------------------------------------
 1 file changed, 0 insertions(+), 37 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index fd00b77af3..6c50cb2ece 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -86,43 +86,6 @@
 	uint32_t	pad2;	/* may as well make it 64 bits */
 };
 
-/* Region types for iovec's i_type */
-#define XLOG_REG_TYPE_BFORMAT		1
-#define XLOG_REG_TYPE_BCHUNK		2
-#define XLOG_REG_TYPE_EFI_FORMAT	3
-#define XLOG_REG_TYPE_EFD_FORMAT	4
-#define XLOG_REG_TYPE_IFORMAT		5
-#define XLOG_REG_TYPE_ICORE		6
-#define XLOG_REG_TYPE_IEXT		7
-#define XLOG_REG_TYPE_IBROOT		8
-#define XLOG_REG_TYPE_ILOCAL		9
-#define XLOG_REG_TYPE_IATTR_EXT		10
-#define XLOG_REG_TYPE_IATTR_BROOT	11
-#define XLOG_REG_TYPE_IATTR_LOCAL	12
-#define XLOG_REG_TYPE_QFORMAT		13
-#define XLOG_REG_TYPE_DQUOT		14
-#define XLOG_REG_TYPE_QUOTAOFF		15
-#define XLOG_REG_TYPE_LRHEADER		16
-#define XLOG_REG_TYPE_UNMOUNT		17
-#define XLOG_REG_TYPE_COMMIT		18
-#define XLOG_REG_TYPE_TRANSHDR		19
-#define XLOG_REG_TYPE_ICREATE		20
-#define XLOG_REG_TYPE_RUI_FORMAT	21
-#define XLOG_REG_TYPE_RUD_FORMAT	22
-#define XLOG_REG_TYPE_CUI_FORMAT	23
-#define XLOG_REG_TYPE_CUD_FORMAT	24
-#define XLOG_REG_TYPE_BUI_FORMAT	25
-#define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_ATTRI_FORMAT	27
-#define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME		29
-#define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_XMI_FORMAT	31
-#define XLOG_REG_TYPE_XMD_FORMAT	32
-#define XLOG_REG_TYPE_ATTR_NEWNAME	33
-#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
-#define XLOG_REG_TYPE_MAX		34
-
 /*
  * Flags to log operation header
  *

-- 
- Andrey

