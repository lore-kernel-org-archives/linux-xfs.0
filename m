Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4EFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiDGBJj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiDGBJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:09:39 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C68F17E377
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:07:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 24A0D10E5798;
        Thu,  7 Apr 2022 11:07:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncGcb-00EfB5-TF; Thu, 07 Apr 2022 11:07:37 +1000
Date:   Thu, 7 Apr 2022 11:07:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, kbuild-all@lists.01.org,
        djwong@kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 14/19] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <20220407010737.GD1544202@dread.disaster.area>
References: <20220406061904.595597-15-chandan.babu@oracle.com>
 <202204070218.QyD2PQPx-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202204070218.QyD2PQPx-lkp@intel.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624e395b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8
        a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=7-415B0cAAAA:8
        a=Mhlrj2MWrW3o5Qtx1G0A:9 a=CjuIK1q_8ugA:10 a=YJ_ntbLOlx1v6PCnmBeL:22
        a=AjGcO6oz07-iQ99wixmX:22 a=mmqRlSCDY2ywfjPLJ4af:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 03:03:32AM +0800, kernel test robot wrote:
> Hi Chandan,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on xfs-linux/for-next]
> [also build test WARNING on v5.18-rc1 next-20220406]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220406-174647
> base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220407/202204070218.QyD2PQPx-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://github.com/intel-lab-lkp/linux/commit/28be4fd3f13d4ba2bcedceb8951cd3bfe852cba2
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220406-174647
>         git checkout 28be4fd3f13d4ba2bcedceb8951cd3bfe852cba2
>         # save the config file to linux build tree
>         mkdir build_dir
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash fs/xfs/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> >> fs/xfs/xfs_inode_item_recover.c:209:31: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] di_v3_pad @@     got unsigned long long [usertype] di_v3_pad @@
>    fs/xfs/xfs_inode_item_recover.c:209:31: sparse:     expected restricted __be64 [usertype] di_v3_pad
>    fs/xfs/xfs_inode_item_recover.c:209:31: sparse:     got unsigned long long [usertype] di_v3_pad
> 
> vim +209 fs/xfs/xfs_inode_item_recover.c
> 
>    167	
>    168	STATIC void
>    169	xfs_log_dinode_to_disk(
>    170		struct xfs_log_dinode	*from,
>    171		struct xfs_dinode	*to,
>    172		xfs_lsn_t		lsn)
>    173	{
>    174		to->di_magic = cpu_to_be16(from->di_magic);
>    175		to->di_mode = cpu_to_be16(from->di_mode);
>    176		to->di_version = from->di_version;
>    177		to->di_format = from->di_format;
>    178		to->di_onlink = 0;
>    179		to->di_uid = cpu_to_be32(from->di_uid);
>    180		to->di_gid = cpu_to_be32(from->di_gid);
>    181		to->di_nlink = cpu_to_be32(from->di_nlink);
>    182		to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
>    183		to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
>    184	
>    185		to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
>    186		to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
>    187		to->di_ctime = xfs_log_dinode_to_disk_ts(from, from->di_ctime);
>    188	
>    189		to->di_size = cpu_to_be64(from->di_size);
>    190		to->di_nblocks = cpu_to_be64(from->di_nblocks);
>    191		to->di_extsize = cpu_to_be32(from->di_extsize);
>    192		to->di_forkoff = from->di_forkoff;
>    193		to->di_aformat = from->di_aformat;
>    194		to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
>    195		to->di_dmstate = cpu_to_be16(from->di_dmstate);
>    196		to->di_flags = cpu_to_be16(from->di_flags);
>    197		to->di_gen = cpu_to_be32(from->di_gen);
>    198	
>    199		if (from->di_version == 3) {
>    200			to->di_changecount = cpu_to_be64(from->di_changecount);
>    201			to->di_crtime = xfs_log_dinode_to_disk_ts(from,
>    202								  from->di_crtime);
>    203			to->di_flags2 = cpu_to_be64(from->di_flags2);
>    204			to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>    205			to->di_ino = cpu_to_be64(from->di_ino);
>    206			to->di_lsn = cpu_to_be64(lsn);
>    207			memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>    208			uuid_copy(&to->di_uuid, &from->di_uuid);
>  > 209			to->di_v3_pad = from->di_v3_pad;

Why not just explicitly write zero to the di_v3_pad field?

>    210		} else {
>    211			to->di_flushiter = cpu_to_be16(from->di_flushiter);
>    212			memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));

Same here?

Cheers,

Dave.

Dave Chinner
david@fromorbit.com
