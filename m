Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9AE4D90D4;
	Thu,  3 Sep 2026 18:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460207; cv=none; b=DdydLNKZhCVqO9ur0Zk2G9GQiCLALwHtxcXoKIWq4lRGwxd/kyQ6b2TN6MKN53MjZKvA9L5Bn9ecrAZFGNhelDi4IdYPlyBI7PNruqCnl4g0j7zPC3goeFkdid3xFldiyZw1Ewa9EYlmWlOx19+ApWimZskQSSy/bIv324NhNLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460207; c=relaxed/simple;
	bh=AGl0yqzbyZIZ3+w9gehbrVCg4atEJD8pd5d/L+GIIrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEiZUTEL3TDLyEzwo45rwWx13ub5hDDSRgUOFtCaUgnZDjUx7UNP7aQ6SQ3Vxq2IM/EXMxPufvviAqdP4SLfr0z381PAM/PuE0CzW8XeyEU4NzS0zWAr9KySXwb6z0hQ7cvi3fSSxcTmC6CyxpJKgYM7uNu/vN+w61/joT3scG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=MsuyO2Pz; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DbzgCr/L; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="MsuyO2Pz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DbzgCr/L"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id 6205213801BF;
	Thu,  3 Sep 2026 14:29:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 03 Sep 2026 14:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788460196; x=
	1788467396; bh=YaDn1Mr2KlX00kBdrNWD4+vAoqqgrXa7uJO/7qm/H4k=; b=M
	suyO2PzQqzmatJVuanDQjvKAb46heIMEBntMOnbccW2xwfQ7TL4F5/zuk7rQyUJS
	rd5/xkqFWmEWenrjDe/V4e/M7dcmR4+TQ8E0SRvNJ6IAkv+n4IKK4sS53vNWigOP
	nWhIeMS0/gRlzHUx+MIx+6a28K9TfOqLMu2BW+X4LWTCYD+ikvyDBKR3Uo1/Wo/T
	jI9QP9z+sZJLxVQ769Y+WayAEtFibHUfqPrS8gSf/zCmbLmZF2dTxYjrbpw8y+rI
	N31IBypoX7BjgTu2pCRXTtyUxqsiwsJnYdM+2P2mTMUUE+Khy+Y/mg3enbD66MGI
	7Dd+hHVuD2my0zHurTXEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788460196; x=1788467396; bh=Y
	aDn1Mr2KlX00kBdrNWD4+vAoqqgrXa7uJO/7qm/H4k=; b=DbzgCr/Le1sX11vVP
	7GmorVE4FqVpz6jCtJaCoTYDUUaOSIPXO8DJ7CKC/LbnppB56MXf0otj2AskYUxp
	YdFxPXYda3pL/fKW9u6CU8/4UUGEx6373kLAjc0vvyCtbGu0qkkCDFdknBtgmY52
	/R7oem3dvIsTrcmtZoDfLxlRpJXEfAzgU9ngP+dmS4hgSQmRViv5rkyq9XCCCMIi
	yrCuYj/FuL4CVvhNtDxg1GB10I8ZJ1g15nTKV9ye++E2i19Ow6jwUC8ldnkZFmKg
	5Pj5z+Cc9nxtSMZXOD/950oU7spRLNEJZ1Nn55a7F6HByJPQmo+IU3M92QhyltiP
	RXdeg==
X-ME-Sender: <xms:pLyZaqjrww7eX7ego3SJEDa4QrDqkZLsARcKqdLOqhQJMRxAr0glEw>
    <xme:pLyZaqsbjHSLh8okLoiKDj0hwa9GWz3NPp_F_62DqYjMIPM9zwNHTRHmqA02sLSGO
    joCNBnZoY4C-2qfCF4BqSOc12OD2-vH6OYtrMhVXRqKokMEd506AWAL>
X-ME-Received: <xmr:pLyZas6vAZ8zuJ59pSqTFLsImJJJGbx6xBeY3Mp49F47Ot4JTmvwjoqyOeE>
X-ME-Proxy-Cause: dmFkZTFt7tpQ23d6ma5ZKwjaUeV/XmiCXSwfUJTD/UMTaTx+tQ6P98fG4/H3PFA7hJFxaU
    SY7i6N6X86D7HaHpdbLHvMivEhulOmq3NoSfdg1pBrJA6v+lfq2ALheALUZjz6o7Nf8BIz
    DWIHLTWCbkC3w9bMwM7vsWb978omVdOmMplVzO2fLHjMRy1E/CxFkmf+2uWv7frAXfMOWG
    H/vdAXIPTaxMrzbmklMnL5PmRnZSJQIp5M1ihNDwszNqcLBuKJXCEkMPvIWqkfKnePof3W
    BlQ363pN/8dtwFHD474IAw0kAsBZ9JYvF7V9lEJnX7ro/M4XAHwxRodQrXyCYUn1NLN+V2
    WlXbIyuCNTMYS9ZmYmi7Wi/90XXuwuQ/NA/yJbaBk7n4YmF/Fa7zOdJg1WdYIjDOJdp6hh
    ptgs59nDPCUW9de3B9V4/fpiGW/B1vB3mzc/YQWuOYT279QwjVDtwX05wgL7hFPCYvgkEC
    dRxtjhl5ExCKf1Ug6ah2j8izXWrb0RpAwbstfBWXHLZvPuUhLVmo9ZXao281T/269HgiaM
    BF2KNnURXUG9XwSdzbaOR26vJd7tKUTSlkp/0SwBs4DAf3or5HjA/lXjm8s22buqgPuj4W
    neilQdGiiklz/Q2Bt/PY2bT3OTIIocN02kwpbSSn+Pc+3VDCbU+3378snzgg
