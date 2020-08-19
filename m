Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD01EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E0320657
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JKBcgabe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgHSAxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:53:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHSAxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:53:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0mEUV170982;
        Wed, 19 Aug 2020 00:53:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+lHw1+TeDISdwv/nKk8g9JOfcUvCeUj3SwVp17rncRc=;
 b=JKBcgabeJg2YRm6huljqZDDZcDLqdsLVbs3N2zLcwUKTicdHH/G484DeCrrgOa0fVw6q
 K7jgG5I5K1Aay/REyXM0l2RXV7DhxTR/HOo8EiYKPSaBD5bEifSBO9i7YP7RvsqnTgSN
 Cmf6SCsyvlXW0wcDsn7kRNi4HZKyPOKCtD1H4F27+s6Y+M+2v36k6NkVmAsuByrJRSdu
 kCj7kvZELp8xX/qX0DcS2HSdCbF+WTDYkPDXOtPqBRTzOCEXT9xwWBFbEx8tdsMx00kM
 MDP2z7HfESnThf2GQXbOQgp3DdJDGfXxo6m8ODyt4x59uLYAbQL6N4bkr95PJsHDabah YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74r7ykd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:53:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0mG5j190735;
        Wed, 19 Aug 2020 00:53:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9njhuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:53:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0rdqi021136;
        Wed, 19 Aug 2020 00:53:39 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:53:39 -0700
Date:   Tue, 18 Aug 2020 17:53:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH v4 0/3] xfs: more unlinked inode list optimization v4
Message-ID: <20200819005334.GA6096@magnolia>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818133015.25398-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 09:30:12PM +0800, Gao Xiang wrote:
> Hi forks,
> 
> This is RFC v4 version which is based on Dave's latest patchset:
>  https://lore.kernel.org/r/20200812092556.2567285-1-david@fromorbit.com

As we already discussed on IRC, please send new revisions of patchsets
as a separate thread from the old submission.

> I didn't send out v3 because it was based on Dave's previous RFC
> patchset, but I'm still not quite sure to drop RFC tag since this
> version is different from the previous versions...

Hm, this cover letter could use some tidying up, since it took me a bit
of digging to figure out that yes, this is the successor of the old
series that tried to get the AGI buffer lock out of the way if we're
adding a newly unlinked inode to the end of the unlinked list.

> Changes since v2:
>  - rebase on new patchset, and omit the original first patch
>    "xfs: arrange all unlinked inodes into one list" since it now
>    has better form in the base patchset;
> 
>  - a tail xfs_inode pointer is no longer needed since the original
>    patchset introduced list_head iunlink infrastructure and it can
>    be used to get the tail inode;
> 
>  - take pag_iunlink_mutex lock until all iunlink log items are
>    committed. Otherwise, xfs_iunlink_log() order would not be equal
>    to the trans commit order so it can mis-reorder and cause metadata
>    corruption I mentioned in v2.
> 
>    In order to archive that, some recursive count is introduced since
>    there could be several iunlink operations in one transaction,
>    and introduce some per-AG fields as well since these operations
>    in the transaction may not operate inodes in the same AG. we may
>    also need to take AGI buffer lock in advance (e.g. whiteout rename
>    path) due to iunlink operations and locking order constraint.
>    For more details, see related inlined comments as well...
> 
>  - "xfs: get rid of unused pagi_unlinked_hash" would be better folded
>    into original patchset since pagi_unlinked_hash is no longer needed.
> 
> ============
> 
> [Original text]
> 
> This RFC patchset mainly addresses the thoughts [*] and [**] from Dave's
> original patchset,
> https://lore.kernel.org/r/20200623095015.1934171-1-david@fromorbit.com
> 
> In short, it focues on the following ideas mentioned by Dave:
>  - use bucket 0 instead of multiple buckets since in-memory double
>    linked list finally works;
> 
>  - avoid taking AGI buffer and unnecessary AGI update if possible, so
>    1) add a new lock and keep proper locking order to avoid deadlock;
>    2) insert a new unlinked inode from the tail instead of head;
> 
> In addition, it's worth noticing 3 things:
>  - xfs_iunlink_remove() should support old multiple buckets in order
>    to keep old inode unlinked list (old image) working when recovering.
> 
>  - (but) OTOH, the old kernel recovery _shouldn't_ work with new image
>    since the bucket_index from old xfs_iunlink_remove() is generated
>    by the old formula (rather than keep in xfs_inode), which is now
>    fixed as 0. So this feature is not forward compatible without some
>    extra backport patches;

Oh?  These seem like serious limitations, are they still true?

--D

>  - a tail xfs_inode pointer is also added in the perag, which keeps 
>    track of the tail of bucket 0 since it's mainly used for xfs_iunlink().
> 
> 
> The git tree is also available at
> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git tags/xfs/iunlink_opt_v4
> 
> Gitweb:
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=xfs/iunlink_opt_v4
> 
> 
> Some preliminary tests are done (including fstests, but there seems
> some pre-exist failures and I haven't looked into yet). And I confirmed
> there was no previous metadata corruption mentioned in RFC v2 anymore.
> 
> To confirm that I'm in the right direction, I post the latest version
> now since it haven't been updated for a while.
> 
> Comments and directions are welcomed. :)
> 
> Thanks,
> Gao Xiang
> 
> Gao Xiang (3):
>   xfs: get rid of unused pagi_unlinked_hash
>   xfs: introduce perag iunlink lock
>   xfs: insert unlinked inodes from tail
> 
>  fs/xfs/xfs_inode.c        | 194 ++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_inode.h        |   1 +
>  fs/xfs/xfs_iunlink_item.c |  16 ++++
>  fs/xfs/xfs_mount.c        |   4 +
>  fs/xfs/xfs_mount.h        |  14 +--
>  5 files changed, 193 insertions(+), 36 deletions(-)
> 
> -- 
> 2.18.1
> 
