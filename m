Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6D4C2BA80
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 03:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC9DE2078C
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 03:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a+uDMNEu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgDHDCt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 23:02:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38350 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDHDCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 23:02:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0382wFA5009484;
        Wed, 8 Apr 2020 03:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=C03Yoq2mjvr5gORXD0LOuiNF7l1NUASM5Ptz/h6A79s=;
 b=a+uDMNEuJmnCy4iksdyNCnjPDYP/Wa9Xzo8wQQkL87pzaNCYKL5IM0R1fGM/n2PnPHKE
 Gt8BENUs6uyH36n7wezzvulQ6DHXwsVZiBP8pdIyD2shEVBZp4VfJr3auXAOoeGR7sHr
 RrpS6AEwStTntExRbGvdqphKlYOezB9OuFcwI13fD5WIN8yakMAXphscjXRWe5hIOcW6
 y56UM+f9FHDU5eR3gAOk7jGviaCv5LNfRvMWdK34h4E4Oo79JiiMa7SWfwcR7eiHuEAi
 c7eqj3ENHk3ObqBbiGWgjYvj61JGaYFer0lTIkXOjD5qFyd1J3Lex2DpHEAxhW6gbZMf lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3091m0rqvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 03:02:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0382pUBD172764;
        Wed, 8 Apr 2020 03:00:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3091m28qym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 03:00:36 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03830XIK004813;
        Wed, 8 Apr 2020 03:00:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 20:00:32 -0700
Date:   Tue, 7 Apr 2020 20:00:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        fstests@vger.kernel.org, chandan@linux.ibm.com, hch@infradead.org
Subject: xfs_check vs. xfs_repair vs. the world^W^Wfstests
Message-ID: <20200408030031.GB6740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=1 mlxlogscore=514
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=575 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=1 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080017
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Ok, so here we are yet again with "Let's deprecate xfs_check out of
fstests for $raisins!", and once again there's the question of what evil
things does repair miss that check didn't?

I hacked up the xfs_repair fuzz tests in fstests to see which ones would
produce cases where xfs_repair -n says the fs is fine but xfs_check
complains and returns nonzero, with the results recorded below.  I did a
little triage...

1. The uid/gid/projid fuzzers and the diskdq fuzzers all seem to fail on
account of the fact that repair does not actually check the quota
counters.

2. While the numrecs fuzz and the directory leaf failures actually spray
btree verifier errors, somehow those are not turned into exit(1).

3. Not sure what the blockcount ones are about, I think that might
simply be inadequate record checking on repair's part.

Those last two are /probably/ simple fixes to xfs_repair.

Not sure what to do about quota in repair -- we could build in the
ability to do quota counts since we scan the whole inode table and
directory tree anyway.  From there it's not so hard to rebuild the quota
inodes too.

Thoughts?

--D

xfs/350:
xfs_repair passed but xfs_check failed (3) with inprogress = ones.
xfs_repair passed but xfs_check failed (3) with inprogress = firstbit.
xfs_repair passed but xfs_check failed (3) with inprogress = middlebit.
xfs_repair passed but xfs_check failed (3) with inprogress = add.
xfs_repair passed but xfs_check failed (3) with inprogress = sub.

xfs/358:
xfs_repair passed but xfs_check failed (3) with numrecs = middlebit.
xfs_repair passed but xfs_check failed (139) with recs[1].blockcount = ones.

xfs/360:
xfs_repair passed but xfs_check failed (2) with numrecs = middlebit.
xfs_repair passed but xfs_check failed (2) with numrecs = lastbit.

xfs/362:
xfs_repair passed but xfs_check failed (3) with recs[1].startblock = middlebit.

xfs/372:
xfs_repair passed but xfs_check failed (2) with numrecs = middlebit.
xfs_repair passed but xfs_check failed (2) with numrecs = lastbit.

xfs/374:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.

xfs/376:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.
xfs_repair passed but xfs_check failed (3) with core.forkoff = lastbit.

xfs/378:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.

xfs/384:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.

