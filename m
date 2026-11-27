Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795797174;
	b=nHI9pELujqwRazrOoHCZ0cE4bv6b6mtambj9TueYPlw6WxBCDYcyJnhOYj7mhBxZp4nu
	 yEjhFjwTnpSLbpztpp3MzoQ6zlSuD3qtB7qFpaaP2BskZUzR0JlTqV4uQBONnVjfDvQe9
	 9J5sAKwQtyDdIEwGHArjYy7heTH2vS04u0mMC5WUCKuVs17clM9b5v9QW7e5HSHRgreCV
	 s5i0WA84L82li1S3+2Ceo6lD8XM/eb957H96cYzJBjwYC1T995yUI41NSRMXyR/1dcjDl
	 qaaepyBm6dj1Uo6YeRKLqEnYaGNa23F0UaIT++Roi9Nx7dSfI8gDCKsRXMnEGHOhYgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Mailer:MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
	b=SpAmgUY9iB0ijGgWqg774ns3CwB90p2qY3izyMPvniiA+QTa/7xuPvPJrwD9yqFnq1ex
	 joY6Mb58UHC04HC1kC3O1yShERWi50r7IsLitQ7W6AW8Kl79AkvWoTCiphPK1GjoZJfHJ
	 Qj/aDd597OVnuiDqjrj4M14SMn4qWMz60FxctnYfl8mpwGM8rIcLS4DkMcBqw4x72ay2+
	 HrgK9tTwIdw44mj8CVHqF7YL5985hhIQnNLYMO/w13XgzFeB08ylhtEzW5yyQQUBt0dFi
	 vs+sAB2un3ZXkAZUyxhjZmuyPE0wnAVyR4U2n20RTsKox0WD6Pv1Hm26qHkaGJnmH2A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=echophase.com;
	spf=pass smtp.mailfrom=echophase.com;
	dkim=pass header.d=echophase.com header.i=@echophase.com header.a=rsa-sha256 header.s=google header.b=nU7VRCMg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF96606A323
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 16:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFF96606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=echophase.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=echophase.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=echophase.com header.i=@echophase.com header.a=rsa-sha256 header.s=google header.b=nU7VRCMg
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b502b9b702so95645497b3.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 08:32:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795797173; cv=none;
        d=google.com; s=arc-20260327;
        b=o4lkhwPqFoJuIM8x8ZmSS90jw0gDxh/0bZ4e/6CCx1XuoT2w1VCFBwsny2791H2FVs
         YUFWZRDSB+GvwSP0XmxHhbO9thiRhz+Tb4LplOhcV0mpGPMP+RYh1D4/Rwy48Rn2ypn6
         I5rzAKo3nmBcqRDc6UIqbTk+6eEbpfiAJN872jSQ6p2WzgAA66rUdCDJIxMCHiqhs9e4
         yt0kejg2jwrIpiEsNWe3wDj14HechM0ItUgd4/yX95KgAXxJKc9r7KI3KzMdCPmaXkrc
         ILUU7OlWlsdP+P7zfkbE3ltywLxzCWafEzsLOKaKjKKTo6uCtY7LJJfoe83VYk9ygSFT
         ZNXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
        fh=MwpGePNqdFAqCH3FvfZOVHZHLDSIZti6boGkrRtQn84=;
        b=AHTWYFgoou5l5M2DV8lrM3g2MCuqNdljV02THvR+yjjLUtYGE0PsEk2ipm706eHVgK
         w2XUt6dFrZVsPkmhzJV7UHcMyNKzdV5GBz0EXus+nU+0fWlolP6P9gcwMuOuXyjsl85K
         S1Q2MzILj0+WUZQmvRqOnNkEe0AdnxaRpii+ga3aVGiqRvkdeSDP4166hOzD5hkeFBK6
         DHdHUqxRF0oTHFjpwNzE3wq1PofwWh4CxHp2Ythoz0XAJziBlAnUd6ZhNInjFOejhS2F
         zpkNqN/uJBfx0VPS5UUyxwFjHCAfn4YoI1uFO5v5qiCgLbxfSoPF50BX+FU0VAK77OiM
         2TbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=echophase.com; s=google; t=1795797173; x=1796401973; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
        b=nU7VRCMg6S/PeSbcDbddxdWo5UV71g1l2fPnpOLkBeJHmI9vd/VtSayPDD4kRpRLyL
         n30mU1diRB602R5GjrBWEK11PMzWVwFPDFMdbfX3zOVnhtYiJhipK271461Ahnt7Yu2j
         EBBIpeZK7iLzsCFsZHOZlYSjWk0KxQurIsoodiKn0DPM9Rb4dMKDzmAZgiyzStC8x9Jl
         Pjn8YwTY8PxnTUoiD6d0Mr8jKHAg+Ht5fddR715CorMfa7728u5pwAqNMOIF6baQVaSl
         2tzK1TW/qAVbfSOPjzZlRV6Cf66oqXNcO0DyT1D9Y1IsW77fm9WP6bqRC+Nc6zBybrXO
         p7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795797173; x=1796401973;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BzVKtW5NHdb/sxlNHYFUIiHG+65dbsYhejickBFJVMk=;
        b=jUr5TDYv8F8NkiLZOVp3efePUVd5Gm6jV7Sy/aDDlymD06VXwMPVzDgGySuGWQEERK
         Wf7ZXZyeM2FEvxNJrawSJasH2JNVKYK0+1Ku8BIkS07NPb16KN0ONiUKqnHLDUOqNNA6
         gWRmbOHrLK7Svt3NInYLvl7V54Ect7xfTAU/QVgm+5WJkGEX9YqANUHjyJHWOHzZzJjd
         RNXXenVT2dJIKgMRUrS/ibVmUUabBuFmulH8oHuHxEfF1F03C6kjWrzGBcLqnJpwe3wO
         vXcjdg8BkolluewCQ0nG6Uvlb+bpNfgNf3/FVUJuW5zjpqD6HMuy8tmKo8P8Z29DAmIj
         bzUw==
