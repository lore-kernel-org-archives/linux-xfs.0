Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA70C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 23:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78B2E218AE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 23:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g+cABoVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbfIRXLJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 19:11:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfIRXLI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 19:11:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IN991d108707;
        Wed, 18 Sep 2019 23:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=saqI1kwKc1unP6E+4mSVvt+A29lWVAX2RE8iIJ0GAK8=;
 b=g+cABoVxgKg/fqsJGF/wCqTeSPVPOvXqYqY+5axrZ4Ub1L8hwgLSYuaR/jLobFmExOU1
 9hXVC6r0NFgaDUqXgaOgDmaoCosVbgfbcRq7d7LS/RYOjX2EoSau5IyPh9Q3wpPuLmzR
 1EdZmSvC6eeGSw42sKMOx6B+xzAHlQUr1OboldoZ1JvOCv5WQL/YxUlMvWKJsReLJLSO
 YnTDoDa4DGRdRWl+IxsvkROJ7pXl4Qdyta+ssvw6D5GMeEOuCSWvaYvcl6Zf+aYp4Ujg
 40iXLuA7lx9nvMQoX45oPfb/i44sn1UnGJt29QS5YSkPcJG2BztQWL1W4KA9blKFjLw8 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v3vb4gbw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 23:10:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IN93RT044774;
        Wed, 18 Sep 2019 23:10:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2v3vb45y8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 23:10:55 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8INAsgD023035;
        Wed, 18 Sep 2019 23:10:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 16:10:53 -0700
