Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:61392 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752594AbeEOXAn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 May 2018 19:00:43 -0400
Date: Wed, 16 May 2018 06:59:58 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [xfs-linux:xfs-4.18-merge 66/85] fs/xfs/xfs_qm.c:639:39: sparse:
 cast to restricted __be32
Message-ID: <201805160657.uyigUTOB%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: kbuild-all@01.org, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-4.18-merge
head:   68932e193b273d94e4291d70301e42c3658d1805
commit: a919a9fe5506389209d5e0759d8965d966802162 [66/85] xfs: refactor quota limits initialization
reproduce:
        # apt-get install sparse
        git checkout a919a9fe5506389209d5e0759d8965d966802162
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/xfs/xfs_qm.c:639:39: sparse: cast to restricted __be32
>> fs/xfs/xfs_qm.c:639:39: sparse: cast from restricted __be16
>> fs/xfs/xfs_qm.c:639:39: sparse: cast to restricted __be32
>> fs/xfs/xfs_qm.c:639:39: sparse: cast from restricted __be16
>> fs/xfs/xfs_qm.c:639:39: sparse: cast to restricted __be32
>> fs/xfs/xfs_qm.c:639:39: sparse: cast from restricted __be16
>> fs/xfs/xfs_qm.c:639:39: sparse: cast to restricted __be32
>> fs/xfs/xfs_qm.c:639:39: sparse: cast from restricted __be16
>> fs/xfs/xfs_qm.c:639:39: sparse: cast to restricted __be32
>> fs/xfs/xfs_qm.c:639:39: sparse: cast from restricted __be16
>> fs/xfs/xfs_qm.c:639:39: sparse: cast to restricted __be32
>> fs/xfs/xfs_qm.c:639:39: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:641:39: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:641:39: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:641:39: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:641:39: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:641:39: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:641:39: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:641:39: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:641:39: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:641:39: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:641:39: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:641:39: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:641:39: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:643:41: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:643:41: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:643:41: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:643:41: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:643:41: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:643:41: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:643:41: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:643:41: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:643:41: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:643:41: sparse: cast from restricted __be16
   fs/xfs/xfs_qm.c:643:41: sparse: cast to restricted __be32
   fs/xfs/xfs_qm.c:643:41: sparse: cast from restricted __be16

vim +639 fs/xfs/xfs_qm.c

   586	
   587	/* Initialize quota time limits from the root dquot. */
   588	static void
   589	xfs_qm_init_timelimits(
   590		struct xfs_mount	*mp,
   591		struct xfs_quotainfo	*qinf)
   592	{
   593		struct xfs_disk_dquot	*ddqp;
   594		struct xfs_dquot	*dqp;
   595		uint			type;
   596		int			error;
   597	
   598		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
   599		qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
   600		qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
   601		qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
   602		qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
   603		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
   604	
   605		/*
   606		 * We try to get the limits from the superuser's limits fields.
   607		 * This is quite hacky, but it is standard quota practice.
   608		 *
   609		 * Since we may not have done a quotacheck by this point, just read
   610		 * the dquot without attaching it to any hashtables or lists.
   611		 *
   612		 * Timers and warnings are globally set by the first timer found in
   613		 * user/group/proj quota types, otherwise a default value is used.
   614		 * This should be split into different fields per quota type.
   615		 */
   616		if (XFS_IS_UQUOTA_RUNNING(mp))
   617			type = XFS_DQ_USER;
   618		else if (XFS_IS_GQUOTA_RUNNING(mp))
   619			type = XFS_DQ_GROUP;
   620		else
   621			type = XFS_DQ_PROJ;
   622		error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
   623		if (error)
   624			return;
   625	
   626		ddqp = &dqp->q_core;
   627		/*
   628		 * The warnings and timers set the grace period given to
   629		 * a user or group before he or she can not perform any
   630		 * more writing. If it is zero, a default is used.
   631		 */
   632		if (ddqp->d_btimer)
   633			qinf->qi_btimelimit = be32_to_cpu(ddqp->d_btimer);
   634		if (ddqp->d_itimer)
   635			qinf->qi_itimelimit = be32_to_cpu(ddqp->d_itimer);
   636		if (ddqp->d_rtbtimer)
   637			qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
   638		if (ddqp->d_bwarns)
 > 639			qinf->qi_bwarnlimit = be32_to_cpu(ddqp->d_bwarns);
   640		if (ddqp->d_iwarns)
   641			qinf->qi_iwarnlimit = be32_to_cpu(ddqp->d_iwarns);
   642		if (ddqp->d_rtbwarns)
   643			qinf->qi_rtbwarnlimit = be32_to_cpu(ddqp->d_rtbwarns);
   644	
   645		xfs_qm_dqdestroy(dqp);
   646	}
   647	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
