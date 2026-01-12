Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E3215055
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229472; cv=none; b=Ce4oAnEHdY5X1WhGDX5KRJBPowCqo4i3XnU0+PPJsiotLyvs0vL7y4CVrttP3G8gjPAhd9UTsnAqEvX4VYGv0t74+3x9bJ986s2DD8bwN3KlfskpJ9y614qNV51ZSQpnKHZx2Y9rDs5KTXMkwCjAi0EguZR6SAfpkkRgOFjPwbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229472; c=relaxed/simple;
	bh=juaXjaWCdJhgUxdxDnPo/I5g1bovOuzvfAho0L4f/bA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5zFgvMZm7LDUSucasFEhLzHiHxoEBCpAOi4vBiDPDgGjmT827WmNCsdqzsqEeFe1XJKvXAYGxy6UnmrVn3Y7pKsQcleagdCbarM7IrD/Uu+giY7fEe2S0mBDx1BOm3X9xpdLCf7wIGDST9wvMz61Q00ISAolkr1LbWxg/4r/TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=awl5aboW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zw5/yZqJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="awl5aboW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zw5/yZqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R3lmcg/cu75BB25Wlh2Ox4/Pwg0aDpFEC5S3Bq4BJXs=;
	b=awl5aboWPUmzUzugYKde68oHqYgYywvkOb20Yg/QoV8U+ZV2KHhCIolFpqpu4fD9y9ho20
	2DLImPAN6keugomibIFbqi1soG7cZmyAeHfH3DWFguQMahnngrPFvvnnjWFECKX/p59klc
	rOVLC+6Qsu4OH/5Cn4tsCXC7fZXVsFg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-u3wCGyRIM-ORrSqIdQbbDA-1; Mon, 12 Jan 2026 09:51:06 -0500
X-MC-Unique: u3wCGyRIM-ORrSqIdQbbDA-1
X-Mimecast-MFC-AGG-ID: u3wCGyRIM-ORrSqIdQbbDA_1768229465
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b831e10ba03so949256766b.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229465; x=1768834265; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R3lmcg/cu75BB25Wlh2Ox4/Pwg0aDpFEC5S3Bq4BJXs=;
        b=Zw5/yZqJV6SWH00XOaeO9z7owSXnVvfeKug3ZcsVFdocEo6uaiP8ZrS6J5XDVLG3iH
         yTQ2X4fpP2mcj97MR+Z6MnbQyKnuEpw94NK1rny3PGF57qJig+yc9CI3SXoig+o2wekp
         lW3YesRxdz40OLJP6iypgOZYEnv+NEsk3vP+gg5XKe3usE9eP1l78Ydrqehq75HASuot
         Djf4KXh/fb70FVTH6+4VJiJsIY9lsBIQJu4DvH9MFVddkzS8SEfITcPLFhSG1uYxHjWm
         H60S2W81NMuF4/x5ukCqD7SNUligxHEWqNxuh7dkR4jNzKq0VVU7C26sCo3Zw5X0SQje
         +ZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229465; x=1768834265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R3lmcg/cu75BB25Wlh2Ox4/Pwg0aDpFEC5S3Bq4BJXs=;
        b=tItW6p/V4SbBeG8Q0Oqhv7UTHhOJS4f8CtPUSSnUSkE4mI6rsHn74IJLU44LuBrF4G
         HDKwKOgIZEDM6uUmxvm1421/lpu/yKb7LGXpoANAB88UfH0How1HWf/aWA8lGjYbrQpr
         QEZMAveKhTHz3qMo0M0+SraOu54be4dqdXbYSrgOdJm/Zes2/dyfGxzR8jd+kLdE+H0X
         YbEtTLEbFSj/+NLxLt45HGfNHA7PjuNcv8TIVlVDZkSUs+Jnx64tj00i1YwlRM/718rc
         6WgTK/ooovi4Y+89Fq19rLcEFtbnro9o8etn0FiPIIGh6S2AN1e3LwfSYjudtFDuU4kw
         xtvA==
X-Forwarded-Encrypted: i=1; AJvYcCWovDaz5aMuQtXQvTusmHTimxblO2Nq40X5xanKHTmn01pX4egUQDWVDEFij3u1zks9D9zhIFqt7rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgqPo91ZnhRBOqFA6xT1DmpG/nhyg0QVRay1L8g45iBMWbdxr0
	do3/D9+fkkWe2v8+R/GyKrxzWlcTLoreDyQFhZgjsGxOHHidiM8TbxdpjDXrop2LJpB9Wga+ZKH
	8c9c0QMUzRrfABTfQ+kbZ3+EnE0Hl1DsQv+5uJx1sKzVMoXEAC5wDpJ46wHT9
X-Gm-Gg: AY/fxX4p7KyLA23ouQ8d0Kmi+O5oTjqjSNOVGv/mc0V+5EdCjx/s+lqcBP6stl4q8wd
	tF7mFXcvUI9PdIAlFoMJxVz3x3fh1+NRYDI1hUB+ghW4m0y0LR2X3zeC3/4C31eSWy9sIu+mUAV
	tfNciBBqVMQAradIx1LkOiJHupK0YoymPuj2armVDflYRARv/AOcwwsDNP6Cq5sgOso/9iiaxZp
	v53WifGTxhi5PXuVU8JIl9Q/3C3NpII3EFDXbJ6Q5U4tUvSqQ5xAXRczyw3YGaxH1536KPlXhO3
	NWF3BWLuPGd7S/HeDxvJAtyJXPR/E7RaMk7dJ6C0An43PYjZdr97jLzzPq+1bAH7VIpfaH+ke8o
	=
X-Received: by 2002:a17:907:968b:b0:b87:15a7:85e0 with SMTP id a640c23a62f3a-b8715a78b2cmr338221166b.26.1768229465047;
        Mon, 12 Jan 2026 06:51:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IET2nU/xS7rTGGJI9aaTqCSFphZHua3LUHkxfJzBhZsDQMy1yw4maDpAej9bQDC3iRtIDmAUg==
X-Received: by 2002:a17:907:968b:b0:b87:15a7:85e0 with SMTP id a640c23a62f3a-b8715a78b2cmr338218666b.26.1768229464502;
        Mon, 12 Jan 2026 06:51:04 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b870776b642sm529509066b.21.2026.01.12.06.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:51:04 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:51:03 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 10/22] xfs: disable direct read path for fs-verity files
Message-ID: <6rsqoybslyv6cguyk4usq5k2noetozrj3k67ygv5ko5fc57lvn@zv67vcnds7ts>
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

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix braces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0c234ab449..87a96b81f0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -254,7 +254,8 @@
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -307,10 +308,18 @@
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if ((iocb->ki_flags & IOCB_DIRECT) && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared (see
+		 * generic_file_read_iter())
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);

-- 
- Andrey

