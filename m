Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53390 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750791AbdBOUbJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 15:31:09 -0500
Subject: [PATCH] mm,x86: fix SMP x86 32bit build for native_pud_clear()
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 15 Feb 2017 13:31:08 -0700
Message-ID: <148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: keescook@google.com, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@linux.intel.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kirill.shutemov@linux.intel.com, jack@suse.com, dan.j.williams@intel.com, linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com, vbabka@suse.cz, alexander.kapshuk@gmail.com

The fix introduced by e4decc90 to fix the UP case for 32bit x86, however
that broke the SMP case that was working previously. Add ifdef so the dummy
function only show up for 32bit UP case only.

Fix: e4decc90 mm,x86: native_pud_clear missing on i386 build

Reported-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/include/asm/pgtable-3level.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 50d35e3..8f50fb3 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -121,9 +121,11 @@ static inline void native_pmd_clear(pmd_t *pmd)
 	*(tmp + 1) = 0;
 }
 
+#ifndef CONFIG_SMP
 static inline void native_pud_clear(pud_t *pudp)
 {
 }
+#endif
 
 static inline void pud_clear(pud_t *pudp)
 {

