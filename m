Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8A15CD74
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011834; cv=none; b=eyhWLNlyCAGQEmgWd1+csfP0cZ4AwS4oLu3Q0BXUsmkK8C1p3XPMtl8seIBNvEV4PsWQuuM1wb8C0QjiaGXxD6FFwH6xGcj3O67PBkKzut4BjLdzHx7EKUNLfrN5h6xqfTlc+nz/adJvPp5sb2gIGSAsenlwDCRq8wWsjZ9EorI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011834; c=relaxed/simple;
	bh=SwGIOfT55Bp4Y4RMrtfU5AcQkdPvoVG6sv3KtUUmfyM=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IaTxxNMy5FPvw7CFEfkTDcQBcGYsfo+3zrNqVcq8rdfyY6IWaddbZuJT0/qSFxEHw3ouyk3QxgrI2uLeYY1cWMlpuWZu0ehX0MydOXqlCu3uZaGII/OI1oAHfcHkiW7ON/Zdavc8SHMvBF6xbjn1dqAjo3nlsYUtcDFJRvCODWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TOtdOL7u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TOtdOL7u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MizCjesDc0kkkA3m+mVVbObLIP8Gt7nE0+TpLzjUR5M=;
	b=TOtdOL7uszentqefPp0+Nq0akP+ljbKcX57UUszSy8Xc7kX5uqMtPnFmWGARf/SmhMQGGk
	Es8smFJ+EK9+N8UkTw1JlRMH2vUjzIGc4Ij7uNgzvinnzqEBpyi/FXzm4lRPHDZ5nTBYie
	RDEhaNuyKwZNYUazAyeC4hkmA7FQ6hM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-myDwvUdxN0uF2ql4nWw9uQ-1; Thu, 09 Oct 2025 08:10:31 -0400
X-MC-Unique: myDwvUdxN0uF2ql4nWw9uQ-1
X-Mimecast-MFC-AGG-ID: myDwvUdxN0uF2ql4nWw9uQ_1760011830
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f3787688b0so673701f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011829; x=1760616629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MizCjesDc0kkkA3m+mVVbObLIP8Gt7nE0+TpLzjUR5M=;
        b=GnX+3CU+4dtYiWx0rWQTo9wUF8lLUzD1oTuoysmIns0Iy1D7fSJNxszmJiuYg9no5V
         2aR9sQAFC1R8GXIL8ZpT6u0ihiHPPGDwVy43k6gXseTXEZ3IVk3tlwlqqiq0FCKE/FMT
         j+tXBk4w6fHfZ2MWMKCZWARKyCYxrbaJRzUk2w2bSQ5pplMK7tlokc/U2s/WFz++qgfS
         hqFJjVocOVIKClJ0VEelWkNCZVgRfdXe+uBHCvj/4Q/uimOIUPvIE03IsAqdLFCx2hE7
         AiGkUHkyaN3nIx9NHGPEqJkmIgNKPWUUPARu2mWMmj34Q6CvldtPiZAKlOVaxFhF+dQd
         4lnA==
X-Gm-Message-State: AOJu0YzwzHbJRFL5h5YZswsn0qvU3jb2cMhdOMEDHffPuKQbZxwPupsY
	vTYi9Trni8YAJew0yghl9QpPXZ/aZ8dtBlLmp4f92xsiIjWA67qzRXQj/EvIdOg30Sx8ZHudOaC
	JtPXoFACpjxA9N9xy+LuuhzYqJ2UZBOYhTYxUHhHYmGMezPgyhC2rlZnhkC9mBaYm+NidG66EXn
	Jhb1nFLJT5LePnmSX3zYcxUcLi12uDaRypG0ywzkHEp1os
