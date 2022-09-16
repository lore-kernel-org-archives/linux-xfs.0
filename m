Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4FCC6FA91
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Sep 2022 03:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiIPDgl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Sep 2022 23:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiIPDgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Sep 2022 23:36:18 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F8B89809;
        Thu, 15 Sep 2022 20:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299373; x=1694835373;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfzx5y9B9XHcY/WNGZvpd9adYJw1q+hyjxJ0sZQS8JA=;
  b=eWigBSljAb7z3Tke61JlKS+I5LMhsoVPUuVMsyfbmv1wmpceppEtGHnl
   Ef8T/rnnqSilGFUJC5+qCkeFdvJF5fxFxNq9XIbxk+D8YiRKY9i/AxWn8
   MIBXf6yFYEJfARh1927+PB1T43ejxqmHfeiCXYMNOFO8sG5wMhMpHPqyq
   F3Cw0AmIrRLKzsHoowMreQ/0CVTVCVWaTHAzG0VWvpXVf873ywPrkOPSK
   vX2FMlyhFunJuU9iyZWa8cZxocZ+hkmRdO5+yVrKs6+ce13H0/5qzynxU
   la0rMnC0xCCCBilPJ2ZDZMiLWwxFVOPpGp2tYt2cOv698GODiAZPxUQc3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="325170420"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="325170420"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="648099963"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:13 -0700
Subject: [PATCH v2 11/18] devdax: Minor warning fixups
From:   Dan Williams <dan.j.williams@intel.com>
To:     akpm@linux-foundation.org
Cc:     hch@lst.de, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org
Date:   Thu, 15 Sep 2022 20:36:13 -0700
Message-ID: <166329937313.2786261.6805174536617254263.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix a missing prototype warning for dev_dax_probe(), and fix
dax_holder() comment block format.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax-private.h |    1 +
 drivers/dax/super.c       |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 1c974b7caae6..202cafd836e8 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -87,6 +87,7 @@ static inline struct dax_mapping *to_dax_mapping(struct device *dev)
 }
 
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
+int dev_dax_probe(struct dev_dax *dev_dax);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline bool dax_align_valid(unsigned long align)
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9b5e2a5eb0ae..4909ad945a49 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -475,7 +475,7 @@ EXPORT_SYMBOL_GPL(put_dax);
 /**
  * dax_holder() - obtain the holder of a dax device
  * @dax_dev: a dax_device instance
-
+ *
  * Return: the holder's data which represents the holder if registered,
  * otherwize NULL.
  */

