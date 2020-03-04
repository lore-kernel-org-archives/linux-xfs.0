Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12A3C3F2CD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 794E4214DB
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NU+TNQjK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgCDDvI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 22:51:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCDDvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 22:51:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243i1K9098972;
        Wed, 4 Mar 2020 03:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JRMp8oNJrpkc8GqCx0SsqeWXF7jW9hQfdeiJXze12qY=;
 b=NU+TNQjKevpMMln4CdkXDTFffJa96I6Vw240jDAVZlaC/NH0HGiRW7nIaywOZUFKHoyZ
 ozWL2ztfuZLJrrzYbPgcIhUcgV+5kxIX1MUPYsALad6RXW8tiZhCxjyAF5siqU0LuQh+
 3t9UdMEhILkA8ZKxg4K1ckTcc4f0zDNajyYZCJLNT5XVU8GaAh/TfjMO0sIl/GZDt36W
 lywxPB62HPCxO6iMYsxLYYpZSOxif1Kar1kw7uHAb3i2//0FIRy8l5zC59EpnoJy/TKX
 KvCv+MBHAmBf5SsK44nRPbI2l00HWzK3BGeO54lQnKG85Fsk34aJhnnyW1fPBczkFOXK zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yffcukscd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:51:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243j0q1074045;
        Wed, 4 Mar 2020 03:50:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yg1enn5kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:50:59 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0243owGQ019075;
        Wed, 4 Mar 2020 03:50:58 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 19:50:58 -0800
Date:   Tue, 3 Mar 2020 19:50:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@aliyun.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test xfs_scrub phase 6 media error reporting
Message-ID: <20200304035057.GE1752567@magnolia>
References: <158086093704.1990427.12233429264118879844.stgit@magnolia>
 <158086094326.1990427.7286270181411420127.stgit@magnolia>
 <20200301150857.GM3840@desktop>
 <20200303180626.GE8044@magnolia>
 <20200304025132.GB3128153@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304025132.GB3128153@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 10:51:32AM +0800, Eryu Guan wrote:
> On Tue, Mar 03, 2020 at 10:06:26AM -0800, Darrick J. Wong wrote:
> > On Mon, Mar 02, 2020 at 12:00:52AM +0800, Eryu Guan wrote:
> > > On Tue, Feb 04, 2020 at 04:02:23PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add new helpers to dmerror to provide for marking selected ranges
> > > > totally bad -- both reads and writes will fail.  Create a new test for
> > > > xfs_scrub to check that it reports media errors correctly.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > So is this expected to fail with latest xfsprogs for-next branch? I got
> > > failures like:
> > > 
> > >  QA output created by 515
> > >   Scrub for injected media error
> > >  -Corruption: disk offset NNN: media error in inodes. (!)
> > >  -SCRATCH_MNT: Unmount and run xfs_repair.
> > 
> > The test should pass ... and I can't reproduce it all here.  What are
> > you MKFS_OPTIONS and MOUNT_OPTIONS and kernel?  Here's mine:
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 fedoravm 5.6.0-rc2 #46 SMP Mon Feb 17 11:37:03 CST 2020
> MKFS_OPTIONS  -- -f -f -b size=4k -m reflink=1,rmapbt=1 /dev/mapper/testvg-lv2
> MOUNT_OPTIONS -- /dev/mapper/testvg-lv2 /mnt/scratch
> 
> xfs/515 - output mismatch (see /root/workspace/xfstests/results//xfs_4k_reflink/xfs/515.out.bad)
>     --- tests/xfs/515.out       2020-03-01 22:42:19.569613781 +0800
>     +++ /root/workspace/xfstests/results//xfs_4k_reflink/xfs/515.out.bad        2020-03-01 23:06:33.546230712 +0800
>     @@ -1,5 +1,3 @@
>      QA output created by 515
>      Scrub for injected media error
>     -Corruption: disk offset NNN: media error in inodes. (!)
>     -SCRATCH_MNT: Unmount and run xfs_repair.
>      Scrub after removing injected media error
> 
> And I'm using xfsprogs for-next branch, HEAD is
> 
> commit fbbb184b189c62beed2a694d14e83bd316fd4140
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Thu Feb 27 23:20:42 2020 -0500
> 
>     xfs_repair: join realtime inodes to transaction only once

Hmm, that's really odd.  Can you please send me a metadump of the
scratch fs after the test runs?  I tried your exact mkfs/mount options
and it ran just fine here:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
MKFS_OPTIONS  -- -f -f -b size=4k -m reflink=1,rmapbt=1 /dev/sdf
MOUNT_OPTIONS -- /dev/sdf /opt

xfs/747  3s
Ran: xfs/747
Passed all 1 tests

--D

> > --D
> > 
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
> > MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, /dev/sdf
> > MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt
> 
> I think the problem is the mount option, adding the quota related
> options to my config then test passed as well.
> 
> Thanks,
> Eryu
> 
> > 
> > xfs/747  3s
> > Ran: xfs/747
> > Passed all 1 tests
> > 
> > -------------------
> > 
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
> > MKFS_OPTIONS  -- -f -m crc=0,reflink=0,rmapbt=0, -i sparse=0, /dev/sdf
> > MOUNT_OPTIONS -- -o usrquota,grpquota, /dev/sdf /opt
> > 
> > xfs/747 [not run] crc feature not supported by this filesystem
> > Ran: xfs/747
> > Not run: xfs/747
> > Passed all 1 tests
> > 
> > -------------------
> > 
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
> > MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=0, -i sparse=1, /dev/sdf
> > MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt
> > 
> > xfs/747  2s
> > Ran: xfs/747
> > Passed all 1 tests
> > 
> > --------------------
> > 
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 magnolia-mtr00 5.6.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 2 21:02:17 PST 2020
> > MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=0, -i sparse=1, /dev/sdf
> > MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt
> > 
> > xfs/747  3s
> > Ran: xfs/747
> > Passed all 1 tests
> > 
> > --D