X-Gm-Gg: ASbGncuyVsxS162UfXcAN4G5s286IrIpmvPo6uzKXo76boXixbv3v/RNszuxIOUGqKI
	7AXzTHJOFyddeh+Js0VjRoZ8YQYaKSgnt1lEmpFAyKeov3G4gqIHtyQUhkawJGMIRpf5tGkH+3W
	ab1DWnQuZ3/k1lWS5rU3ibgKzrI+pKSPIeXKERQAgCEk/06DZKGgCvWgmtn9vdiZiIMZCoRR0OF
	JGbrashmpftFqN30vy6aONN4VK8GptqPG9iOjdyimrWJkkwxQEZsC5ayqgWORmMmHklvaEYhHTb
	LVX0hWiEm2R8CoDvrWTe1hdIg01Avl9mkVICBnBMyJiCOuG3Og0XZ83OyAEw1dyF
X-Received: by 2002:a05:600c:1f06:b0:46e:384f:bd86 with SMTP id 5b1f17b1804b1-46fa9a9443fmr46365565e9.5.1760011829385;
        Thu, 09 Oct 2025 05:10:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErazv6tVLXz2a0K1+lpGu25K+xK3e81WzuROw69iffJW82RRN0y3XOLmDyoYmubWybanuKjg==
X-Received: by 2002:a05:600c:1f06:b0:46e:384f:bd86 with SMTP id 5b1f17b1804b1-46fa9a9443fmr46365215e9.5.1760011828802;
        Thu, 09 Oct 2025 05:10:28 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab4e22d8sm35237785e9.5.2025.10.09.05.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:10:28 -0700 (PDT)
From: Eric Sandeen <aalbersh@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Date: Thu, 9 Oct 2025 14:10:27 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 11/11] xfs: do not propagate ENODATA disk errors into
 xattr code
Message-ID: <b7kw3zsg6xogruotvi2uplnytbv5wk7cplbu6tyzozyj7cuble@gga43vqkknw7>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: ae668cd567a6a7622bc813ee0bb61c42bed61ba7

ENODATA (aka ENOATTR) has a very specific meaning in the xfs xattr code;
namely, that the requested attribute name could not be found.

However, a medium error from disk may also return ENODATA. At best,
this medium error may escape to userspace as "attribute not found"
when in fact it's an IO (disk) error.

At worst, we may oops in xfs_attr_leaf_get() when we do:

error = xfs_attr_leaf_hasname(args, &bp);
if (error == -ENOATTR)  {
xfs_trans_brelse(args->trans, bp);
return error;
}

because an ENODATA/ENOATTR error from disk leaves us with a null bp,
and the xfs_trans_brelse will then null-deref it.

As discussed on the list, we really need to modify the lower level
IO functions to trap all disk errors and ensure that we don't let
unique errors like this leak up into higher xfs functions - many
like this should be remapped to EIO.

However, this patch directly addresses a reported bug in the xattr
code, and should be safe to backport to stable kernels. A larger-scope
patch to handle more unique errors at lower levels can follow later.

(Note, prior to 07120f1abdff we did not oops, but we did return the
wrong error code to userspace.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_attr_remote.c | 7 +++++++
 libxfs/xfs_da_btree.c    | 6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index a048aa5f2c..82217baf40 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -434,6 +434,13 @@
 					0, &bp, &xfs_attr3_rmt_buf_ops);
 			if (xfs_metadata_is_sick(error))
 				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
+			/*
+			 * ENODATA from disk implies a disk medium failure;
+			 * ENODATA for xattrs means attribute not found, so
+			 * disambiguate that here.
+			 */
+			if (error == -ENODATA)
+				error = -EIO;
 			if (error)
 				return error;
 
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 38f345a923..af3fcdf5e4 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2829,6 +2829,12 @@
 			&bp, ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_dirattr_mark_sick(dp, whichfork);
+	/*
+	 * ENODATA from disk implies a disk medium failure; ENODATA for
+	 * xattrs means attribute not found, so disambiguate that here.
+	 */
+	if (error == -ENODATA && whichfork == XFS_ATTR_FORK)
+		error = -EIO;
 	if (error)
 		goto out_free;
 

-- 
- Andrey