X-ME-Proxy: <xmx:pLyZaluq4wuw1zIoG9ly3QX0jzyx36jeJE6YX6xMjWEfKFC1k_qvog>
    <xmx:pLyZam3jJft_79npmN_AeiUprT5MmsTI-SKejrh9vWzM1vxPAEJFfQ>
    <xmx:pLyZaq8btlIZK8VscVtIl7FRFxwGCRHm5XFrT258jFt6sp9XgcarhA>
    <xmx:pLyZakA1Gw2xX5tA5Wc8wj7z-xSBmzGKnauuE9BwxjiFoAOuOm0PwA>
    <xmx:pLyZag_ApqD5w0e2L6JT6zp1taXyXALe51YF2M8KMDw6_yrfrwJd4FKY>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:55 -0400 (EDT)
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
Subject: [RFC PATCH 3/5] mm: keep the mmap dirty range down to the faulting page
Date: Thu,  3 Sep 2026 19:29:41 +0100
Message-ID: <20260903182943.662461-4-kirill@shutemov.name>
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

Two places in the fault path dirty a whole folio when a single page was
written.

fault_dirty_shared_page() marks the folio dirty after a write fault on a
shared mapping. Only the page the fault was for has been stored to, so
pass that range instead. A PMD-mapped folio is still dirtied whole,
since a PMD has one dirty bit and there is nothing finer to report.

set_pte_range() marks a whole batch of entries dirty on a write fault,
which destroys the per-page dirty information before the pages have been
written to. Leave the batch clean for a shared mapping of a filesystem
that implements a_ops->dirty_folio_range(), and let the hardware set the
bit on the first store to each page. Anywhere else nothing reads those
bits, and on architectures without a hardware dirty bit a clean batch
costs a fault per page for nothing. That covers shmem, which has no
dirty state below the folio.

The page the fault was for is dirtied right away. It is about to be
stored to, so leaving it clean would only move the work to a second page
table walk or fault.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8da0f945141b..27a059e0c016 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3778,10 +3778,19 @@ static vm_fault_t fault_dirty_shared_page(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping;
 	struct folio *folio = page_folio(vmf->page);
+	size_t off = folio_page_idx(folio, vmf->page) << PAGE_SHIFT;
 	bool dirtied;
 	bool page_mkwrite = vma->vm_ops && vma->vm_ops->page_mkwrite;
 
-	dirtied = folio_mark_dirty(folio);
+	/*
+	 * A PMD entry has one dirty bit for the whole folio, so there is no
+	 * finer information to pass on. A PTE-mapped folio only has the page
+	 * the fault was for dirtied so far.
+	 */
+	if (pmd_trans_huge(pmdp_get_lockless(vmf->pmd)))
+		dirtied = folio_mark_dirty(folio);
+	else
+		dirtied = folio_mark_dirty_range(folio, off, PAGE_SIZE);
 	VM_BUG_ON_FOLIO(folio_test_anon(folio), folio);
 	/*
 	 * Take a local copy of the address_space - folio.mapping may be zeroed
@@ -5625,6 +5634,31 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 }
 #endif
 
+/*
+ * May the whole batch be marked dirty?
+ *
+ * Only a shared mapping of a filesystem that tracks dirty state per block says
+ * no. There the page table dirty bits are the only record of which parts of a
+ * large folio were written through the mapping, so pages nobody has stored to
+ * have to stay clean and let the hardware set the bit on the first store.
+ *
+ * Everywhere else nothing ever reads those bits, and on hardware without a
+ * dirty bit leaving them clean costs a fault per page for nothing. That covers
+ * shmem, which has no dirty state below the folio.
+ */
+static bool can_dirty_whole_batch(struct vm_fault *vmf, unsigned int nr,
+				  bool prefault)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	if (!(vmf->flags & FAULT_FLAG_WRITE) || prefault || nr == 1)
+		return true;
+	if (!(vma->vm_flags & VM_SHARED))
+		return true;
+
+	return !vma->vm_file->f_mapping->a_ops->dirty_folio_range;
+}
+
 /**
  * set_pte_range - Set a range of PTEs to point to pages in a folio.
  * @vmf: Fault description.
@@ -5639,6 +5673,7 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	bool prefault = !in_range(vmf->address, addr, nr * PAGE_SIZE);
+	bool dirty_batch = can_dirty_whole_batch(vmf, nr, prefault);
 	pte_t entry;
 
 	flush_icache_pages(vma, page, nr);
@@ -5649,10 +5684,13 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 	else
 		entry = pte_sw_mkyoung(entry);
 
-	if (write)
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	else if (pte_write(entry) && folio_test_dirty(folio))
+	if (write) {
+		if (dirty_batch)
+			entry = pte_mkdirty(entry);
+		entry = maybe_mkwrite(entry, vma);
+	} else if (pte_write(entry) && folio_test_dirty(folio)) {
 		entry = pte_mkdirty(entry);
+	}
 	if (unlikely(vmf_orig_pte_uffd_wp(vmf)))
 		entry = pte_mkuffd(entry);
 	/* copy-on-write page */
@@ -5665,6 +5703,18 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 	}
 	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr);
 
+	/*
+	 * The page the fault was for is about to be stored to, so dirty it
+	 * here rather than leave the store to a second page table walk, or to
+	 * a second fault where the dirty bit is maintained in software.
+	 */
+	if (!dirty_batch) {
+		pte_t *ptep = vmf->pte + ((vmf->address - addr) >> PAGE_SHIFT);
+
+		ptep_set_access_flags(vma, vmf->address, ptep,
+				      pte_mkdirty(ptep_get(ptep)), 1);
+	}
+
 	/* no need to invalidate: a not-present page won't be cached */
 	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr);
 }
-- 
2.54.0