X-Forwarded-Encrypted: i=1; AL+hErEesTMPYDTEvURqSqz+yiID5MPBlcd+twH6KSF6fGepR/jbBc9t/yy42h1xd9R+2tv1raZK+K92y1U=@vger.kernel.org
X-Gm-Message-State: APuU4Z++OJGOKWLEtR6bdPUevDoNomhgMcG017n7thsIJJk/6+1fZz+q
	RwdI3LnSmxC4AMyvEINmdl/WWhjgoZG8Co7bZYarWH63jBjdztsetb7uXKJpUjcmONeQs3AwOO7
	eMzy38jNYPBuewH7ELjDPpq530MfkeIZ4+FAsYufHqA==
X-Gm-Gg: AZFdTZdgASHnSqiaTpmRBBzeShfmkKNOGDdyBIp7BsArgQUS8Z/gXU/dR+LBDJ7qN3H
	uCrww4MmWrtAdO36+R2jkvjctX4RlkAtdW0T8swmztfVSc7etmaGMLciK4p/jPwtSOM/ZV1c9Lq
	myO/DpjZkPbHCDar42b2y5+rtvHeN240beo/VNT/0p7fxWNBsUaTXSrGyip1TegkHaIa1knqshk
	X8MX1u1PPKWEnlIxv04I5fffFITu2ODbk4/satcBU0KCzsfqoWLlEo91DRtVcqSBmSNHCXyX/CQ
	Sw+DVdb5eALAyS/kjJI6wsH3rUMx7TyMOL4Fk5yadkDLa4uD2sCgqEwVNtagUDNe6uobnBG0H0w
	SK8biGUBLsbqO10ww31d7jgPM63zb29IrUNsdQKobynQnQem15RKzjQv0QCapM4uJHO8Ezg==
X-Received: by 2002:a05:690e:47c7:20b0:679:ad63:6752 with SMTP id
 956f58d0204a3-67df4485df0mr6760668d50.88.1795797172525; Fri, 27 Nov 2026
 08:32:52 -0800 (PST)
