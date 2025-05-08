Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BB32750FB
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746718336; cv=none; b=PGA64gdDKh+vx5jDFULPs+6lOGmuPdQ//02kMo01yGDWm3nuINuF5lMiBvPyXUJVu3b5R0P7/55WIP3tqZSaOZAcO+MOkwJtdNmzUZgMWtKpDM51tJFaQms2fKgjKU8IHVhb5jqL8wMcnaKe4EmdBu2GNLlGdZH9k+85NxX5wu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746718336; c=relaxed/simple;
	bh=dgmSjve+T9YUy/HyNcRbUo7hV9b+rP5PTdK6QsEJJOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2nxX3aq9iuXekzcFmrLpTEVmFThUUz+mSUIu0yUgfk8msk+DxjHddVdlM2GWnIVtXUrzi8WsXrdsdGXB+6xl2cXx7REMcGeZTYYFvJ6bBh7T2fQUELy6ViYm7zY6ISuoPN08zHkA3SFnZqpYXqFsHCnyIkBuoYlYsxmWq6mv5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ggZMb6yW; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ggZMb6yW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746718335; x=1778254335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dgmSjve+T9YUy/HyNcRbUo7hV9b+rP5PTdK6QsEJJOE=;
  b=ggZMb6yWHfZegcGPjYQZc5O6b+dkXVT+J4Gqw8KQ1Y27wNMZFfOXd0x3
   IPPMAGf96MmZRFanzujIgCxTBrtkPHxTFWnrDZOv+bHqBZ6zkGb3nWw1z
   AaaMiUOIDAE9ePgkMRhbayh+BMG3YHSkcnJDQDbXra3Sa5aFvSBbA7fjd
   vyorq9FGR7brqRLdmfrzP3pnpfO0h3pn20SRKjQ76xk2mwkrc0sBv2f3f
   fnqwlKF5elNiVv9mzaAQgYfsq3o7ykeviWmplvAJMZ9p8E1YcD+ha4rtt
   NhHjU136FACSSoB5v94coamPXZ0+8ck/K3FWtS4pazShYctCu6oK9+w3L
   w==;
X-CSE-ConnectionGUID: MymKC2BbRpWlc2DkO0fL6Q==
X-CSE-MsgGUID: IwW+5+ZpRlWmaW3x0lKx3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58721702"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58721702"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:32:15 -0700
X-CSE-ConnectionGUID: ugbvnUR4RFOUypKdPfydFw==
X-CSE-MsgGUID: +bYKlCpiSVWfXGPn1NPVhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137257443"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 08 May 2025 08:32:14 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uD3EI-000B6F-2q;
	Thu, 08 May 2025 15:32:10 +0000
Date: Thu, 8 May 2025 23:32:00 +0800
From: kernel test robot <lkp@intel.com>
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/2] XFS: Fix comment on xfs_trans_ail_update_bulk()
Message-ID: <202505082325.eX1iuPLZ-lkp@intel.com>
References: <20250507095239.477105-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507095239.477105-3-cem@kernel.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.15-rc5 next-20250508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/cem-kernel-org/Fix-comment-on-xfs_ail_delete/20250507-175334
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20250507095239.477105-3-cem%40kernel.org
patch subject: [PATCH 2/2] XFS: Fix comment on xfs_trans_ail_update_bulk()
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250508/202505082325.eX1iuPLZ-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250508/202505082325.eX1iuPLZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505082325.eX1iuPLZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/xfs/xfs_trans_ail.c: In function 'xfs_trans_ail_update_bulk':
>> fs/xfs/xfs_trans_ail.c:822:27: error: 'check' undeclared (first use in this function)
     822 |                         * check if we really need to move the item */
         |                           ^~~~~
   fs/xfs/xfs_trans_ail.c:822:27: note: each undeclared identifier is reported only once for each function it appears in
>> fs/xfs/xfs_trans_ail.c:822:32: error: expected ';' before 'if'
     822 |                         * check if we really need to move the item */
         |                                ^~~
         |                                ;


vim +/check +822 fs/xfs/xfs_trans_ail.c

   778	
   779	/*
   780	 * xfs_trans_ail_update_bulk - bulk AIL insertion operation.
   781	 *
   782	 * @xfs_trans_ail_update_bulk takes an array of log items that all need to be
   783	 * positioned at the same LSN in the AIL. If an item is not in the AIL, it will
   784	 * be added. Otherwise, it will be repositioned by removing it and re-adding
   785	 * it to the AIL.
   786	 *
   787	 * If we move the first item in the AIL, update the log tail to match the new
   788	 * minimum LSN in the AIL.
   789	 *
   790	 * This function should be called with the AIL lock held.
   791	 *
   792	 * To optimise the insert operation, we add all items to a temporary list, then
   793	 * splice this list into the correct position in the AIL.
   794	 *
   795	 * Items that are already in the AIL are first deleted from their current location
   796	 * before being added to the temporary list.
   797	 *
   798	 * This avoids needing to do an insert operation on every item.
   799	 *
   800	 * The AIL lock is dropped by xfs_ail_update_finish() before returning to
   801	 * the caller.
   802	 */
   803	void
   804	xfs_trans_ail_update_bulk(
   805		struct xfs_ail		*ailp,
   806		struct xfs_ail_cursor	*cur,
   807		struct xfs_log_item	**log_items,
   808		int			nr_items,
   809		xfs_lsn_t		lsn) __releases(ailp->ail_lock)
   810	{
   811		struct xfs_log_item	*mlip;
   812		xfs_lsn_t		tail_lsn = 0;
   813		int			i;
   814		LIST_HEAD(tmp);
   815	
   816		ASSERT(nr_items > 0);		/* Not required, but true. */
   817		mlip = xfs_ail_min(ailp);
   818	
   819		for (i = 0; i < nr_items; i++) {
   820			struct xfs_log_item *lip = log_items[i];
   821			if (test_and_set_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 > 822				* check if we really need to move the item */
   823				if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
   824					continue;
   825	
   826				trace_xfs_ail_move(lip, lip->li_lsn, lsn);
   827				if (mlip == lip && !tail_lsn)
   828					tail_lsn = lip->li_lsn;
   829	
   830				xfs_ail_delete(ailp, lip);
   831			} else {
   832				trace_xfs_ail_insert(lip, 0, lsn);
   833			}
   834			lip->li_lsn = lsn;
   835			list_add_tail(&lip->li_ail, &tmp);
   836		}
   837	
   838		if (!list_empty(&tmp))
   839			xfs_ail_splice(ailp, cur, &tmp, lsn);
   840	
   841		/*
   842		 * If this is the first insert, wake up the push daemon so it can
   843		 * actively scan for items to push. We also need to do a log tail
   844		 * LSN update to ensure that it is correctly tracked by the log, so
   845		 * set the tail_lsn to NULLCOMMITLSN so that xfs_ail_update_finish()
   846		 * will see that the tail lsn has changed and will update the tail
   847		 * appropriately.
   848		 */
   849		if (!mlip) {
   850			wake_up_process(ailp->ail_task);
   851			tail_lsn = NULLCOMMITLSN;
   852		}
   853	
   854		xfs_ail_update_finish(ailp, tail_lsn);
   855	}
   856	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
