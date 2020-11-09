Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BDCC5517A
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD4520809
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kSddjMmE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgKISYk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:24:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33732 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgKISYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:24:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IOBA7149678;
        Mon, 9 Nov 2020 18:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZczM8jT2pX5OudjOCcgeUpVPt7vuG9fPdj0uqHUzPtU=;
 b=kSddjMmEUPZixXpEtEIclJS4Y+BfmJ3sX1cv2jnHzMIVGygGbCcYK7gwUf3Fd2tcXmQO
 rGxXzNkY5V5fx+V1HE5PWb0n4OWg6WR87o35qozKGNW3ijVYHrQ4d9Z5n38H+kDF8+KO
 0FbkKDu9LTHwiIh654r/qQOwsZeWPebIUzSyebUc/dBG/UT4J2y42KSytLK/wUk2Hd42
 klQa+4NJov85p3sXsYZUnz6Zv+TsLbwVZ9fFZSLThMqF7GshAtDNGQMEei9Rz/AsMUrZ
 NtwQG51KBh4hjhPG6myBeQLtgRo/Z4U1vbtUb19tryTVOMX/LgJ56bj2PzQNkgVS8IL6 dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3aqpmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:24:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IB19E136667;
        Mon, 9 Nov 2020 18:22:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34p5bqv7vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:22:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A9IMWps029884;
        Mon, 9 Nov 2020 18:22:32 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:22:32 -0800
Date:   Mon, 9 Nov 2020 10:22:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: Random xfs_check errors
Message-ID: <20201109182231.GB9699@magnolia>
References: <CAOQ4uxjia_L5mzEa=R9221sdO9KrsmvyGyKGcrmYKc47msJ=bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjia_L5mzEa=R9221sdO9KrsmvyGyKGcrmYKc47msJ=bg@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 30, 2020 at 01:36:30PM +0200, Amir Goldstein wrote:
> Hi guys,
> 
> I've been running the latest xfstests with xfsprogs v5.9 and stable
> kernel v5.9.y past week (including v5.9.2 today) and I'm getting
> reports like below after random tests.
> 
> This one was after generic/466, but already got similar reports
> (with more blocks) after generic/511,518,519 on different test runs.
> 
> Is anyone else seeing this?
> Any advice on what to look for?
> 
> Did not get to test v5.10-rc1 yet. I thought I would ask here first
> in case it's a known issue.
> 
> Sasha, I am wondering which xfsprogs version are you using
> when verifying stable kernel patches, because I have just recently
> upgraded xfsprogs to v5.9 in my stable test environment.

FWIW I patched xfs_check out of fstests years ago.

Once Eric merges the large(ish) pile of xfs_repair patches I sent him
for 5.10 I think we'll be at the point where there aren't any
corruptions caught by xfs_check but not by xfs_repair.

Soon I'll also submit my rewrite of the fstests fuzzer code to Eryu, and
when that lands upstream then the rest of you will be able to check my
assertion.

Assuming none of you find new coverage holes that I didn't, we will
finally be able to drop xfs_check (which is bitrotting) from fstests
entirely.

--D

> Thanks,
> Amir.
> 
> 
> _check_xfs_filesystem: filesystem on
> /dev/mapper/0fce4d2d--779b--44e8--91d0--2cb1b252f68e-xfs_scratch is
> inconsistent (c)
> *** xfs_check output ***
> block 0/10 expected type unknown got free1
> agf_freeblks 1310702, counted 1310701 in ag 0
> agi_freecount 61, counted 58 in ag 0
> sb_ifree 61, counted 58
> sb_fdblocks 5240288, counted 5240287
> sb_fdblocks 5240288, aggregate AGF count 5240287
> *** end xfs_check output
