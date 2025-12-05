Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BB926E6F4
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947004; cv=none; b=KXtTGP78+UK3gxFC60wGBppvd77Mho5D09Db+TcyDgfFokB5FtdpZzJQyI30nOJ2DlIfGeXRpxhwnhxi+oJG76YI0p9M2Ey3IsObOP/2Vd/VZNTZEI915mMu9q6zburXxG2aRHgbXB2p+SnbnRVo2pE2NBGicAPtgFo/a722vs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947004; c=relaxed/simple;
	bh=SbBxxTy4F/ACxGxF8xau89ae7cYJ3jy61H0JxyKauAM=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5td1bj+lu2f3VScs/zfyN+YlLVWFedeaCMftPvBbTlSsNrAW4uNcHFBC/eymuY3yjr9HPS4sb7q4pX06PGkNaWBxzHHeteyo7O5pB0xyhB9C3cnc4jfu8pD25cj/k6rK/TyimiOMHNKZQdX8+SMxiWm9i73qiIBsVSkbvI7hxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCAl0z5M; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vom04bXX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCAl0z5M";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vom04bXX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AKvuMZ9yOjOFZvKzY6cbgWjeHeLen5VOd92doJOXrh8=;
	b=FCAl0z5MLToOYSSt9ImyCxD7Ahp4NYzcvDUwVL5E5mluoRhL6mMDIv9wI6PdDc9QgdejGz
	E30P6WJaGhjIxo4FhB93k/7mgYPajWsAZQjuvmExQBdiGd8DPsJhCLqddWhDGM8zZEznpi
	Fz5WTI9kG15hgnclvd6dljhFqaAAcMY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-kEwXWIEtN-C_XiZjk6NIow-1; Fri, 05 Dec 2025 10:03:18 -0500
X-MC-Unique: kEwXWIEtN-C_XiZjk6NIow-1
X-Mimecast-MFC-AGG-ID: kEwXWIEtN-C_XiZjk6NIow_1764946997
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47918084ac1so18558125e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946997; x=1765551797; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AKvuMZ9yOjOFZvKzY6cbgWjeHeLen5VOd92doJOXrh8=;
        b=Vom04bXXoGDVnWTNhndLO3gWb0cuVtzi+hb+bi5dTUYeH/U2rRhklDBa1Cc1LdJdyt
         532lr+/G3Zh5w3eHc/me8M5UPgC+cHJUUZiNwMQglgQk09vit3cjTpRs/PISCm6d1toD
         qCsg2lP7aMCpZhoRseineKY/UJhSEgUbHQl/2iw4SihTG9+g0zZUITCMQhXUigw9GFq2
         yQdh6eQ868Lp4bD6qlKwbEpGaJ1fv/VZ/fTZwXj7Q0I9o0uzDY/3xqYIoH7uEuzb1Asx
         mpBCJOk6e48kcaZTyMpdilzD38b92oDQ1icn7QlW6guNgbbEIjslfrVwFJkf3xtCaq3S
         VyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946997; x=1765551797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AKvuMZ9yOjOFZvKzY6cbgWjeHeLen5VOd92doJOXrh8=;
        b=kGHYcr/QznhpEGTovMZPattYHKbxH2oMt7swACNsQiIOb3yybg11LrnsbujN1+7Y4w
         ekgNoV8Ic/AVZ8Vd3gWiep4ctqrTvPhH/Hvlkhh9KvGmgvauJSLSjNrouDMEwCv9JU26
         JGg9R67yMZAxz4b7xl/DV5tP+us4V5UvBXHkyesyrkPPxbDrd5/Jy344+MymuxCxbCYF
         YQBKpm4CUFhR2RHEPx2oHoZ2nqKEoWRaS+RaHkBxluJjyjEO+zlJKDzPuhQPGCouFecp
         2Hb4T/JTqADH3q4zyyKTGG41uv/ZKybuzXa1GAoPAMYutG3p5dTiZuJskvgpvZ7nDyky
         uE0A==
X-Gm-Message-State: AOJu0Yw+bqt5IutLUcm9SkJgjxyloxwTpUl1g2CRZYF7miXPXNSORLzo
	UqEPE519R5qjHscTjr2yspNcA1+f+m4ZVT7YTWyzdBNpZG08WIxLG/02Jpw3tyix3enoxV9EGfu
	netmRtCKjsmSRQXzWGGatWN+66ILzpALtxYuES9G/SOqVYYLCUBh4kftVOAoyf+7uJd7HPj8n+L
	Uy0ZJvYwX8rtlRX7x7pJt9AKqRcksmLMV//f/uYFLQ63w6
X-Gm-Gg: ASbGncseE3ju9wAlBqff6GtID5owOEYlmHPhcigDU0CH6PbFAz5lI4WC2SaTCFlgbqH
	PEG8h105DLij1JSgkkvr3AfelEBC5115au+SAtXihHycgHhWyPfYYBSr2hwfNMyBQMbWlKge642
	CrGKNYZN/+tL34QWyPvrFubp8tH+zK+lThC0fh5Dh5DpjVBI0/Pv6jRwK+5Yo7jnCGAE7CXEdTz
	a3HI/eq/58ZbUBpNE+kPyIO6pO+XxhIZemsQeCkTLGESI4PTzBBX/GuGBQhLN2XsVEgeZ6E4q0c
	Wqv7numW84+zDLsbk/Brv7mH/m+9HtfhPmp09wR/K/bW/ZZemWSmdtccfvSt/4Ml+oHUNw/PxfY
	=
X-Received: by 2002:a05:600c:354c:b0:477:9e10:3e63 with SMTP id 5b1f17b1804b1-4792af4d4fbmr106377805e9.35.1764946996644;
        Fri, 05 Dec 2025 07:03:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnmJQkDRn+Hz/Tx6S6/T9WdFbaPC/tIkYEEqCPldbFpu84Uk+KvFykM88A4kBkgKK9wF+u6w==
X-Received: by 2002:a05:600c:354c:b0:477:9e10:3e63 with SMTP id 5b1f17b1804b1-4792af4d4fbmr106377395e9.35.1764946996078;
        Fri, 05 Dec 2025 07:03:16 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47930c76edcsm87417595e9.11.2025.12.05.07.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:15 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:15 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 21/33] xfs: remove the xfs_efi_log_format_64_t typedef
Message-ID: <bnoxbywdwuwrskw77t2hrkgqvrempvq6l36lk34u6fro7r3xur@x4nvum6ejodx>
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

Source kernel commit: 3fe5abc2bf4db88c7c9c99e8a1f5b3d1336d528f

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 75cc8b9be5..358f7cb43b 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -665,13 +665,13 @@
 			nr * sizeof(struct xfs_extent_32);
 }
 
-typedef struct xfs_efi_log_format_64 {
+struct xfs_efi_log_format_64 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent_64	efi_extents[];	/* array of extents to free */
-} xfs_efi_log_format_64_t;
+};
 
 static inline size_t
 xfs_efi_log_format64_sizeof(

-- 
- Andrey

