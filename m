Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E11396D19
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425016; cv=none; b=KL4XrkIhOya6WQegkh6IIHUdTNMikJFcubzH4AdD0lKibo8lUWuJ6fsB5HBqEEeQlUcJNttBqgIWIckXTct0+RTo8NPHLPlsqC5CZ+wxcofjVkVeOQl8+jfmdR0v+2DDav3914YcldtZunyW+/JIomWFJ3YVoVqXRSIQCQSl5BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425016; c=relaxed/simple;
	bh=pRRKdti5RFexqVAOWEdIg0WA2pKfw4rl4Fy0G1lvHRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uh82bbkD2VsjIUTpXqS6T+y9wQ3MVcAaKMi0/CN+xvfPBRVPKShcvIKyUEdeNAyN16dDV/85EdrLoCAAnnQDbZMmF1dQzgf7n/dgika0MsQ/KfpDe5yR8pXnMaTIbBSYQseOfLwr5v/xcouKjSQk61iryLteb15RnQX7UWczLvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ii0mTIMX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kPJNBF4z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ii0mTIMX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kPJNBF4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1R5ZxOfm2hHpjt9nROi353uwAmbI3+SPgtIBMc52yGk=;
	b=Ii0mTIMXH5msz8WUhhx2PoaTIRakzgkjM0fVoNmnAp1IHxwd1S4glXql6LygfK2RVzBl67
	qBMHlrj0CqwldKNXd0gv2FioUex9YG134NgmcflAR5Q1IWTKZLQqXLoLcuLfurRzxWgtsG
	InHB6rIwcD6fPcSSq605CUloNmjRthk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-HZsBfxAQOICLEuqj2dA0Ng-1; Mon, 14 Sep 2026 18:30:12 -0400
X-MC-Unique: HZsBfxAQOICLEuqj2dA0Ng-1
X-Mimecast-MFC-AGG-ID: HZsBfxAQOICLEuqj2dA0Ng_1789425012
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-530d206e2b4so77055721cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425012; x=1790029812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1R5ZxOfm2hHpjt9nROi353uwAmbI3+SPgtIBMc52yGk=;
        b=kPJNBF4zX35qoqfCNKTC79mopceWgGWRrFuynXmEPLTkiQGKPCvTXD4ZT4l58EoFpC
         DD0eNlkWofj240Kz84HS+iHs0Yy2cYhlVteN0H6uCq7cZslovAuMqY4xjCzcZUdD4tlB
         FH51WZFtBX1LD6R9Q5jHq0+WXAeebpC/5MNVh3LGcaNExOjOrb7EZx2WCr/nNHS3woUA
         NpvuCIvib7Pjt6K3BPkytIR9puz96BRjE59pdRP+62RZW/dwMIP8F/R6ovDfuwgV+5lY
         SCa8/OJ+dpXuQf7qPijGWPXvzqo4uNBpEw8cElu7NjWpdjecjfbE1yEktsOj88Q4J+T5
         i8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425012; x=1790029812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1R5ZxOfm2hHpjt9nROi353uwAmbI3+SPgtIBMc52yGk=;
        b=pMc+i1e5s1FAh45LtL7UMsm1bzEDZrtaEVSlYyaQCWSZoGSYPJeEFdsf1pn5jWkoSz
         N0EgfGOECRZ3IFssr7R9DLN1VGeZAhC8HDZI6aJ6Ycf1u9A3mKIM0hc1PXG7896LzMwd
         jbzzUIrD4n7abc4YJFBcKolZ1oOFMhCv+yZQkzR6ExCTxQDHFCrOwSXRp5XWCtfj++kd
         e9CEMr75MdSNjg9yxgrr0AKCQL/cBZh2hnV65K+TPbUgicypk8FfMs9F/lUlZJme3VlZ
         03DH8e5TL2WGiuwULaub4YCLb2TFVGKoVqkcL+kXqE8YtOrrOBZ7BbEmpYwKtjN6a5sH
         wPRQ==
