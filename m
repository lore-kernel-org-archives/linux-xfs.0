Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86116C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 22:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiFUW7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiFUW7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 18:59:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2DBF1BEA1
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jun 2022 15:59:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6F48610E87F4;
        Wed, 22 Jun 2022 08:59:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o3mqM-009TtF-6p; Wed, 22 Jun 2022 08:59:34 +1000
Date:   Wed, 22 Jun 2022 08:59:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: Re: [linux-next:master] BUILD REGRESSION
 34d1d36073ea4d4c532e8c8345627a9702be799e
Message-ID: <20220621225934.GR227878@dread.disaster.area>
References: <62b241d3.CmOrZi26Vac8nqGm%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62b241d3.CmOrZi26Vac8nqGm%lkp@intel.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b24d59
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
        a=7-415B0cAAAA:8 a=TcNIDo5RizWzpbXBp64A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[trimmed cc list]

On Wed, Jun 22, 2022 at 06:10:27AM +0800, kernel test robot wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 34d1d36073ea4d4c532e8c8345627a9702be799e  Add linux-next specific files for 20220621
> 
> Error/Warning reports:
> 
> https://lore.kernel.org/linux-mm/202206212029.Yr5m7Cd3-lkp@intel.com
> https://lore.kernel.org/linux-mm/202206212033.3lgl72Fw-lkp@intel.com

SEP. (Networking)

> https://lore.kernel.org/lkml/202206071511.FI7WLdZo-lkp@intel.com

The XFS warnings are in on this code:

  1258	#ifdef CONFIG_FS_DAX
  1259	int
> 1260	xfs_dax_fault(
  1261		struct vm_fault		*vmf,
  1262		enum page_entry_size	pe_size,
  1263		bool			write_fault,
  1264		pfn_t			*pfn)
  1265	{
> 1266		return dax_iomap_fault(vmf, pe_size, pfn, NULL,
  1267				(write_fault && !vmf->cow_page) ?
  1268					&xfs_dax_write_iomap_ops :
  1269					&xfs_read_iomap_ops);
  1270	}
  1271	#else
  1272	int
  1273	xfs_dax_fault(
  1274		struct vm_fault		*vmf,
  1275		enum page_entry_size	pe_size,
  1276		bool			write_fault,
  1277		pfn_t			*pfn)
  1278	{
  1279		return 0;
  1280	}
  1281	#endif

As it's not declared static and the return type should be vm_fault_t.

This code is not in the XFS tree, so I have to assume that it is in
Andrew's tree and needs fixing there.

But I don't think just changing 'int' to 'static vm_fault_t' is
right. This CONFIG_FS_DAX wrapper just smells wrong. That is, the
call to xfs_dax_fault() should be completely elided by the compiler
if CONFIG_FS_DAX is not set because it is only called from inside a
if (IS_DAX(inode))  {...} context.  IS_DAX(inode) will always
evaluate as zero when CONFIG_FS_DAX is not set, and so
xfs_dax_fault() becomes unreacheable and gets elided.

That's the way the current code in 5.19-rc3 works, and has for
years. We can call dax_iomap_fault() directly as long as it is only
in a (IS_DAX(inode) == true) conditional context. We do this all
over the place with fs-dax code - we did quite a bit of work to set
up the FSDAX code to avoid needing config conditional code in the
filesystems like the above wrappers. I can't see anything that has
changes this, so I'm at a loss to explain why this wrapper is needed
in the current linux-next tree...

I think these wrappers should go away (needing them would be a
potentially serious regression!) and be reverted to the
existing 5.19-rc3 code, not just be patched to make the prototypes
correct.

Ruan, Andrew, can you two work together to massage the changes
that are pending in Andrew's tree to get them fixed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
