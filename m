Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57A6C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 16:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjJaQsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 12:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbjJaQsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 12:48:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E8692
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 09:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698770897; x=1730306897;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hT5m1FSbT0kp/4mDAr6dDq012D2iMNhYXRSdlRhmhGk=;
  b=npXfshF/AbAhc3KAJwHJ59wSxotTlV6XZDD9/0dXXpcg3ev1illdwkn2
   ihbK0CuX75yfkNCjKyV829OGCjKwsu71he3VPcKePIpIrQkoGK2Y74CFF
   kG0BHBHSG55oHqwExCSc89RSE6ohBOhjlu5cFB8WfrfphFydS+CbEomE7
   eZcPT372gw13Faj9cX2lblPDt6gEusba6WMTIUIezn58DZJJQkhOfHnRK
   5ezawL4eDqRQI7NhUkRmuyv1QWL7Qw8Gi+Kck8f0WqEpkIP9bo+lqMHpY
   hkU57Rr62ro9qtyPFQAZ66rz47IPv6gS6ZVKQ+ZgpYTn/TmhxwNrZorC/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="6951483"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="6951483"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 09:48:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="795646179"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="795646179"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 31 Oct 2023 09:48:14 -0700
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qxruW-0000He-1O;
        Tue, 31 Oct 2023 16:48:12 +0000
Date:   Wed, 1 Nov 2023 00:47:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christoph Hellwig <hch@lst.de>, djwong@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, realtime-rmap branch] xfs: lock the RT bitmap inode in
 xfs_efi_item_recover
Message-ID: <202311010017.ZOItqKn9-lkp@intel.com>
References: <20231031095038.1559309-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031095038.1559309-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

kernel test robot noticed the following build errors:

[auto build test ERROR on v6.6]
[also build test ERROR on linus/master next-20231031]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/xfs-lock-the-RT-bitmap-inode-in-xfs_efi_item_recover/20231031-175736
base:   v6.6
patch link:    https://lore.kernel.org/r/20231031095038.1559309-1-hch%40lst.de
patch subject: [PATCH, realtime-rmap branch] xfs: lock the RT bitmap inode in xfs_efi_item_recover
config: loongarch-randconfig-002-20231031 (https://download.01.org/0day-ci/archive/20231101/202311010017.ZOItqKn9-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231101/202311010017.ZOItqKn9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311010017.ZOItqKn9-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/xfs/xfs_extfree_item.c: In function 'xfs_efi_item_recover':
>> fs/xfs/xfs_extfree_item.c:707:29: error: implicit declaration of function 'xfs_efi_is_realtime'; did you mean 'xfs_has_realtime'? [-Werror=implicit-function-declaration]
     707 |                         if (xfs_efi_is_realtime(&fake))
         |                             ^~~~~~~~~~~~~~~~~~~
         |                             xfs_has_realtime
>> fs/xfs/xfs_extfree_item.c:708:33: error: implicit declaration of function 'xfs_rtbitmap_lock' [-Werror=implicit-function-declaration]
     708 |                                 xfs_rtbitmap_lock(tp, mp);
         |                                 ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +707 fs/xfs/xfs_extfree_item.c

   653	
   654	/*
   655	 * Process an extent free intent item that was recovered from
   656	 * the log.  We need to free the extents that it describes.
   657	 */
   658	STATIC int
   659	xfs_efi_item_recover(
   660		struct xfs_log_item		*lip,
   661		struct list_head		*capture_list)
   662	{
   663		struct xfs_trans_res		resv;
   664		struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
   665		struct xfs_mount		*mp = lip->li_log->l_mp;
   666		struct xfs_efd_log_item		*efdp;
   667		struct xfs_trans		*tp;
   668		int				i;
   669		int				error = 0;
   670		bool				requeue_only = false;
   671	
   672		/*
   673		 * First check the validity of the extents described by the
   674		 * EFI.  If any are bad, then assume that all are bad and
   675		 * just toss the EFI.
   676		 */
   677		for (i = 0; i < efip->efi_format.efi_nextents; i++) {
   678			if (!xfs_efi_validate_ext(mp,
   679						&efip->efi_format.efi_extents[i])) {
   680				XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
   681						&efip->efi_format,
   682						sizeof(efip->efi_format));
   683				return -EFSCORRUPTED;
   684			}
   685		}
   686	
   687		resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
   688		error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
   689		if (error)
   690			return error;
   691		efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
   692	
   693		for (i = 0; i < efip->efi_format.efi_nextents; i++) {
   694			struct xfs_extent_free_item	fake = {
   695				.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
   696				.xefi_agresv		= XFS_AG_RESV_NONE,
   697			};
   698			struct xfs_extent		*extp;
   699	
   700			extp = &efip->efi_format.efi_extents[i];
   701	
   702			fake.xefi_startblock = extp->ext_start;
   703			fake.xefi_blockcount = extp->ext_len;
   704	
   705			if (!requeue_only) {
   706				xfs_extent_free_get_group(mp, &fake);
 > 707				if (xfs_efi_is_realtime(&fake))
 > 708					xfs_rtbitmap_lock(tp, mp);
   709				error = xfs_trans_free_extent(tp, efdp, &fake);
   710				xfs_extent_free_put_group(&fake);
   711			}
   712	
   713			/*
   714			 * If we can't free the extent without potentially deadlocking,
   715			 * requeue the rest of the extents to a new so that they get
   716			 * run again later with a new transaction context.
   717			 */
   718			if (error == -EAGAIN || requeue_only) {
   719				error = xfs_free_extent_later(tp, fake.xefi_startblock,
   720						fake.xefi_blockcount,
   721						&XFS_RMAP_OINFO_ANY_OWNER,
   722						fake.xefi_agresv);
   723				if (!error) {
   724					requeue_only = true;
   725					continue;
   726				}
   727			}
   728	
   729			if (error == -EFSCORRUPTED)
   730				XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
   731						extp, sizeof(*extp));
   732			if (error)
   733				goto abort_error;
   734	
   735		}
   736	
   737		return xfs_defer_ops_capture_and_commit(tp, capture_list);
   738	
   739	abort_error:
   740		xfs_trans_cancel(tp);
   741		return error;
   742	}
   743	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
