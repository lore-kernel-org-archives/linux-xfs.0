Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E19C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 18:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B279214D8
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 18:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sxfjXtcs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732848AbgCCSGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 13:06:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36170 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732929AbgCCSGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 13:06:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023Hw7YB149771;
        Tue, 3 Mar 2020 18:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vYxVj5vbsO5sRZ4NY3VvxpPSMoGoxxg65iggP9IAw7E=;
 b=sxfjXtcsfjSaqFrvPSEPjloTW+lyDOR7CO7k0hSUygkoQbp9jtoSCwXUg9txZIVlbLmk
 1xrzJwgkDefc8/kSWFAR7BFpJ8GbIZHRk4Ic5TU9nH5ntHViVFTO59QNtkW/giBu4ErM
 tZvWaqx6iLgHx9kydwzWjxX+G6E4Xal0QgoBOqRz30ssJ1C1UtR+bhWRUNhjyxrWAMVi
 DKoUGx/vTJvd4WsDZnKiLXVxe5+Mm5boi8YxWKKOMay57UvVd8nwojvzf3KrGPHXscTy
 tbV7XeIGV9ODX1kz/AvQITGxyUdZoasD+y7ZxoQfBYMyPRhIBSKp2JTAFYcaeWoOuHOX Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwqs025-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 18:06:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023Hv2oj181742;
        Tue, 3 Mar 2020 18:06:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yg1gxymea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 18:06:30 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 023I6S7D032285;
        Tue, 3 Mar 2020 18:06:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 10:06:28 -0800
Date:   Tue, 3 Mar 2020 10:06:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test xfs_scrub phase 6 media error reporting
Message-ID: <20200303180626.GE8044@magnolia>
References: <158086093704.1990427.12233429264118879844.stgit@magnolia>
 <158086094326.1990427.7286270181411420127.stgit@magnolia>
 <20200301150857.GM3840@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301150857.GM3840@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 12:00:52AM +0800, Eryu Guan wrote:
> On Tue, Feb 04, 2020 at 04:02:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add new helpers to dmerror to provide for marking selected ranges
> > totally bad -- both reads and writes will fail.  Create a new test for
> > xfs_scrub to check that it reports media errors correctly.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> So is this expected to fail with latest xfsprogs for-next branch? I got
> failures like:
> 
>  QA output created by 515
>   Scrub for injected media error
>  -Corruption: disk offset NNN: media error in inodes. (!)
>  -SCRATCH_MNT: Unmount and run xfs_repair.

The test should pass ... and I can't reproduce it all here.  What are
you MKFS_OPTIONS and MOUNT_OPTIONS and kernel?  Here's mine:

--D

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, /dev/sdf
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt

xfs/747  3s
Ran: xfs/747
Passed all 1 tests

-------------------

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
MKFS_OPTIONS  -- -f -m crc=0,reflink=0,rmapbt=0, -i sparse=0, /dev/sdf
MOUNT_OPTIONS -- -o usrquota,grpquota, /dev/sdf /opt

xfs/747 [not run] crc feature not supported by this filesystem
Ran: xfs/747
Not run: xfs/747
Passed all 1 tests

-------------------

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=0, -i sparse=1, /dev/sdf
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt

xfs/747  2s
Ran: xfs/747
Passed all 1 tests

--------------------

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=0, -i sparse=1, /dev/sdf
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt

xfs/747  3s
Ran: xfs/747
Passed all 1 tests

--D
