Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69C3921CE;
	Thu,  3 Sep 2026 18:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460207; cv=none; b=e+f5goL19csa7Ps0FGhhqmZYrvsniuGGzgQde+YWg16q5fL8KvwnCFbq+VY2rLAXQVIEbZWPghEs0voskxij3RbI0hW1xyoEYf4yfvmyac5K1avZ424r1xW+WreocySV7XUthtVMtYPNITvQ2f7fvimYShS56Zm3I7Gd4MtQA6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460207; c=relaxed/simple;
	bh=s9grWpA1MfOtv515ZQpTkDMTmGOhDbSQM3D43txdNWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSSNkruQsN5NzezWVlcSz05+DFEnFAxv2V90Yf7VxWgNVWD08doANVnwy4BimMjuVQDGHhgvKkcG1VycOn1AV/ebQpeb8LQ90IvpB+MuUa0FLFpX2dVWfY/1SylacCQJycTx4+zk/mFzEjdD98EbCJU8z6cqXI1p0MuafMul9Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=ZfVUbLvA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dP9rtL8a; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="ZfVUbLvA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dP9rtL8a"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 9E44E1380124;
	Thu,  3 Sep 2026 14:30:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 03 Sep 2026 14:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788460200; x=
	1788467400; bh=vEML2BGHrlYhrMvp5AB1SPVVJb0CVEuxfoeolIQgojE=; b=Z
	fVUbLvAibQBespoCa9TCmGkV1BnOYkv1M/xJyjDG1gyY6rHvdR22a+kfxPAs9MB+
	XF8T/bbG9xC9y88qQ7bqtuGOLmN6GyKlA04aHOkj6hwVYPfX5KvBE9i4zrntsoBc
	tBOg6sEb36G1eyQGKX139+1gpWGm14daiHOTVoCZKG5VCbGm2Mx0xkUx8T0iPfcd
	OLUWSUDJe9K4rQ2LTTeG7Ivm/ELObsZvHg8cl9w3j+mk9kQ0l3d6i2Z48RHFI/s4
	jj9fCAIrR+St/752PEaYXkx3nnn/FJRII1xpI3iZ+oDRuS6ItlzppRL6SDlA1WSi
	D3s4QERuEPkjBJ7cEnO4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788460200; x=1788467400; bh=v
	EML2BGHrlYhrMvp5AB1SPVVJb0CVEuxfoeolIQgojE=; b=dP9rtL8aWaMErlaKB
	Nkd+BmzduYONw4oxo8AFh5+75pLVElq5D7eNb7mpykySo9GBZJ+jVX+i19xGyLFb
	zM3egKiSN/yx5SzY3GDUm09bVmhK3GpOwZLiGioDnFBlJr0c/oU+1AAcef0TjgFK
	S3QnZIWeslmK3MSf8KJIbLZ/w6PFdckq2cyhO/UEQTwxQqMB7BqQga5sku0v5NHU
	mcG472xrqnHIjIaKZhnk29PWFH1EfImKodpDQqHzcc3twt5NjIoBxidJHhtS7o40
	tRdiyQq/7NNjATGbFmydEp1mDz7JngxCkXZ0wX/JN5IRKraMy9Fp948Dhg9pgydG
	Mvj8w==
X-ME-Sender: <xms:qLyZaj1TstH5-9fgTXdLz16Njpffb4ac_Ql1mcTdIBcY7Tyl7XYSng>
    <xme:qLyZajL2ogk4TNopHwwTJK6rWyYiQTstiaghUrznuMP9K-OT4FDz3Zwol3D7nCqKs
    EIdeVVe1r9Wv1GmK5j_ErVpSVYA2hWtnd2Hw9-tMbJRqu_bmE03bKT_>
X-ME-Received: <xmr:qLyZam2UMwwXGWgeHmPlvZzIG2lUP9mo7s3W4WhX7ibE5LmnR1oF7jKmIg4>
X-ME-Proxy-Cause: dmFkZTGHxwC/Lj0Bpod+4rdZ9spd4mDaW4xhMdggMrFSzQCeA9RP9FzsfDxO1aVEQuln3V
    KlIkun03rqLJS4PF97Rrmwc8zvF+vhZeY8/AccbFhjx8xCTK9U2xEB/cnF/j4CrJu3iI+j
    BDg6h6fOcXVaNyEdDW/UAbX4yL7zrcocoaRK+UcMxdgx6bHH3qnz957Bwbxgg+ymAK7JCa
    v7gyu76p9eB8jE5O7T8JvzBRYgOMnbmzr1XCS8fmgHILKnNDK2ydQ7V9ZxlyJmWme3VYwV
    QfwByNxS35mMCJZpf38kt5LBBSLWPp97jeu/UaoDB9vrULq5ydrUj8GkH6/ySug8LGaySq
    coUY0N3OP70olSepNjMeWj5mqOhaxOuR5jUiYT9qIhV5gEVXIDgSEmlIq8NPzpG5TPztZT
    WubPaJmIDKi/lX6eG+dHBjR6VX0xMvJQxZll/fBCukIBGXC1ExxQGK8KqqT5cX/KXlkwXM
    4FYqT0LZXJPXcs6JPOJlwZm9nBcXjg5gjUkk4fNwkkMwx1NTEiwp2NyuHl07d80tuzCaLf
    F/Phi0zWnhMgDDVo4rrYJn7Ffca/6UsJYfLqR2BjyJWxCoYQuqWqF79I5bSSMubeuF+mi9
    LY22vDexfWFkE0EbRwniR67TbvH9OSLcNCYrDD+BG4uJRdtDQghYe18qvNFw
X-ME-Proxy: <xmx:qLyZamhmpjZa3d_wEn8mu-NXpWtlz3nuS0Gh5Ul3L1mL2XL410nddw>
    <xmx:qLyZau3FC3t9eyuUqJB0FXsiPPfIUMibATQfBvsJr7DwwIpHBzsmPA>
    <xmx:qLyZapfMll4A5y_W6IlQX_xh9a_SFLEZdtv-PV_5_ck6-hKsKI_MOQ>
    <xmx:qLyZapEe_Xlg9CVUzKRsv5--NXuehRYlG7dAWMIeNVExk1GqEzxuBA>
    <xmx:qLyZalEjUMEMKr-o3DecT032H0k8BjpNewJt5mvo0AOG6MUls1F2OafH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:59 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 5/5] xfs: track mmap dirty state per block
Date: Thu,  3 Sep 2026 19:29:43 +0100
Message-ID: <20260903182943.662461-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
References: <20260903182943.662461-1-kirill@shutemov.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

With a_ops->dirty_folio_range() wired up, a store through a shared
mapping writes back only the block it touched instead of the whole
folio.

a_ops->dirty_folio() goes away with it. folio_mark_dirty() reaches
a_ops->dirty_folio_range() with a range covering the folio, which is
what iomap_dirty_folio() does.

On a 512M file held in 2M page cache folios, storing one byte per folio
and then calling msync() wrote 512M of the file before this series and
writes 1M after it. Minor fault counts are the same either way, in both
the PTE-mapped and the batch-mapped case.

A PMD-mapped folio still writes back whole. A PMD carries one dirty bit
for the 2M it maps, so there is no per-block state to recover.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 74a6089abadf..600e7de2e599 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -863,7 +863,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.read_folio		= xfs_vm_read_folio,
 	.readahead		= xfs_vm_readahead,
 	.writepages		= xfs_vm_writepages,
-	.dirty_folio		= iomap_dirty_folio,
+	.dirty_folio_range	= iomap_dirty_folio_range,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.bmap			= xfs_vm_bmap,
-- 
2.54.0