xfs/392:
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[1].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[1].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[1].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[1].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[1].address = add.
xfs_repair passed but xfs_check failed (3) with lents[1].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[3].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[3].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[3].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[3].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[3].address = add.
xfs_repair passed but xfs_check failed (3) with lents[3].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[5].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[5].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[5].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[5].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[5].address = add.
xfs_repair passed but xfs_check failed (3) with lents[5].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[7].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[7].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[7].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[7].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[7].address = add.
xfs_repair passed but xfs_check failed (3) with lents[7].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[9].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[9].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[9].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[9].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[9].address = add.
xfs_repair passed but xfs_check failed (3) with lents[9].address = sub.

xfs/398:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.

xfs/410:
xfs_repair passed but xfs_check failed (3) with recs[1].startblock = zeroes.
xfs_repair passed but xfs_check failed (139) with recs[1].blockcount = ones.
xfs_repair passed but xfs_check failed (3) with recs[1].blockcount = middlebit.
xfs_repair passed but xfs_check failed (3) with recs[1].blockcount = add.
xfs_repair passed but xfs_check failed (139) with recs[1].blockcount = sub.

xfs/412:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.

xfs/414:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.

xfs/416:
xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
xfs_repair passed but xfs_check failed (3) with core.uid = ones.
xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.uid = add.
xfs_repair passed but xfs_check failed (3) with core.uid = sub.
xfs_repair passed but xfs_check failed (3) with core.gid = ones.
xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
xfs_repair passed but xfs_check failed (3) with core.gid = add.
xfs_repair passed but xfs_check failed (3) with core.gid = sub.

xfs/425:
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = zeroes.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = sub.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = zeroes.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = sub.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = sub.

xfs/427:
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = zeroes.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = sub.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = zeroes.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = sub.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = sub.

xfs/429:
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = zeroes.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.bcount = sub.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = zeroes.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.icount = sub.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = ones.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = firstbit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = middlebit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = lastbit.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = add.
xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = sub.

xfs/496:
xfs_repair passed but xfs_check failed (3) with lhdr.stale = middlebit.
xfs_repair passed but xfs_check failed (3) with lhdr.stale = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[0].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[0].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[0].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[0].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[0].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[0].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[0].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[0].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[0].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[0].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[0].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[0].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[0].address = add.
xfs_repair passed but xfs_check failed (3) with lents[0].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[1].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[1].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[1].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[1].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[1].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[1].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[1].address = add.
xfs_repair passed but xfs_check failed (3) with lents[1].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[2].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[2].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[2].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[2].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[2].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[2].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[2].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[2].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[2].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[2].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[2].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[2].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[2].address = add.
xfs_repair passed but xfs_check failed (3) with lents[2].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[3].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[3].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[3].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[3].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[3].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[3].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[3].address = add.
xfs_repair passed but xfs_check failed (3) with lents[3].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[4].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[4].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[4].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[4].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[4].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[4].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[4].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[4].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[4].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[4].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[4].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[4].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[4].address = add.
xfs_repair passed but xfs_check failed (3) with lents[4].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[5].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[5].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[5].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[5].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[5].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[5].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[5].address = add.
xfs_repair passed but xfs_check failed (3) with lents[5].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[6].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[6].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[6].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[6].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[6].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[6].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[6].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[6].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[6].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[6].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[6].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[6].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[6].address = add.
xfs_repair passed but xfs_check failed (3) with lents[6].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[7].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[7].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[7].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[7].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[7].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[7].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[7].address = add.
xfs_repair passed but xfs_check failed (3) with lents[7].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[8].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[8].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[8].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[8].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[8].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[8].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[8].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[8].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[8].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[8].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[8].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[8].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[8].address = add.
xfs_repair passed but xfs_check failed (3) with lents[8].address = sub.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = ones.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = add.
xfs_repair passed but xfs_check failed (3) with lents[9].hashval = sub.
xfs_repair passed but xfs_check failed (3) with lents[9].address = zeroes.
xfs_repair passed but xfs_check failed (3) with lents[9].address = ones.
xfs_repair passed but xfs_check failed (3) with lents[9].address = firstbit.
xfs_repair passed but xfs_check failed (3) with lents[9].address = middlebit.
xfs_repair passed but xfs_check failed (3) with lents[9].address = lastbit.
xfs_repair passed but xfs_check failed (3) with lents[9].address = add.
xfs_repair passed but xfs_check failed (3) with lents[9].address = sub.
