Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10931 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932087AbdJJO4c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 10:56:32 -0400
Subject: [PATCH v8 12/14] iommu/vt-d: use iommu_num_sg_pages
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Oct 2017 07:50:05 -0700
Message-ID: <150764700544.16882.8780240398561523090.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Ashok Raj <ashok.raj@intel.com>, linux-rdma@vger.kernel.org, linux-api@vger.kernel.org, Joerg Roedel <joro@8bytes.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

Use the common helper for accounting the size of the IOVA range for a
scatterlist so that iommu and dma apis agree on the size of a
scatterlist. This is in support for using iommu_unmap() in advance of
dma_unmap_sg() to invalidate an io-mapping in advance of the IOVA range
being deallocated. MAP_DIRECT needs this functionality for force
revoking RDMA access to a DAX mapping when userspace fails to respond to
within a lease break timeout period.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/iommu/intel-iommu.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f3f4939cebad..94a5fbe62fb8 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3785,14 +3785,9 @@ static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			   unsigned long attrs)
 {
 	dma_addr_t startaddr = sg_dma_address(sglist) & PAGE_MASK;
-	unsigned long nrpages = 0;
-	struct scatterlist *sg;
-	int i;
-
-	for_each_sg(sglist, sg, nelems, i) {
-		nrpages += aligned_nrpages(sg_dma_address(sg), sg_dma_len(sg));
-	}
+	unsigned long nrpages;
 
+	nrpages = iommu_sg_num_pages(dev, sglist, nelems);
 	intel_unmap(dev, startaddr, nrpages << VTD_PAGE_SHIFT);
 }
 
@@ -3813,14 +3808,12 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 static int intel_map_sg(struct device *dev, struct scatterlist *sglist, int nelems,
 			enum dma_data_direction dir, unsigned long attrs)
 {
-	int i;
 	struct dmar_domain *domain;
 	size_t size = 0;
 	int prot = 0;
 	unsigned long iova_pfn;
 	int ret;
-	struct scatterlist *sg;
-	unsigned long start_vpfn;
+	unsigned long start_vpfn, npages;
 	struct intel_iommu *iommu;
 
 	BUG_ON(dir == DMA_NONE);
@@ -3833,11 +3826,9 @@ static int intel_map_sg(struct device *dev, struct scatterlist *sglist, int nele
 
 	iommu = domain_get_iommu(domain);
 
-	for_each_sg(sglist, sg, nelems, i)
-		size += aligned_nrpages(sg->offset, sg->length);
+	npages = iommu_sg_num_pages(dev, sglist, nelems);
 
-	iova_pfn = intel_alloc_iova(dev, domain, dma_to_mm_pfn(size),
-				*dev->dma_mask);
+	iova_pfn = intel_alloc_iova(dev, domain, npages, *dev->dma_mask);
 	if (!iova_pfn) {
 		sglist->dma_length = 0;
 		return 0;

