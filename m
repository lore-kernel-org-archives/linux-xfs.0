Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C865341AD8
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947062; cv=none; b=vDWivZTMudwQ/9vPniw3jfJ6tJV1DJmeGE3OXqotUxx0DE2QxZB37fJ93WkYubzqKvRJ5noBhEfAdbYX2/4PY4Ma5ABqiXQOMwN7OwblxWHpVs/8UESDvm7+y1fqFf4+YKiYDdr/whWZPDWDtCXox0R+g0/J/HD/5Sju7aFAxQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947062; c=relaxed/simple;
	bh=GRyjWHKvoqjBJegmQ704czDiVEwuaXsq0nP/xYbBxDo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7tlEWWjMOtnO35b8ISFCe7wxXtyPr/pqUcChTAE89/ICEdiBhJBUd+f4danT1XVP79j3j0rlRsvtAN6HHN18DsYqsdeSkuhuffJuhLjEuJHBj5HXS3KhD9dnDBLfMyA4RQX7RlaIkL8nU1i20O5AFSat5/Dkb/rw+AqTFZ/gVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKeo9ndR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P6ev0bzQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKeo9ndR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P6ev0bzQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YC8qwZZ6nBtqCRZsypiTsrQmcwPySo3D2yCxPDASers=;
	b=UKeo9ndRbI1hdBdwwy38qVXYZ74lknbH/v177KWVKxC1swZyLNleodhx68xzEeSxtMYrse
	gPo+zwsiXHnlAwAKRGzhNDWzWaqC7LhIARE0VOuX3CyIKMCzyjPz5Kru3OLRJcnS0snNFx
	MoIr/sBe55/E1icpsQrMXc/93jZPpQM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-kYLAJVvkOlSYldXOC7xfhw-1; Fri, 05 Dec 2025 10:04:15 -0500
X-MC-Unique: kYLAJVvkOlSYldXOC7xfhw-1
X-Mimecast-MFC-AGG-ID: kYLAJVvkOlSYldXOC7xfhw_1764947054
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59434b284f8so1186733e87.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947054; x=1765551854; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YC8qwZZ6nBtqCRZsypiTsrQmcwPySo3D2yCxPDASers=;
        b=P6ev0bzQU67trWjjWOvFsDHR1LQf0fLZzJACnz211zm4DjCpQ1HRraMM/9NOMMePvP
         gOFSdN5p7LDVaG4RknIgezBfImfUcIWMmO0OscVbyBgS6R9AMKJW0wZTx7fZZIvgcYgo
         lOS6rYMWKH2ddMs6KcURgBlkvR2io03DDwG0de997eREW9dEMhA0093cN8rIaxreVWN0
         b0mbzSx+wS1JdbbPoCx0mvGd7Ph0/7oHT5tlLud3fRQ5lZfQa/7adzm7BjSNE1XgUz3n
         ZRsfVN6ftao9lTmolZa3LyGPUwjB0IYsrATPrnvRH9U/gPmZNl0F7cZfK5rSnLGjfuvX
         8Zbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947054; x=1765551854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YC8qwZZ6nBtqCRZsypiTsrQmcwPySo3D2yCxPDASers=;
        b=xNz9IkR0QeEnLBVduScTLAuAtwR86KpuS0TapOu7IYo+BotyCCfK9l8Y5ngzfG/p9j
         uOA7kAt5ZoiVR/qWlSjIoEU/ERcgAafvx0qR0VjzDNfZTvW0E+fykcTUUXpzaNI1ms+5
         qdsMybjWkm1GFJNipeinMxjnu8ZY598UGTUUkoZWSUrlBZq02C/WxnBNES8l5hwzx9AR
         vUsl5nCUD8hzeN7Ggu6EYVbD0iN2dmfrXbsw0AZkbU5v+SUt6I/h6DfVOY/HtcwpiSnF
         MaPzEmGhMnGywPgmEZ3TKFMaUuwLNv6lMHbuUGXxM9TLipV847yivOXzfR+40bGyCHFG
         QPoA==
X-Gm-Message-State: AOJu0YwZ1/0nhMupukcJreGc6bPUqAfQ74viAxvuStw3KU5tBjjAUyrd
	rD2trrdeY3qSRUx3M5rXj3qoolx7KpNclkr8zBYSC1a95NR1IRlnGvuNCdT+I1pJpEX2RV4keDx
	NRcfKmbVmP4Nsa8D5R24NfxEXfEozNGDc+Hwr2rmTUrOgWndeIT+lyi03T9ioL1jzH/gJqRSiaj
	GDYzSapxwP6tpyhzi9fDfQDmJqZM8PeIVnjTfkIYRnp0ur
X-Gm-Gg: ASbGncvPDtHt1kZ+SeY2el8+VSL+QS93sD1YLqNRnppJzVFnrOXaI3eR90U068NJllH
	tFls8tkOFsPkY6d3h1UtUNGNsoGg/f92To0MX+E+mPGPfgty5fUO2tY6S530tnUvg5NMJm2rYlK
	441ZJrvZ5i3wClr+q3Vk4b8CzezGWRZY6VRAWjNsKrwm9BWwt2tKe/c9UK5W/rn7PXahHQ+ULd2
	lc//QS4OqweR0dwZlRZQjiY6Ft4SjZjRv5L3UOfzOqR1T2OWIcv7anlAeTvwE7PCMky1ENLWp6V
	wLuaE4XFEQqxtpXzt9Np90xw0HCX229Iz+7nqCFaId7xrqDWHiK6/Nme0C7+hRIZx4r4Ixx5b0s
	=
X-Received: by 2002:ac2:4f0e:0:b0:592:f818:9bde with SMTP id 2adb3069b0e04-597d66828eemr2515984e87.1.1764947054031;
        Fri, 05 Dec 2025 07:04:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2qiLzQQjzAQdyZqRCRte/MB76KbE7gqBKaQgMHmBkzsrp/KGQkYDTN3BrNNqLXaXqND4Xdw==
X-Received: by 2002:ac2:4f0e:0:b0:592:f818:9bde with SMTP id 2adb3069b0e04-597d66828eemr2515959e87.1.1764947053483;
        Fri, 05 Dec 2025 07:04:13 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-597d7b2f2absm1560933e87.44.2025.12.05.07.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:04:13 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:04:11 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 30/33] xfs: move the XLOG_REG_ constants out of
 xfs_log_format.h
Message-ID: <j2q5a5c4qsurl73y6d5bmc75nckkhbqmeujihbzjhtq4l2wp2f@at43ao4gpxwh>
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

