Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F85C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 20:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiDFUth (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 16:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiDFUt1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 16:49:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B61320DB0
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 12:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649271896; x=1680807896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=woJs17ibg5Y9hXfyydhjUHZWLLnbcw6FGkVRqd+e07A=;
  b=kKO6hsWIzKo6Rhlnr0fYGAmSeAfMKhsAOHks/bnwHZNudK8Zb0Lde4eR
   vq0ouHzPF92rjbAt7X8BcQZ5epMK5pVJZd7V6PX6mJUgGOH8pln6CXulO
   Eqy9ZuIQcvJTy1DtI9bZs6UmU82B7rKEnWn4vhA1dsIDluIDwfSsPSgHB
   e0ZEZcZeW/BbAxXlAwdfLyS3u4OP4iatkIp46XkeQCZOOPMcz53pMgZRG
   eIImFKynJ7vkwpyoDg2zhY7LN5puAiGvsC6IOHhcRN3JCX07f02+yoHR4
   nhJzspLhJQeU1lc2Se9cxL06Q4/5Xo3pqnRrXSJXPtBaYnYJPJT1fyxV/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="347575856"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="347575856"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 12:04:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="549679172"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 06 Apr 2022 12:04:29 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncAxA-0004fR-R8;
        Wed, 06 Apr 2022 19:04:28 +0000
Date:   Thu, 7 Apr 2022 03:03:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Chandan Babu R <chandan.babu@oracle.com>,
        djwong@kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 14/19] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <202204070218.QyD2PQPx-lkp@intel.com>
References: <20220406061904.595597-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-15-chandan.babu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on v5.18-rc1 next-20220406]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220406-174647
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220407/202204070218.QyD2PQPx-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/28be4fd3f13d4ba2bcedceb8951cd3bfe852cba2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220406-174647
        git checkout 28be4fd3f13d4ba2bcedceb8951cd3bfe852cba2
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> fs/xfs/xfs_inode_item_recover.c:209:31: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] di_v3_pad @@     got unsigned long long [usertype] di_v3_pad @@
   fs/xfs/xfs_inode_item_recover.c:209:31: sparse:     expected restricted __be64 [usertype] di_v3_pad
   fs/xfs/xfs_inode_item_recover.c:209:31: sparse:     got unsigned long long [usertype] di_v3_pad

vim +209 fs/xfs/xfs_inode_item_recover.c

   167	
   168	STATIC void
   169	xfs_log_dinode_to_disk(
   170		struct xfs_log_dinode	*from,
   171		struct xfs_dinode	*to,
   172		xfs_lsn_t		lsn)
   173	{
   174		to->di_magic = cpu_to_be16(from->di_magic);
   175		to->di_mode = cpu_to_be16(from->di_mode);
   176		to->di_version = from->di_version;
   177		to->di_format = from->di_format;
   178		to->di_onlink = 0;
   179		to->di_uid = cpu_to_be32(from->di_uid);
   180		to->di_gid = cpu_to_be32(from->di_gid);
   181		to->di_nlink = cpu_to_be32(from->di_nlink);
   182		to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
   183		to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
   184	
   185		to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
   186		to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
   187		to->di_ctime = xfs_log_dinode_to_disk_ts(from, from->di_ctime);
   188	
   189		to->di_size = cpu_to_be64(from->di_size);
   190		to->di_nblocks = cpu_to_be64(from->di_nblocks);
   191		to->di_extsize = cpu_to_be32(from->di_extsize);
   192		to->di_forkoff = from->di_forkoff;
   193		to->di_aformat = from->di_aformat;
   194		to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
   195		to->di_dmstate = cpu_to_be16(from->di_dmstate);
   196		to->di_flags = cpu_to_be16(from->di_flags);
   197		to->di_gen = cpu_to_be32(from->di_gen);
   198	
   199		if (from->di_version == 3) {
   200			to->di_changecount = cpu_to_be64(from->di_changecount);
   201			to->di_crtime = xfs_log_dinode_to_disk_ts(from,
   202								  from->di_crtime);
   203			to->di_flags2 = cpu_to_be64(from->di_flags2);
   204			to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
   205			to->di_ino = cpu_to_be64(from->di_ino);
   206			to->di_lsn = cpu_to_be64(lsn);
   207			memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
   208			uuid_copy(&to->di_uuid, &from->di_uuid);
 > 209			to->di_v3_pad = from->di_v3_pad;
   210		} else {
   211			to->di_flushiter = cpu_to_be16(from->di_flushiter);
   212			memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
   213		}
   214	
   215		xfs_log_dinode_to_disk_iext_counters(from, to);
   216	}
   217	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
