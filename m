Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:26888 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751121AbdBFRzx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 12:55:53 -0500
Subject: [PATCH] mm,x86: native_pud_clear missing on i386 build
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Feb 2017 10:55:52 -0700
Message-ID: <148640375195.69754.3315433724330910314.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: mawilcox@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@linux.intel.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kirill.shutemov@linux.intel.com, jack@suse.com, dan.j.williams@intel.com, linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com, vbabka@suse.cz

Missing dummy function native_pud_clear() for 32bit x86 build caught
by 0-day build.

Fix: a10a1701 mm, x86: add support for PUD-sized transparent hugepages

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/include/asm/pgtable-3level.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index be759ff..50d35e3 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -121,6 +121,10 @@ static inline void native_pmd_clear(pmd_t *pmd)
 	*(tmp + 1) = 0;
 }
 
+static inline void native_pud_clear(pud_t *pudp)
+{
+}
+
 static inline void pud_clear(pud_t *pudp)
 {
 	set_pud(pudp, __pud(0));

