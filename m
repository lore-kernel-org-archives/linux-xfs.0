Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E793B7B9D
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419157; cv=none; b=FLfEq5N4p82YgQ4KkSSeKWf23rA66DB9tV+/voVF+pqLh/NcJI6IfKSXK9DYAMO/Fxb/jFfhuZtLn6Tdajb5MWEFuzSrvo6FZOeH/Uy22xY45nAgEqHCHvQgPrvWbOg7Tyz5/GAfL5mHpjOZQ3v5cZ+aqlUyWj4yxk7ffRak2fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419157; c=relaxed/simple;
	bh=3A9adLHWhBBLyY5Fq6cFa4AsDkYm+WMZ1uF5O5/i+0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2KPCbkeyVgwxkydrZKcXbKWFrY69IBqH5QAFZHyhiMzkXFooaLrMXSHK8yNBhUQX0hxc4LEheWLKUCUovdqddzCbqS2uW3Sdawqke/dxAfuzh8YUPiB7+8bz580msXyZxOUFbH7lw7WMBcSDa/sSzfy/jHF0we7WavDLrnmu38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TcpF2R2I; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BcVel6a2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TcpF2R2I";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BcVel6a2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eER4EMxK1QY0jbijIig1GFWmq+ik0sL24fJ+0eczS6k=;
	b=TcpF2R2IU1hMuaue78mgDJ6yTILRuvD0Yu75/vrGt7fEXu3BpZfQsVI2iQVXbLwXAS76sF
	PhDjAY58Kpc40JtyG6hjRqrHN9aAOedXWTV1geI31PyXgiaOG7RPRF9J0UzhusNKV8BoSp
	eJg9LrYwtHKyJmSt/a37U747Kh1E7m4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-u3DMwLmBNf66py7myktw_w-1; Mon, 14 Sep 2026 16:52:33 -0400
X-MC-Unique: u3DMwLmBNf66py7myktw_w-1
X-Mimecast-MFC-AGG-ID: u3DMwLmBNf66py7myktw_w_1789419153
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939f27c80a3so714914685a.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419153; x=1790023953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eER4EMxK1QY0jbijIig1GFWmq+ik0sL24fJ+0eczS6k=;
        b=BcVel6a2OL5k79IvEFTfuTKq7kEWyWIrt7poNT2xPGznpcYZqfb6OSM0SXv3eSsDol
         CCjuPqs2fgFPMk7u+re7bLrM10uGRUmqG5gukIWiv5JO6KVyEYBklERamD+NqYdfrlqm
         YUJrWjbgdOjcppQ53VCRv9a3jpZ/2NcPqE9K3uV+8UdI44FYWJnSCQ4t7DfYXujoyug7
         MDULeuVT0WPlx4ux09L69OtR3mT7RfHYo5MtdrVg8S4+iYH8BmBAttQRQ1NYaAYskfsK
         N5amgsuw4bj0gu9OiP6pMbBSxKK4qZtyK/iSCKGAblaThZk/w2Yi/ku2FqP93vQDxpP+
         1aTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419153; x=1790023953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eER4EMxK1QY0jbijIig1GFWmq+ik0sL24fJ+0eczS6k=;
        b=BPwd7SBY3xzoeh+5LO9TW5c50pmhAr4LI/dcQCriQ5oKW4ZSeNDcnTbtGj84TCXvvo
         S1NoU33ZGf7hlSJRp2RDWlS2ypsULwf4YR8d7azuMjCH3Tbx6PA0wiPCdb4RLGF6rGnY
         GPqM8K+x+KqiB7C/PnUwrgYLz2O1uj/ACV9Pn/LF9c/g8i5FYAYeA2931o3FPl9eZwe1
         DIKN8+yl0OK6WwpAm8UfZRTRRXZEet6Y47t37ulNzrNTxo6V/f4Jj3YKcG7A6re/hOKr
         8G8en4IUtWutrs0rGOzpc0kMzTkRjabzdlCbzovvmcqZwaM/a7RDT4e+ZyO9GtcjJKn/
         aISg==