Date:   Wed, 18 Sep 2019 16:10:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc:     Zorro Lang <zlang@redhat.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: question of xfs/148 and xfs/149
Message-ID: <20190918231050.GH2229799@magnolia>
References: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20190917163933.GC736475@magnolia>
 <20190918025915.GK7239@dhcp-12-102.nay.redhat.com>
 <7b5d5797-afff-90bc-0131-38fd13eced34@cn.fujitsu.com>
 <20190918163711.GX2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918163711.GX2229799@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180196
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 09:37:11AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 18, 2019 at 11:24:47AM +0800, Yang Xu wrote:
> > 
> > 
> > on 2019/09/18 10:59, Zorro Lang wrote:
> > > xfs/030 is weird, I've found it long time ago.
> > > 
> > > If I do a 'whole disk mkfs' (_scratch_mkfs_xfs), before this sized mkfs:
> > > 
> > >    _scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
> > > 
> > > Everything looks clear, and test pass. I can't send a patch to do this,
> > > because I don't know the reason.
> > Yes. I also found running _scratch_mkfs_xfs in xfs/030 can slove this
> > problem yesterday. Or, we can adjust _try_wipe_scratch_devs order in
> > check(But I dont't have enough reason to explain why adjust it). as below:
> 
> (Yeah, I don't see any obvious reason why that would change outcomes...)
> 
> > --- a/check
> > +++ b/check
> > @@ -753,7 +753,6 @@ for section in $HOST_OPTIONS_SECTIONS; do
> >                         # _check_dmesg depends on this log in dmesg
> >                         touch ${RESULT_DIR}/check_dmesg
> >                 fi
> > -               _try_wipe_scratch_devs > /dev/null 2>&1
> >                 if [ "$DUMP_OUTPUT" = true ]; then
> >                         _run_seq 2>&1 | tee $tmp.out
> >                         # Because $? would get tee's return code
> > @@ -799,7 +798,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
> >                 # Scan for memory leaks after every test so that associating
> >                 # a leak to a particular test will be as accurate as
> > possible.
> >                 _check_kmemleak || err=true
> > -
> > +               _try_wipe_scratch_devs > /dev/null 2>&1
> >                 # test ends after all checks are done.
> >                 $timestamp && _timestamp
> >                 stop=`_wallclock`
> > 
> > > 
> > > I'm not familiar with xfs_repair so much, so I don't know what happens
> > > underlying. I suppose the the part after the $DSIZE affect the xfs_repair,
> > > but I don't know why the wipefs can cause that, wipefs only erase 4 bytes
> > > at the beginning.
> > > 
> >  I am finding the reasion. It seems wipefs wipes important information and
> > $DSIZE option(using single agcount or dsize, it also fails ) can not format
> > disk completely. If we use other options, it can pass.
> 
> How does mkfs fail, specifically?
> 
> Also, what's your storage configuration?  And lsblk -D output?

I'm still interested in the answer to these questions, but I've done a
little more research and noticed that yes, xfs/030 fails if the device
doesn't support zeroing discard.

First, if mkfs.xfs detects an old primary superblock, it will write
zeroes to all superblocks before formatting the new filesystem.
Obviously this won't be done if the device doesn't have a primary
superblock.

(1) So let's say that a previous test formatted a 4GB scratch disk with
all defaults, and let's say that we have 4 AGs.  The disk will look like
this:

  SB0 [1G space] SB1 [1G space] SB2 [1G space] SB3 [1G space]

(2) Now we _try_wipe_scratch_devs, which wipes out the primary label:

  000 [1G space] SB1 [1G space] SB2 [1G space] SB3 [1G space]

(3) Now xfs/030 runs its special mkfs command (6AGs, 100MB disk).  If the
disk supports zeroing discard, it will discard the whole device:

  <4GB of zeroes>

(4) Then it will lay down its own filesystem:

  SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 4G>

(5) Next, xfs/030 zaps the primary superblock:

  000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 4G>

(6) Next, xfs/030 runs xfs_repair.  It fails to find the primary sb, so it
tries to find secondary superblocks.  Its first strategy is to compute
the fs geometry assuming all default options.  In this case, that means
4 AGs, spaced 1G apart.  They're all zero, so it falls back to a linear
scan of the disk.  It finds SB1, uses that to rewrite the primary super,
and continues with the repair (which is mostly uneventful).  The test
passes; this is why it works on my computer.

---------

Now let's see what happened before _try_wipe_scratch_devs.  In step (3)
mkfs would find the old superblocks and wipe the superblocks, before
laying down the new superblocks:

  SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
      000 [1G space] 000 [1G space] 000 [1G space]

Step (5) zaps the primary, yielding:

  000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
      000 [1G space] 000 [1G space] 000 [1G space]

Step (6) fails to find a primary superblock so it tries to read backup
superblocks at 1G, 2G, and 3G, but they're all zero so it falls back to
the linear scan and picks up SB1 and proceeds with a mostly uneventful
repair.  The test passes.

---------

However, with _try_wipe_scratch_devs and a device that doesn't support
discard (or MKFS_OPTIONS includes -K), we have a problem.  mkfs.xfs
doesn't discard the device nor does it find a primary superblock, so it
simply formats the new filesystem.  We end up with:

  SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
      SB'1 [1G space] SB'2 [1G space] SB'3 [1G space]

Where SB[0-5] are from the filesystem that xfs/030 formatted but
SB'[1-3] are from the filesystem that was on the scratch disk before
xfs/030 even started.  Uhoh.

Step (5) zaps the primary, yielding:

  000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
      SB'1 [1G space] SB'2 [1G space] SB'3 [1G space]

Step (6) fails to find a primary superblock so it tries to read backup
superblocks at 1G.  It finds SB'1 and uses that to reconstruct the /old/
filesystem, with what looks like massive filesystem damage.  This
results in test failure.  Oops.

----------

The reason for adding _try_wipe_scratch_devs was to detect broken tests
that started using the filesystem on the scratch device (if any) before
(or without!) formatting the scratch device.  That broken behavior could
result in spurious test failures when xfstests was run in random order
mode either due to mounting an unformatted device or mounting a corrupt
fs that some other test left behind.

I guess a fix for XFS would be have _try_wipe_scratch_devs try to read
the primary superblock to compute the AG geometry and then erase all
superblocks that could be on the disk; and then compute the default
geometry and wipe out all those superblocks too.

Does any of that square with what you've been seeing?

--D

> --D
> 
> > > Darrick, do you know more about that?
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > > > xfs/148 is a clone of test 030 using xfs_prepair64 instead of xfs_repair.
> > > > > xfs/149 is a clone of test 031 using xfs_prepair instead of xfs_repair
> > > I'm not worried about it too much, due to it always 'not run' and never
> > > failsYes. But I perfer to remove them because IMO they are useless.
> > > 
> > 
> > > xfs/148 [not run] parallel repair binary xfs_prepair64 is not installed
> > > xfs/149 [not run] parallel repair binary xfs_prepair is not installed
> > > Ran: xfs/148 xfs/149
> > > Not run: xfs/148 xfs/149
> > > Passed all 2 tests
> > > 
> > 
> > 
