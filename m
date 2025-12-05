Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95132D0C0
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946991; cv=none; b=WzA1pBQRN0rTnOHnebK9Zw8KX7JAB0IPrf7uxsIYnbxtlZ4x8ybFkrCLtJ0q/xbHLHrzgSNpxYrLPkXDRZ7cnmCMqhYUt1ssoQa5/eYhP87pGSnYqTRjudnPPGPw58Gf1cmztTr8+rEjw0uAcYx2sd+Z7tPbBn8UmGximW6K3Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946991; c=relaxed/simple;
	bh=R9ufTgffLwr5dgM2bkrN6oW6a6Ab3ndjFlMjc7rf6LI=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a33l1lZhtJdSob/nXZpRvxh7AamLT+re/+TKQAgWDZQwRmsOmKBQSVwJnP9GGTUX3zK9iO3C8ssmZkZs9t5Cq+Uvy0gMNTv6xYSrSomIscF9XHupIG4PISW8rpBn8Oy5wKR3V6Xse1JAxyDxhKRB57/2RK5lnLBMWz4B00BFQos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQF5hRj8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kEJBb7Gf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQF5hRj8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kEJBb7Gf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=71WUXu42cHi1As9ucxBB+At21gIBVahH9X9tB07JqNk=;
	b=JQF5hRj85RyCOrvQIUX7URnTtpIN4VO9ZT71AIt5FdEhW7mND9ezVg00y/xxLLi52H412f
	AnK15GbzOF6dcGM/hni/5LfKnSFVmw8SNycTOiYQxAg8I4vhdNxNFPfY7oQNYFzDwWMsOv
	tdMZ15Rszvqe2snuA7rmf4/Kit+NMPI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-x0e7l5IlPvWXwZSnAaq7Cg-1; Fri, 05 Dec 2025 10:03:04 -0500
X-MC-Unique: x0e7l5IlPvWXwZSnAaq7Cg-1
X-Mimecast-MFC-AGG-ID: x0e7l5IlPvWXwZSnAaq7Cg_1764946983
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b2b9c7ab6so1079736f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946983; x=1765551783; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=71WUXu42cHi1As9ucxBB+At21gIBVahH9X9tB07JqNk=;
        b=kEJBb7Gf2dk5q4rG1hgdJzFiDSVhTXH7eBuIFQ7FZ4inwQcuc9l2IOT6piQpnXR6eV
         RSVJWTmzjLJaB+l4OX6IbbWtJ2TZgUw33GTsPlZ4fa3nmFMEVOnuqPv96TLm4rhPjBCa
         hSKswmc8PwOWMO7tIqQkASRnPBCDHyxYKKEzr5EocobItt19681qjcdoekj7Mv6XGiCy
         mVlw5CDXPC8QExvrsyLGNZAE3OT4TUmpQyZMunkqMlSlPK38KCVmC1y2nDHqGwtY0KhZ
         3nKiRhQi5zD/6byoWGWfqFPa7sATVE0MgBPEIYLmFF5rObyWYloT5SAL32GCF3i8UyFx
         biuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946983; x=1765551783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=71WUXu42cHi1As9ucxBB+At21gIBVahH9X9tB07JqNk=;
        b=naTbhulALRyyhQ1i6r6eny0h1l/IKCm/qStz3pgmGeClWDEpX4vll5v/+k6r1bSZUM
         olnTd6iZadj6tPuaLN8rvWmbZQBVUQ7Ak1//T243Q8h2VpMP8RStMMCfWhBW2fbEmt4F
         uLdDTJ40tUZnqY8gZlILlRk26cGDWrgHGU0l6SNh37EOFFXQ27FLmrhu8bQewx0yFV28
         iH0eIzebPVSnhKTbQu/QGXFzY0yDd1VmNU8IXXVMcX9rsyGcXIcH1xB/O7GZYD3/GMoo
         fjKo16BXacSSy2Y/F1kkD4GeSF/rRPOyNc2dhmU8Gffpo4Fprb5dr/oUsfGssRaAnNUn
         wGig==
X-Gm-Message-State: AOJu0YxLPIw1IyZn99L2nBEb13qQU+vB17z/pm7VNveveaN0qV0nIIFj
	A3OTD+jQmlIzlKj9qD0dPAu/xpdRlEK5USEH91oobegOjieBFTZHwP2oQLFOPkoslN5hz3W5uQa
	fIDH0Y++aqhk0sBMjtpcQdeacdjxiJHOm5GHZLwGAdcmHX2KmKcOYQagl0zab3BKmeob9ik/EwJ
	ND/lgFLMJBMuAUtagCxFFZkS257CBMgfeDXdiQqWBmCo1a
X-Gm-Gg: ASbGncu5Xbn96ZamYtDeRSQjnbsVLP7hxWbIFI0KFTe6XRmCya1CWERkHafWrjaT6By
	bktN2OEkGbUH+cm38E2EydEl0fugWSNantEB3iM38D2i+L1dVd1XbJrK+gtAtVOHfz/semMjSRM
	PiLXIjcn64gQx3U7ulWR9VhxuCvPpPzzxzz+i6RXtXvH5sEXzOK/V07WuB7RRq9BT2ijLrDAt76
	HS+lcUm9V3Ze4EGF8Q7M/1dv1brfzt8eR7C0KTiUlzg5Y50JGRmYl8u49v3qAnjnq7qFu6ngxp6
	Wh0yjuZdTmfJxSHXNPqZcLp7JoLPWt8el3exOTw00QujcfVbN3fMmat+f2os93hbNBmiO8P0J5U
	=
X-Received: by 2002:a05:6000:2507:b0:42b:3e0a:64af with SMTP id ffacd0b85a97d-42f7317205bmr10730529f8f.11.1764946982839;
        Fri, 05 Dec 2025 07:03:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1z7uwZGNcjbdTIWD5BT7Enu2lKDyIEdJDkWzZmPbHu9pAaGxcvKtuQ2kUmmK3DVdWRCg1tQ==
X-Received: by 2002:a05:6000:2507:b0:42b:3e0a:64af with SMTP id ffacd0b85a97d-42f7317205bmr10730472f8f.11.1764946982283;
        Fri, 05 Dec 2025 07:03:02 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d2231dfsm9392082f8f.26.2025.12.05.07.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:02 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:01 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 18/33] xfs: remove the xfs_extent64_t typedef
Message-ID: <6thj4xgt4maavng6trlz4ykdmnpbwhr7iiq73mn5otm5rsoytw@gn6x4c65fce3>
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

Source kernel commit: 72628b6f459ea4fed3003db8161b52ee746442d0

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index f11ba20a16..2b270912e5 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -622,11 +622,11 @@
 	uint32_t	ext_len;
 } __attribute__((packed));
 
-typedef struct xfs_extent_64 {
+struct xfs_extent_64 {
 	uint64_t	ext_start;
 	uint32_t	ext_len;
 	uint32_t	ext_pad;
-} xfs_extent_64_t;
+};
 
 /*
  * This is the structure used to lay out an efi log item in the
@@ -670,7 +670,7 @@
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent_64	efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
 static inline size_t
@@ -723,7 +723,7 @@
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent_64	efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
 static inline size_t

-- 
- Andrey