X-Gm-Message-State: AFuF++nCwFlxPplh5ZI4DZHyCTWmEKV7R8htajoxHZomepN19+mGcyWM
	Wj9hrQvHXsAe3cC1XHQh3fKj8oHAxA8GZDy7uPIbZq2yDbzbW01cicIotp7kx90C2At9aYM7UdY
	RzsuCCxzaW5j46bqILuolO8OH6cV99CK7OWnyFeTu6CW3H6JCsGIMhuyD8ZSxAQ8JNp6t+oVgsJ
	0FBpfeZaDN7Au/8AZ9C5Rn3YGLQTqbyV4X6Jo6PlfRdLDVjTI=
X-Gm-Gg: AYBFou345/kKnEIWu2SLtnQb983u9rX7txW2mZFSFugA5jcqj2TRQOnm8uJLEaEkMlc
	SpzecOUhnKXZRY9Mb0zWYyvvBtDFPOafVAeBF1gQQgwvmdDNF5wVkOW6GfnnDBEnBx8xJgLunbk
	LZ4SaAm25rtzaJrBsW6Q+wfiyIbu8NhkEifceetWlmOnlZQ9g/peo3hS1d91esPSb14vEY3neTi
	dS+1Oglht/XvOKnzKJWNOyYC6IKiLdioSoXC0pTctY7XoHHLgK3YI7gHbCJR9DQa6mTAces76ey
	gGH0KdMuvK57QOsiidvVlaa91vqmS2yK881b4rLX2GxGdKA85NGm5fpGWLVRmmtYAWmiY5bLRoH
	5grpHqXj6ko54J9j3X6ypBdHqEX6RN/LhA6zZCQ==
X-Received: by 2002:a05:620a:2955:b0:939:8bfc:471a with SMTP id af79cd13be357-93a29bb4ca4mr606083385a.49.1789419152864;
        Mon, 14 Sep 2026 13:52:32 -0700 (PDT)
X-Received: by 2002:a05:620a:2955:b0:939:8bfc:471a with SMTP id af79cd13be357-93a29bb4ca4mr606077985a.49.1789419152374;
        Mon, 14 Sep 2026 13:52:32 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:31 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/14] xfs: remove unused mp argument from xfs_rtrefcount_broot_space()
Date: Mon, 14 Sep 2026 15:46:14 -0500
Message-ID: <20260914205221.1516254-10-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.h | 2 +-
 fs/xfs/scrub/inode_repair.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 0e0b0c7ba80d..423851c77ba4 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -599,7 +599,7 @@ xfs_rtrefcountbt_from_disk(
 	unsigned int			maxrecs;
 	unsigned int			rblocklen;
 
-	rblocklen = xfs_rtrefcount_broot_space(mp, dblock);
+	rblocklen = xfs_rtrefcount_broot_space(dblock);
 
 	xfs_btree_init_block(mp, rblock, &xfs_rtrefcountbt_ops, 0, 0,
 			I_INO(ip));
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index aeef004ffdc9..9ab6ecf90ba5 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -145,7 +145,7 @@ xfs_rtrefcount_broot_space_calc(
  * btree root block.
  */
 static inline size_t
-xfs_rtrefcount_broot_space(struct xfs_mount *mp, struct xfs_rtrefcount_root *bb)
+xfs_rtrefcount_broot_space(struct xfs_rtrefcount_root *bb)
 {
 	return xfs_rtrefcount_broot_space_calc(be16_to_cpu(bb->bb_level),
 			be16_to_cpu(bb->bb_numrecs));
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 42e0d7a6c7fd..cdfde3cea5fb 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1405,7 +1405,7 @@ xrep_dinode_ensure_forkoff(
 			break;
 		case XFS_METAFILE_RTREFCOUNT:
 			rcdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
-			dfork_min = xfs_rtrefcount_broot_space(sc->mp, rcdr);
+			dfork_min = xfs_rtrefcount_broot_space(rcdr);
 			break;
 		default:
 			dfork_min = 0;
-- 
2.55.0

