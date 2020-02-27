Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA972C11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 15:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B57ED2469F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 15:23:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E4nFhZ54"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgB0PXI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 10:23:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgB0PXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 10:23:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RFHkdB069084;
        Thu, 27 Feb 2020 15:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bC0h46jWPLrR5ydjIvjgSVfv+9FggTTJUcRzX1+X/1o=;
 b=E4nFhZ54bLk2czmI0JIiSaBRNaWnzZ0MlBbG9Iiihusb8D8aJW+bE2Whz8Po3rkRkREy
 Bb//fjXZ24imS+lqonguH3OtqefcPU8jBoRR99ZkfieY/dpdyKumyeE6h7t4qJAVw8K5
 CslPwxX4cDANWG2ocFMzZlhod9OujMj8QyxKT5z+p/R03p8dJPhtavZxrZ4rfkQKa+U2
 VjK7b1BwHpmzFDSZ9gSNnSBO88VX8CVdu0jeP27vCQTz/ZyMxY05Phtk2Gr7uiUTZzOZ
 fwaB1FtoIeofDy+pmNimSHnEFzyZ3xFlUMVgGsay/LQuv+uGzbA3Qn2uTlL18zWXGBn0 Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ydybcnkwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 15:23:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RFGmcU044874;
        Thu, 27 Feb 2020 15:23:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ydcscn064-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 15:22:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RFMxNn023975;
        Thu, 27 Feb 2020 15:22:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 07:22:59 -0800
Date:   Thu, 27 Feb 2020 07:22:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 0/9] xfs: automatic relogging experiment
Message-ID: <20200227152258.GA8070@magnolia>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227150936.GL8045@magnolia>
 <20200227151814.GA6320@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227151814.GA6320@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 10:18:14AM -0500, Brian Foster wrote:
> On Thu, Feb 27, 2020 at 07:09:36AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 27, 2020 at 08:43:12AM -0500, Brian Foster wrote:
> > > Hi all,
> > > 
> > > Here's a v5 RFC of the automatic item relogging experiment. Firstly,
> > > note that this is still a POC and experimental code with various quirks.
> > 
> > Heh, funny, I was going to ask you if you might have time next week to
> > review the latest iteration of the btree bulk loading series so that I
> > could get closer to merging the rest of online repair and/or refactoring
> > offline repair.  I'll take a closer look at this after I read through
> > everything else that came in overnight.
> > 
> 
> Sure.. I can put that next on the list. Is the latest release pending a
> post or already posted? Being out for over a month (effectively closer
> to two when considering proximity to the holidays) caused me to pretty
> much clear everything in my mailbox for obvious reasons. ;) As a result,
> anything that might have been on my radar prior to that timeframe has
> most likely dropped completely off it. :P

Pending.  The patches themselves haven't changed much since the end of
October when I fixed all the things we talked about at the beginning of
that month, but you might as well wait for a new version rebased off
5.6. :)

(If you get really really bored and/or I get bogged down in something
else, the NYE patchbomb version is pretty close to what's in my tree
now...)

--D

> Brian
> 
> > --D
> > 
> > > Some are documented in the code, others might not be (such as abusing
> > > the AIL lock, etc.). The primary purpose of this series is still to
> > > express and review a fundamental design. Based on discussion on the last
> > > version, there is specific focus towards addressing log reservation and
> > > pre-item locking deadlock vectors. While the code is still quite hacky,
> > > I believe this design addresses both of those fundamental issues.
> > > Further details on the design and approach are documented in the
> > > individual commit logs.
> > > 
> > > In addition, the final few patches introduce buffer relogging capability
> > > and test infrastructure, which currently has no use case other than to
> > > demonstrate development flexibility and the ability to support arbitrary
> > > log items in the future, if ever desired. If this approach is taken
> > > forward, the current use cases are still centered around intent items
> > > such as the quotaoff use case and extent freeing use case defined by
> > > online repair of free space trees.
> > > 
> > > On somewhat of a tangent, another intent oriented use case idea crossed
> > > my mind recently related to the long standing writeback stale data
> > > exposure problem (i.e. if we crash after a delalloc extent is converted
> > > but before writeback fully completes on the extent). The obvious
> > > approach of using unwritten extents has been rebuffed due to performance
> > > concerns over extent conversion. I wonder if we had the ability to log a
> > > "writeback pending" intent on some reasonable level of granularity (i.e.
> > > something between a block and extent), whether we could use that to
> > > allow log recovery to zero (or convert) such extents in the event of a
> > > crash. This is a whole separate design discussion, however, as it
> > > involves tracking outstanding writeback, etc. In this context it simply
> > > serves as a prospective use case for relogging, as such intents would
> > > otherwise risk similar log subsystem deadlocks as the quotaoff use case.
> > > 
> > > Thoughts, reviews, flames appreciated.
> > > 
> > > Brian
> > > 
> > > rfcv5:
> > > - More fleshed out design to prevent log reservation deadlock and
> > >   locking problems.
> > > - Split out core patches between pre-reservation management, relog item
> > >   state management and relog mechanism.
> > > - Added experimental buffer relogging capability.
> > > rfcv4: https://lore.kernel.org/linux-xfs/20191205175037.52529-1-bfoster@redhat.com/
> > > - AIL based approach.
> > > rfcv3: https://lore.kernel.org/linux-xfs/20191125185523.47556-1-bfoster@redhat.com/
> > > - CIL based approach.
> > > rfcv2: https://lore.kernel.org/linux-xfs/20191122181927.32870-1-bfoster@redhat.com/
> > > - Different approach based on workqueue and transaction rolling.
> > > rfc: https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat.com/
> > > 
> > > Brian Foster (9):
> > >   xfs: set t_task at wait time instead of alloc time
> > >   xfs: introduce ->tr_relog transaction
> > >   xfs: automatic relogging reservation management
> > >   xfs: automatic relogging item management
> > >   xfs: automatic log item relog mechanism
> > >   xfs: automatically relog the quotaoff start intent
> > >   xfs: buffer relogging support prototype
> > >   xfs: create an error tag for random relog reservation
> > >   xfs: relog random buffers based on errortag
> > > 
> > >  fs/xfs/libxfs/xfs_errortag.h   |   4 +-
> > >  fs/xfs/libxfs/xfs_shared.h     |   1 +
> > >  fs/xfs/libxfs/xfs_trans_resv.c |  24 +++-
> > >  fs/xfs/libxfs/xfs_trans_resv.h |   1 +
> > >  fs/xfs/xfs_buf_item.c          |   5 +
> > >  fs/xfs/xfs_dquot_item.c        |   7 ++
> > >  fs/xfs/xfs_error.c             |   3 +
> > >  fs/xfs/xfs_log.c               |   2 +-
> > >  fs/xfs/xfs_qm_syscalls.c       |  12 +-
> > >  fs/xfs/xfs_trace.h             |   3 +
> > >  fs/xfs/xfs_trans.c             |  79 +++++++++++-
> > >  fs/xfs/xfs_trans.h             |  13 +-
> > >  fs/xfs/xfs_trans_ail.c         | 216 ++++++++++++++++++++++++++++++++-
> > >  fs/xfs/xfs_trans_buf.c         |  35 ++++++
> > >  fs/xfs/xfs_trans_priv.h        |   6 +
> > >  15 files changed, 399 insertions(+), 12 deletions(-)
> > > 
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