X-Gm-Message-State: AFuF++nOFJ8YG1V/HUGbHQLONULWU3TUaBohXnrVU/5c1EGIdkoCRJlO
	53Q60nRoEE57vxNku7uP3tMtEgyhS3xP3o87GFJz/XeZOCFkdsJSoXiXcZWJ2qTfjH7LxOuMhUf
	0/QtjgBsf350hDHwG7YTI0kQglNr4I9Q2pPGsOh/+ysHB/Xn33BknwHXHQjDZ6AMddKxG9tZAnn
	XjYnhPmbbYZh25S3ol3ySBqSzGwioSMC6bAw9A9Vt0zUTdya0=
X-Gm-Gg: AYBFou3iqQg+nxBivPVTGnMGeA50dvGctHbSyE54Xykk3hvIGY+raBqKvBP4JC8/ax5
	0no/uwUU9H0CzwonpLkXLLVC/nxo9D7F4Rsg2+f8AYxiF00G5iYrxBy0IkzJQHVyCjfDAxGwUUc
	6G07bacBviciottsQzQmUWG4R6AsckCy7lIyAopQXFh7WCx8hhGw/GZ6EJKnrN4U7ggjTs+M6mT
	paRXeIrnBgGA7dlr56YNbjcuhyP2QNkaMJcj1N/JXsX6jZV3KRbkcJ9WlyPhdF36mLparBP0eH/
	wy2RXOQoNzWLGklI1tAVquCnJ8FYa6XqRqNKw+3savS2/gGD6+mGZseaTc9iA3+Ja+fsjqRt0tM
	85b7opAVlpkb7Gx8FXHDc2PPTwUIQ3rpbcHQOYA==
X-Received: by 2002:a05:622a:1e0b:b0:530:e09d:798d with SMTP id d75a77b69052e-5310cf173dbmr76708711cf.7.1789425012239;
        Mon, 14 Sep 2026 15:30:12 -0700 (PDT)
X-Received: by 2002:a05:622a:1e0b:b0:530:e09d:798d with SMTP id d75a77b69052e-5310cf173dbmr76707511cf.7.1789425011444;
        Mon, 14 Sep 2026 15:30:11 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:10 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 02/14] xfs: remove unused rsvd argument from xfs_bmap_add_attrfork()
Date: Mon, 14 Sep 2026 17:28:48 -0500
Message-ID: <20260914223007.1587017-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c    | 2 +-
 fs/xfs/libxfs/xfs_bmap.c    | 3 +--
 fs/xfs/libxfs/xfs_bmap.h    | 2 +-
 fs/xfs/scrub/inode_repair.c | 2 +-
 fs/xfs/scrub/orphanage.c    | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8fb3adc3dd2d..c4bb59633ce8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1013,7 +1013,7 @@ xfs_attr_add_fork(
 	if (xfs_inode_has_attr_fork(ip))
 		goto trans_cancel;
 
-	error = xfs_bmap_add_attrfork(tp, ip, size, rsvd);
+	error = xfs_bmap_add_attrfork(tp, ip, size);
 	if (error)
 		goto trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..ca147dfaed05 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1026,8 +1026,7 @@ int						/* error code */
 xfs_bmap_add_attrfork(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,		/* incore inode pointer */
-	int			size,		/* space new attribute needs */
-	int			rsvd)		/* xact may use reserved blks */
+	int			size)		/* space new attribute needs */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	int			logflags;	/* logging flags */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d5f2729305fa..60f6df4ce057 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -181,7 +181,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_trans *tp, struct xfs_inode *ip,
-		int size, int rsvd);
+		int size);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 8bc508336aa5..42e0d7a6c7fd 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1949,7 +1949,7 @@ xrep_inode_pptr(
 		return 0;
 
 	return xfs_bmap_add_attrfork(sc->tp, ip,
-			sizeof(struct xfs_attr_sf_hdr), true);
+			sizeof(struct xfs_attr_sf_hdr));
 }
 
 /* Fix COW extent size hint problems. */
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 3aca66869b80..8c9f323201b4 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -546,7 +546,7 @@ xrep_adoption_move(
 	if (!xfs_inode_has_attr_fork(sc->ip) && xfs_has_parent(sc->mp)) {
 		int sf_size = xrep_adoption_attr_sizeof(adopt);
 
-		error = xfs_bmap_add_attrfork(sc->tp, sc->ip, sf_size, true);
+		error = xfs_bmap_add_attrfork(sc->tp, sc->ip, sf_size);
 		if (error)
 			return error;
 	}
-- 
2.55.0

