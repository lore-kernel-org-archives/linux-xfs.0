Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EDFC2BA16
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 04:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B5C20730
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 04:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDHEua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 00:50:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgDHEua (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 00:50:30 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0384X8tY072573
        for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2020 00:50:26 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30920a7kp8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2020 00:50:25 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 8 Apr 2020 05:49:55 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 05:49:51 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0384oJTF50069598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 04:50:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1366BA4060;
        Wed,  8 Apr 2020 04:50:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41564A4054;
        Wed,  8 Apr 2020 04:50:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.18])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 04:50:17 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        fstests@vger.kernel.org, hch@infradead.org
Subject: Re: xfs_check vs. xfs_repair vs. the world^W^Wfstests
Date:   Wed, 08 Apr 2020 10:23:21 +0530
Organization: IBM
In-Reply-To: <20200408030031.GB6740@magnolia>
References: <20200408030031.GB6740@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040804-0020-0000-0000-000003C3BA7D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040804-0021-0000-0000-0000221C7BFD
Message-Id: <2574725.68tNun6CyS@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=587 adultscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, April 8, 2020 8:30 AM Darrick J. Wong wrote: 
> Hi all,
> 
> Ok, so here we are yet again with "Let's deprecate xfs_check out of
> fstests for $raisins!", and once again there's the question of what evil
> things does repair miss that check didn't?
> 
> I hacked up the xfs_repair fuzz tests in fstests to see which ones would
> produce cases where xfs_repair -n says the fs is fine but xfs_check
> complains and returns nonzero, with the results recorded below.  I did a
> little triage...

Darrick, Thanks for doing this.

> 
> 1. The uid/gid/projid fuzzers and the diskdq fuzzers all seem to fail on
> account of the fact that repair does not actually check the quota
> counters.
> 
> 2. While the numrecs fuzz and the directory leaf failures actually spray
> btree verifier errors, somehow those are not turned into exit(1).
> 
> 3. Not sure what the blockcount ones are about, I think that might
> simply be inadequate record checking on repair's part.
> 
> Those last two are /probably/ simple fixes to xfs_repair.
> 
> Not sure what to do about quota in repair -- we could build in the
> ability to do quota counts since we scan the whole inode table and
> directory tree anyway.  From there it's not so hard to rebuild the quota
> inodes too.
>

I will take up this work and get it completed.

Since I have other higher priority tasks at work place, I will have this as my
secondary focus. Meanwhile, until it gets done, can we disable running these
tests on block size > 4k i.e. https://patchwork.kernel.org/patch/11454399/.

> Thoughts?
> 
> --D
> 
> xfs/350:
> xfs_repair passed but xfs_check failed (3) with inprogress = ones.
> xfs_repair passed but xfs_check failed (3) with inprogress = firstbit.
> xfs_repair passed but xfs_check failed (3) with inprogress = middlebit.
> xfs_repair passed but xfs_check failed (3) with inprogress = add.
> xfs_repair passed but xfs_check failed (3) with inprogress = sub.
> 
> xfs/358:
> xfs_repair passed but xfs_check failed (3) with numrecs = middlebit.
> xfs_repair passed but xfs_check failed (139) with recs[1].blockcount = ones.
> 
> xfs/360:
> xfs_repair passed but xfs_check failed (2) with numrecs = middlebit.
> xfs_repair passed but xfs_check failed (2) with numrecs = lastbit.
> 
> xfs/362:
> xfs_repair passed but xfs_check failed (3) with recs[1].startblock = middlebit.
> 
> xfs/372:
> xfs_repair passed but xfs_check failed (2) with numrecs = middlebit.
> xfs_repair passed but xfs_check failed (2) with numrecs = lastbit.
> 
> xfs/374:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> 
> xfs/376:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> xfs_repair passed but xfs_check failed (3) with core.forkoff = lastbit.
> 
> xfs/378:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> 
> xfs/384:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> 
> xfs/392:
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = sub.
> 
> xfs/398:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> 
> xfs/410:
> xfs_repair passed but xfs_check failed (3) with recs[1].startblock = zeroes.
> xfs_repair passed but xfs_check failed (139) with recs[1].blockcount = ones.
> xfs_repair passed but xfs_check failed (3) with recs[1].blockcount = middlebit.
> xfs_repair passed but xfs_check failed (3) with recs[1].blockcount = add.
> xfs_repair passed but xfs_check failed (139) with recs[1].blockcount = sub.
> 
> xfs/412:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> 
> xfs/414:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> 
> xfs/416:
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_lo = sub.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = ones.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = add.
> xfs_repair passed but xfs_check failed (3) with core.projid_hi = sub.
> xfs_repair passed but xfs_check failed (3) with core.uid = ones.
> xfs_repair passed but xfs_check failed (3) with core.uid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.uid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.uid = add.
> xfs_repair passed but xfs_check failed (3) with core.uid = sub.
> xfs_repair passed but xfs_check failed (3) with core.gid = ones.
> xfs_repair passed but xfs_check failed (3) with core.gid = firstbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = middlebit.
> xfs_repair passed but xfs_check failed (3) with core.gid = lastbit.
> xfs_repair passed but xfs_check failed (3) with core.gid = add.
> xfs_repair passed but xfs_check failed (3) with core.gid = sub.
> 
> xfs/425:
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = zeroes.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = sub.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = zeroes.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = sub.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = sub.
> 
> xfs/427:
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = zeroes.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = sub.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = zeroes.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = sub.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = sub.
> 
> xfs/429:
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = zeroes.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.bcount = sub.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = zeroes.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.icount = sub.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = ones.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = firstbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = middlebit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = lastbit.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = add.
> xfs_repair passed but xfs_check failed (3) with diskdq.rtbcount = sub.
> 
> xfs/496:
> xfs_repair passed but xfs_check failed (3) with lhdr.stale = middlebit.
> xfs_repair passed but xfs_check failed (3) with lhdr.stale = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[0].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[0].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[0].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[0].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[0].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[0].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[0].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[0].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[0].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[0].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[0].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[0].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[0].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[0].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[1].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[1].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[2].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[2].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[2].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[2].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[2].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[2].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[2].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[2].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[2].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[2].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[2].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[2].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[2].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[2].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[3].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[3].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[4].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[4].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[4].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[4].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[4].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[4].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[4].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[4].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[4].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[4].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[4].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[4].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[4].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[4].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[5].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[5].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[6].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[6].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[6].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[6].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[6].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[6].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[6].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[6].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[6].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[6].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[6].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[6].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[6].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[6].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[7].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[7].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[8].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[8].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[8].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[8].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[8].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[8].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[8].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[8].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[8].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[8].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[8].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[8].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[8].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[8].address = sub.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = ones.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = add.
> xfs_repair passed but xfs_check failed (3) with lents[9].hashval = sub.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = zeroes.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = ones.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = firstbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = middlebit.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = lastbit.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = add.
> xfs_repair passed but xfs_check failed (3) with lents[9].address = sub.
> 


-- 
chandan



