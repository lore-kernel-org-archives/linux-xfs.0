Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89614C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 22:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F93A21835
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 22:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJHWLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 18:11:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:8819 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJHWLp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Oct 2019 18:11:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 15:11:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,272,1566889200"; 
   d="scan'208";a="368557465"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 08 Oct 2019 15:11:43 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iHxhn-0000x2-6M; Wed, 09 Oct 2019 06:11:43 +0800
Date:   Wed, 9 Oct 2019 06:10:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     kbuild-all@01.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [xfs-linux:xfs-5.4-fixes 4/7] fs/xfs/xfs_buf.c:354:29: sparse:
 sparse: invalid assignment: |=
Message-ID: <201910090646.aXXtk3B2%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-5.4-fixes
head:   6350744c66a41ac4d044bd083852a5cc20bd5b93
commit: b4d5a0a3dc269e8127f89060cb690a19221fd433 [4/7] xfs: assure zeroed memory buffers for certain kmem allocations
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout b4d5a0a3dc269e8127f89060cb690a19221fd433
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> fs/xfs/xfs_buf.c:354:29: sparse: sparse: invalid assignment: |=
>> fs/xfs/xfs_buf.c:354:29: sparse:    left side has type unsigned int
>> fs/xfs/xfs_buf.c:354:29: sparse:    right side has type restricted xfs_km_flags_t
>> fs/xfs/xfs_buf.c:367:44: sparse: sparse: restricted xfs_km_flags_t degrades to integer
>> fs/xfs/xfs_buf.c:367:52: sparse: sparse: incorrect type in argument 3 (different base types) @@    expected restricted xfs_km_flags_t [usertype] flags @@    got  [usertype] flags @@
>> fs/xfs/xfs_buf.c:367:52: sparse:    expected restricted xfs_km_flags_t [usertype] flags
>> fs/xfs/xfs_buf.c:367:52: sparse:    got unsigned int

vim +354 fs/xfs/xfs_buf.c

   333	
   334	/*
   335	 * Allocates all the pages for buffer in question and builds it's page list.
   336	 */
   337	STATIC int
   338	xfs_buf_allocate_memory(
   339		xfs_buf_t		*bp,
   340		uint			flags)
   341	{
   342		size_t			size;
   343		size_t			nbytes, offset;
   344		gfp_t			gfp_mask = xb_to_gfp(flags);
   345		unsigned short		page_count, i;
   346		xfs_off_t		start, end;
   347		int			error;
   348		uint			kmflag_mask = 0;
   349	
   350		/*
   351		 * assure zeroed buffer for non-read cases.
   352		 */
   353		if (!(flags & XBF_READ)) {
 > 354			kmflag_mask |= KM_ZERO;
   355			gfp_mask |= __GFP_ZERO;
   356		}
   357	
   358		/*
   359		 * for buffers that are contained within a single page, just allocate
   360		 * the memory from the heap - there's no need for the complexity of
   361		 * page arrays to keep allocation down to order 0.
   362		 */
   363		size = BBTOB(bp->b_length);
   364		if (size < PAGE_SIZE) {
   365			int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
   366			bp->b_addr = kmem_alloc_io(size, align_mask,
 > 367						   KM_NOFS | kmflag_mask);
   368			if (!bp->b_addr) {
   369				/* low memory - use alloc_page loop instead */
   370				goto use_alloc_page;
   371			}
   372	
   373			if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
   374			    ((unsigned long)bp->b_addr & PAGE_MASK)) {
   375				/* b_addr spans two pages - use alloc_page instead */
   376				kmem_free(bp->b_addr);
   377				bp->b_addr = NULL;
   378				goto use_alloc_page;
   379			}
   380			bp->b_offset = offset_in_page(bp->b_addr);
   381			bp->b_pages = bp->b_page_array;
   382			bp->b_pages[0] = kmem_to_page(bp->b_addr);
   383			bp->b_page_count = 1;
   384			bp->b_flags |= _XBF_KMEM;
   385			return 0;
   386		}
   387	
   388	use_alloc_page:
   389		start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
   390		end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
   391									>> PAGE_SHIFT;
   392		page_count = end - start;
   393		error = _xfs_buf_get_pages(bp, page_count);
   394		if (unlikely(error))
   395			return error;
   396	
   397		offset = bp->b_offset;
   398		bp->b_flags |= _XBF_PAGES;
   399	
   400		for (i = 0; i < bp->b_page_count; i++) {
   401			struct page	*page;
   402			uint		retries = 0;
   403	retry:
   404			page = alloc_page(gfp_mask);
   405			if (unlikely(page == NULL)) {
   406				if (flags & XBF_READ_AHEAD) {
   407					bp->b_page_count = i;
   408					error = -ENOMEM;
   409					goto out_free_pages;
   410				}
   411	
   412				/*
   413				 * This could deadlock.
   414				 *
   415				 * But until all the XFS lowlevel code is revamped to
   416				 * handle buffer allocation failures we can't do much.
   417				 */
   418				if (!(++retries % 100))
   419					xfs_err(NULL,
   420			"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
   421						current->comm, current->pid,
   422						__func__, gfp_mask);
   423	
   424				XFS_STATS_INC(bp->b_mount, xb_page_retries);
   425				congestion_wait(BLK_RW_ASYNC, HZ/50);
   426				goto retry;
   427			}
   428	
   429			XFS_STATS_INC(bp->b_mount, xb_page_found);
   430	
   431			nbytes = min_t(size_t, size, PAGE_SIZE - offset);
   432			size -= nbytes;
   433			bp->b_pages[i] = page;
   434			offset = 0;
   435		}
   436		return 0;
   437	
   438	out_free_pages:
   439		for (i = 0; i < bp->b_page_count; i++)
   440			__free_page(bp->b_pages[i]);
   441		bp->b_flags &= ~_XBF_PAGES;
   442		return error;
   443	}
   444	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
