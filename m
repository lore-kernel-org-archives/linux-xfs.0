Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F87ECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 16:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiH3QiN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 12:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiH3QiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 12:38:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA022DA3E9
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 09:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661877490; x=1693413490;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HWROR/yqexED/x9xlNquX5DV6EHDziaMmdq9tBE/fwk=;
  b=kaOjGMj2FdC5UhzfdcoR2K2z9Y7+ZKr5yZiViIozVwqmiYtNmKzzrpUs
   jxNXM5+LRhb+RL86OIkeQqe9Sw7w+4JGcQEe1WXmmZKLQneEYGoHLD6Hj
   y1JKIDEak0XdUcqwaDhXnDEqJrwe6Yq4lwZb+VPNhNXzdxMqK1Jk7ttwq
   83lRnHlhh/spHCp8SL+7OfUH0nDKsQPUdsb2VuFbtN9g/wxqMRiWl+3ab
   TOAfhkzuPI01mB1HQT1lhpmW6z01BUbLrQRuqn7WF0UqBpEPCJ1kxzIix
   HeWHN13BNd/FHh7ET+R4Gfm5vLclYUKxJLAHFvFghzRs0G0QipKjHjuZp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="292811829"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="292811829"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 09:31:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="644896662"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 30 Aug 2022 09:31:24 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oT496-0000PD-0R;
        Tue, 30 Aug 2022 16:31:24 +0000
Date:   Wed, 31 Aug 2022 00:31:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v2] xfs: Add new name to attri/d
Message-ID: <202208310018.1wKCQHzH-lkp@intel.com>
References: <20220829213613.1318499-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829213613.1318499-1-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Allison,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on v6.0-rc3]
[also build test ERROR on linus/master next-20220830]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Allison-Henderson/xfs-Add-new-name-to-attri-d/20220830-053816
base:    b90cb1053190353cc30f0fef0ef1f378ccc063c5
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220831/202208310018.1wKCQHzH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/68f33e68647f25b811773b237669cf26e6b43382
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Allison-Henderson/xfs-Add-new-name-to-attri-d/20220830-053816
        git checkout 68f33e68647f25b811773b237669cf26e6b43382
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/entry/vdso/ fs/xfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/xfs/xfs_attr_item.c: In function 'xlog_recover_attri_commit_pass2':
   fs/xfs/xfs_attr_item.c:824:45: warning: passing argument 2 of 'xfs_attr_namecheck' makes integer from pointer without a cast [-Wint-conversion]
     824 |                 if (!xfs_attr_namecheck(mp, attr_nname,
         |                                             ^~~~~~~~~~
         |                                             |
         |                                             const void *
   In file included from fs/xfs/xfs_attr_item.c:22:
   fs/xfs/libxfs/xfs_attr.h:550:50: note: expected 'size_t' {aka 'long unsigned int'} but argument is of type 'const void *'
     550 | bool xfs_attr_namecheck(const void *name, size_t length);
         |                                           ~~~~~~~^~~~~~
>> fs/xfs/xfs_attr_item.c:824:22: error: too many arguments to function 'xfs_attr_namecheck'
     824 |                 if (!xfs_attr_namecheck(mp, attr_nname,
         |                      ^~~~~~~~~~~~~~~~~~
   In file included from fs/xfs/xfs_attr_item.c:22:
   fs/xfs/libxfs/xfs_attr.h:550:6: note: declared here
     550 | bool xfs_attr_namecheck(const void *name, size_t length);
         |      ^~~~~~~~~~~~~~~~~~


vim +/xfs_attr_namecheck +824 fs/xfs/xfs_attr_item.c

   756	
   757	STATIC int
   758	xlog_recover_attri_commit_pass2(
   759		struct xlog                     *log,
   760		struct list_head		*buffer_list,
   761		struct xlog_recover_item        *item,
   762		xfs_lsn_t                       lsn)
   763	{
   764		struct xfs_mount                *mp = log->l_mp;
   765		struct xfs_attri_log_item       *attrip;
   766		struct xfs_attri_log_format     *attri_formatp;
   767		struct xfs_attri_log_nameval	*nv;
   768		const void			*attr_value = NULL;
   769		const void			*attr_name;
   770		const void			*attr_nname = NULL;
   771		int				i = 0;
   772		int                             op, error = 0;
   773	
   774		if (item->ri_total == 0) {
   775			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
   776			return -EFSCORRUPTED;
   777		}
   778	
   779		attri_formatp = item->ri_buf[i].i_addr;
   780		i++;
   781	
   782		op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
   783		switch (op) {
   784		case XFS_ATTRI_OP_FLAGS_SET:
   785		case XFS_ATTRI_OP_FLAGS_REPLACE:
   786			if (item->ri_total != 3)
   787				error = -EFSCORRUPTED;
   788			break;
   789		case XFS_ATTRI_OP_FLAGS_REMOVE:
   790			if (item->ri_total != 2)
   791				error = -EFSCORRUPTED;
   792			break;
   793		case XFS_ATTRI_OP_FLAGS_NVREPLACE:
   794			if (item->ri_total != 4)
   795				error = -EFSCORRUPTED;
   796			break;
   797		default:
   798			error = -EFSCORRUPTED;
   799		}
   800	
   801		if (error) {
   802			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
   803			return error;
   804		}
   805	
   806		/* Validate xfs_attri_log_format before the large memory allocation */
   807		if (!xfs_attri_validate(mp, attri_formatp)) {
   808			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
   809			return -EFSCORRUPTED;
   810		}
   811	
   812		attr_name = item->ri_buf[i].i_addr;
   813		i++;
   814	
   815		if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
   816			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
   817			return -EFSCORRUPTED;
   818		}
   819	
   820		if (attri_formatp->alfi_nname_len) {
   821			attr_nname = item->ri_buf[i].i_addr;
   822			i++;
   823	
 > 824			if (!xfs_attr_namecheck(mp, attr_nname,
   825					attri_formatp->alfi_nname_len,
   826					attri_formatp->alfi_attr_filter)) {
   827				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
   828				return -EFSCORRUPTED;
   829			}
   830		}
   831	
   832		if (attri_formatp->alfi_value_len)
   833			attr_value = item->ri_buf[i].i_addr;
   834	
   835		/*
   836		 * Memory alloc failure will cause replay to abort.  We attach the
   837		 * name/value buffer to the recovered incore log item and drop our
   838		 * reference.
   839		 */
   840		nv = xfs_attri_log_nameval_alloc(attr_name,
   841				attri_formatp->alfi_name_len, attr_nname,
   842				attri_formatp->alfi_nname_len, attr_value,
   843				attri_formatp->alfi_value_len);
   844		if (!nv)
   845			return -ENOMEM;
   846	
   847		attrip = xfs_attri_init(mp, nv);
   848		error = xfs_attri_copy_format(&item->ri_buf[0], &attrip->attri_format);
   849		if (error)
   850			goto out;
   851	
   852		/*
   853		 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
   854		 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
   855		 * directly and drop the ATTRI reference. Note that
   856		 * xfs_trans_ail_update() drops the AIL lock.
   857		 */
   858		xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
   859		xfs_attri_release(attrip);
   860		xfs_attri_log_nameval_put(nv);
   861		return 0;
   862	out:
   863		xfs_attri_item_free(attrip);
   864		xfs_attri_log_nameval_put(nv);
   865		return error;
   866	}
   867	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