Received: from 1009040482268 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 27 Nov 2026 08:32:51 -0800
From: Ramon Nogueira <ramon@echophase.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 27 Nov 2026 08:32:51 -0800
X-Gm-Features: Aa3M54rMQUzpO4yRAeN4raM6katXNjxW27MCpyzDDVBLsa2OU0HqYrWxnLZTdwk
Message-ID: <CAMM96J2Ma3gSwZAtF2S2XNWxP4wBtN5VxYRY_KQO3fqNGztrEA@mail.gmail.com>
Subject: [PATCH] fs/dax: do not replace existing shared DAX entry on read faults
To: Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Ramon Nogueira <ramon@echophase.com>
Content-Type: text/plain; charset="UTF-8"

Commit c6f0b395b211 ("fsdax,xfs: set the shared flag when file extent is
shared") replaced the write-only cow check in dax_insert_entry() with
shared = iter->iomap.flags & IOMAP_F_SHARED so that
dax_associate_entry() receives shared=true on read faults of shared
extents as well as CoW write faults.

However, unmap_mapping_pages() and XArray entry replacement were also
switched from cow to shared. As a result, whenever a filesystem sets
IOMAP_F_SHARED on DAX read faults (such as XFS on reflinked extents via
xfs_read_iomap_begin()), every read fault on an already-populated entry
zaps all mappings of this file for that range and replaces the XArray
entry with an identical one.

Two processes (or distinct VMAs) reading the same page of a reflinked
DAX file then ping-pong: each read fault unmaps the other VMA's PTE,
causing repeated page faults, XArray entry lock contention, and TLB
shootdowns. Furthermore, a PTE read fault hitting an existing shared PMD
entry unmaps and overwrites the PMD entry with a PTE-flagged entry.

Keep shared for dax_associate_entry(), and restore cow = write && shared
to gate unmap_mapping_pages(), entry replacement of existing real
entries, and PAGECACHE_TAG_TOWRITE. First read faults on empty or zero
entries still enter the insertion branch and pass shared=true to
dax_associate_entry(), while subsequent read faults leave the existing
PTE or PMD entry and other mappings intact.

Fixes: c6f0b395b211 ("fsdax,xfs: set the shared flag when file extent
is shared")
Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Ramon Nogueira <ramon@echophase.com>
---
 fs/dax.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9d161d7ef..de3931788 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1078,11 +1078,12 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,
 	bool write = iter->flags & IOMAP_WRITE;
 	bool dirty = write && !dax_fault_is_synchronous(iter, vmf->vma);
 	bool shared = iter->iomap.flags & IOMAP_F_SHARED;
+	bool cow = write && shared;

 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);

-	if (shared || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
+	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
@@ -1094,7 +1095,7 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,

 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		void *old;

 		dax_disassociate_entry(entry, mapping, false);
@@ -1102,12 +1103,13 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,
 					vmf->address, shared);

 		/*
-		 * Only swap our new entry into the page cache if the current
-		 * entry is a zero page or an empty entry.  If a normal PTE or
-		 * PMD entry is already in the cache, we leave it alone.  This
-		 * means that if we are trying to insert a PTE and the
-		 * existing entry is a PMD, we will just leave the PMD in the
-		 * tree and dirty it if necessary.
+		 * Only swap our new entry into the page cache on a CoW write
+		 * fault, or if the current entry is a zero page or an empty
+		 * entry.  If a normal PTE or PMD entry is already in the cache
+		 * on a read fault, we leave it alone.  This means that if we
+		 * are trying to insert a PTE and the existing entry is a PMD,
+		 * we will just leave the PMD in the tree and dirty it if
+		 * necessary.
 		 */
 		old = dax_lock_entry(xas, new_entry);
 		WARN_ON_ONCE(old != xa_mk_value(xa_to_value(entry) |
@@ -1120,7 +1122,7 @@ static void *dax_insert_entry(struct xa_state
*xas, struct vm_fault *vmf,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);

-	if (write && shared)
+	if (cow)
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);

 	xas_unlock_irq(xas);

base-commit: 9437ee8b6cf607e883b36e44bd755968daaebd48
-- 
2.54.0 (Apple Git-157)
