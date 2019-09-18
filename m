Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC73C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D00A0218AF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UQZWDKii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387639AbfIRQha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:37:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbfIRQha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 12:37:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGNY5x021930;
        Wed, 18 Sep 2019 16:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HsD2Grt+RQD9YP/FJzq1EdCj1FdAkx1ALVVUPiKkHpk=;
 b=UQZWDKii4eX98ePEtzqXRQatHZEG5FPmfamiIYw4czkENwQbW7thoTQYDmCwugo03C7j
 xf+qaKGgKNdmRMqAwevX4d9siVWw0cHI0Ue/2ThJ8BSTN6naUqUUk7qNbxUEmaXSYm2D
 /lu0r0uPQ4IqOn4nhizXPL6nYvRXdZ5MRt0zbhF2Bf9Y4LFUJXdYzBn4KTbdMdFfenb8
 RgcXOJbccgG3QJ/ENx8VDSd1fY44VgqlSmSpH3Y+Tb5q7guPj+lug1P4ocAMDp+KEQWM
 b2Df1PuivEim7S2Tgu0NapDkJAZYwVrdCII9stUK+xlZhjT32HLR7RalYKmBXdxez/Gv 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v385dw612-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:37:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGNL3I048417;
        Wed, 18 Sep 2019 16:37:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v37mastp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:37:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IGbDmU013658;
        Wed, 18 Sep 2019 16:37:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 09:37:12 -0700
Date:   Wed, 18 Sep 2019 09:37:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc:     Zorro Lang <zlang@redhat.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: question of xfs/148 and xfs/149
Message-ID: <20190918163711.GX2229799@magnolia>
References: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20190917163933.GC736475@magnolia>
 <20190918025915.GK7239@dhcp-12-102.nay.redhat.com>
 <7b5d5797-afff-90bc-0131-38fd13eced34@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b5d5797-afff-90bc-0131-38fd13eced34@cn.fujitsu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 11:24:47AM +0800, Yang Xu wrote:
> 
> 
> on 2019/09/18 10:59, Zorro Lang wrote:
> > xfs/030 is weird, I've found it long time ago.
> > 
> > If I do a 'whole disk mkfs' (_scratch_mkfs_xfs), before this sized mkfs:
> > 
> >    _scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
> > 
> > Everything looks clear, and test pass. I can't send a patch to do this,
> > because I don't know the reason.
> Yes. I also found running _scratch_mkfs_xfs in xfs/030 can slove this
> problem yesterday. Or, we can adjust _try_wipe_scratch_devs order in
> check(But I dont't have enough reason to explain why adjust it). as below:

(Yeah, I don't see any obvious reason why that would change outcomes...)

> --- a/check
> +++ b/check
> @@ -753,7 +753,6 @@ for section in $HOST_OPTIONS_SECTIONS; do
>                         # _check_dmesg depends on this log in dmesg
>                         touch ${RESULT_DIR}/check_dmesg
>                 fi
> -               _try_wipe_scratch_devs > /dev/null 2>&1
>                 if [ "$DUMP_OUTPUT" = true ]; then
>                         _run_seq 2>&1 | tee $tmp.out
>                         # Because $? would get tee's return code
> @@ -799,7 +798,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
>                 # Scan for memory leaks after every test so that associating
>                 # a leak to a particular test will be as accurate as
> possible.
>                 _check_kmemleak || err=true
> -
> +               _try_wipe_scratch_devs > /dev/null 2>&1
>                 # test ends after all checks are done.
>                 $timestamp && _timestamp
>                 stop=`_wallclock`
> 
> > 
> > I'm not familiar with xfs_repair so much, so I don't know what happens
> > underlying. I suppose the the part after the $DSIZE affect the xfs_repair,
> > but I don't know why the wipefs can cause that, wipefs only erase 4 bytes
> > at the beginning.
> > 
>  I am finding the reasion. It seems wipefs wipes important information and
> $DSIZE option(using single agcount or dsize, it also fails ) can not format
> disk completely. If we use other options, it can pass.

How does mkfs fail, specifically?

Also, what's your storage configuration?  And lsblk -D output?

--D

> > Darrick, do you know more about that?
> > 
> > Thanks,
> > Zorro
> > 
> > > > xfs/148 is a clone of test 030 using xfs_prepair64 instead of xfs_repair.
> > > > xfs/149 is a clone of test 031 using xfs_prepair instead of xfs_repair
> > I'm not worried about it too much, due to it always 'not run' and never
> > failsYes. But I perfer to remove them because IMO they are useless.
> > 
> 
> > xfs/148 [not run] parallel repair binary xfs_prepair64 is not installed
> > xfs/149 [not run] parallel repair binary xfs_prepair is not installed
> > Ran: xfs/148 xfs/149
> > Not run: xfs/148 xfs/149
> > Passed all 2 tests
> > 
> 
> 
