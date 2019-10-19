Return-Path: <SRS0=7yvF=YM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A69CA9EAB
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 20:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E17621925
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 20:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfJSUH7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Oct 2019 16:07:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:13360 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfJSUH6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Oct 2019 16:07:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Oct 2019 13:07:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,316,1566889200"; 
   d="scan'208";a="195765293"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 19 Oct 2019 13:07:55 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iLv11-0009Yw-0F; Sun, 20 Oct 2019 04:07:55 +0800
Date:   Sun, 20 Oct 2019 04:07:34 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kbuild-all@lists.01.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [xfs-linux:xfs-for-next 29/47] fs/xfs/libxfs/xfs_alloc.c:1170:41:
 sparse: sparse: Using plain integer as NULL pointer
Message-ID: <201910200432.0NRV75fO%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-for-next
head:   722da94850334abacce34e63c670dcd9c79cad52
commit: aa056ce9548079d6b65c8b4a0d319eadff7dcd1b [29/47] xfs: introduce allocation cursor data structure
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        git checkout aa056ce9548079d6b65c8b4a0d319eadff7dcd1b
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> fs/xfs/libxfs/xfs_alloc.c:1170:41: sparse: sparse: Using plain integer as NULL pointer

vim +1170 fs/xfs/libxfs/xfs_alloc.c

  1159	
  1160	/*
  1161	 * Allocate a variable extent near bno in the allocation group agno.
  1162	 * Extent's length (returned in len) will be between minlen and maxlen,
  1163	 * and of the form k * prod + mod unless there's nothing that large.
  1164	 * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
  1165	 */
  1166	STATIC int
  1167	xfs_alloc_ag_vextent_near(
  1168		struct xfs_alloc_arg	*args)
  1169	{
> 1170		struct xfs_alloc_cur	acur = {0,};
  1171		struct xfs_btree_cur	*bno_cur;
  1172		xfs_agblock_t	gtbno;		/* start bno of right side entry */
  1173		xfs_agblock_t	gtbnoa;		/* aligned ... */
  1174		xfs_extlen_t	gtdiff;		/* difference to right side entry */
  1175		xfs_extlen_t	gtlen;		/* length of right side entry */
  1176		xfs_extlen_t	gtlena;		/* aligned ... */
  1177		xfs_agblock_t	gtnew;		/* useful start bno of right side */
  1178		int		error;		/* error code */
  1179		int		i;		/* result code, temporary */
  1180		int		j;		/* result code, temporary */
  1181		xfs_agblock_t	ltbno;		/* start bno of left side entry */
  1182		xfs_agblock_t	ltbnoa;		/* aligned ... */
  1183		xfs_extlen_t	ltdiff;		/* difference to left side entry */
  1184		xfs_extlen_t	ltlen;		/* length of left side entry */
  1185		xfs_extlen_t	ltlena;		/* aligned ... */
  1186		xfs_agblock_t	ltnew;		/* useful start bno of left side */
  1187		xfs_extlen_t	rlen;		/* length of returned extent */
  1188		bool		busy;
  1189		unsigned	busy_gen;
  1190	#ifdef DEBUG
  1191		/*
  1192		 * Randomly don't execute the first algorithm.
  1193		 */
  1194		int		dofirst;	/* set to do first algorithm */
  1195	
  1196		dofirst = prandom_u32() & 1;
  1197	#endif
  1198	
  1199		/* handle unitialized agbno range so caller doesn't have to */
  1200		if (!args->min_agbno && !args->max_agbno)
  1201			args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
  1202		ASSERT(args->min_agbno <= args->max_agbno);
  1203	
  1204		/* clamp agbno to the range if it's outside */
  1205		if (args->agbno < args->min_agbno)
  1206			args->agbno = args->min_agbno;
  1207		if (args->agbno > args->max_agbno)
  1208			args->agbno = args->max_agbno;
  1209	
  1210	restart:
  1211		ltlen = 0;
  1212		gtlena = 0;
  1213		ltlena = 0;
  1214		busy = false;
  1215	
  1216		/*
  1217		 * Set up cursors and see if there are any free extents as big as
  1218		 * maxlen. If not, pick the last entry in the tree unless the tree is
  1219		 * empty.
  1220		 */
  1221		error = xfs_alloc_cur_setup(args, &acur);
  1222		if (error == -ENOSPC) {
  1223			error = xfs_alloc_ag_vextent_small(args, acur.cnt, &ltbno,
  1224					&ltlen, &i);
  1225			if (error)
  1226				goto out;
  1227			if (i == 0 || ltlen == 0) {
  1228				trace_xfs_alloc_near_noentry(args);
  1229				goto out;
  1230			}
  1231			ASSERT(i == 1);
  1232		} else if (error) {
  1233			goto out;
  1234		}
  1235		args->wasfromfl = 0;
  1236	
  1237		/*
  1238		 * First algorithm.
  1239		 * If the requested extent is large wrt the freespaces available
  1240		 * in this a.g., then the cursor will be pointing to a btree entry
  1241		 * near the right edge of the tree.  If it's in the last btree leaf
  1242		 * block, then we just examine all the entries in that block
  1243		 * that are big enough, and pick the best one.
  1244		 * This is written as a while loop so we can break out of it,
  1245		 * but we never loop back to the top.
  1246		 */
  1247		while (xfs_btree_islastblock(acur.cnt, 0)) {
  1248			xfs_extlen_t	bdiff;
  1249			int		besti=0;
  1250			xfs_extlen_t	blen=0;
  1251			xfs_agblock_t	bnew=0;
  1252	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
