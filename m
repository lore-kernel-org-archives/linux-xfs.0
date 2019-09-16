Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01371C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 18:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCE6A20830
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 18:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R8umdT5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbfIPSlu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 14:41:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfIPSlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 14:41:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GIcqVQ084815;
        Mon, 16 Sep 2019 18:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mYY2T2Leg5hvVT5tjpHOs8yFDj1zWRW6D5HrKQtXOnw=;
 b=R8umdT5bMQNvW5n+yly4kHk73uZAFStY+CkMii+6CgLj0kacnDVGwCVos/v3aZlkiloo
 VpouZsMGLix0pWWek8m619TF2ajgCNJcecpFCXK3T8uLmn7jslrk8K0/5XrU/eOzIcRk
 /UbWBtOz1FtQ2pPn+dGPNHoX1Jlle+XiyBrJEpqwEnro7VGrtNBvzuRtWrNAWZYR8lfR
 0lhLgw2sqk1ooGNKuoj10JzH9O63Q6GcmW+imfx3MHf/EmTt1upz4skPoyFJZKi8qTQ1
 32znRpOwx0Y5RNoOQpw+NGJonTjpbNqaHzFz+agy6hq6lAi7g2/1bKqhXZEFj3Qb6fK0 JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v0ruqhc31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 18:41:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GIbqlZ098359;
        Mon, 16 Sep 2019 18:41:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v0p8v0m9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 18:41:41 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8GIffkc003104;
        Mon, 16 Sep 2019 18:41:41 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 11:41:14 -0700
Subject: Re: [PATCH v3 00/19] Delayed Attributes
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190916122754.GA41978@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <178f8a56-9db2-ca26-aa9b-a5739f6ebd5a@oracle.com>
Date:   Mon, 16 Sep 2019 11:41:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190916122754.GA41978@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/16/19 5:27 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:18PM -0700, Allison Collins wrote:
>> Hi all,
>>
>> This set is a subset of a larger series for parent pointers.
>> Delayed attributes allow attribute operations (set and remove) to be
>> logged and committed in the same way that other delayed operations do.
>> This will help break up more complex operations when we later introduce
>> parent pointers which can be used in a number of optimizations.  Since
>> delayed attributes can be implemented as a stand alone feature, I've
>> decided to subdivide the set to help make it more manageable.  Delayed
>> attributes may also provide the infastructure to later break up large
>> attributes into smaller transactions instead of one large bwrite.
>>
>> Changes since v2:
>> Mostly review updates collected since v2.  Patch 17 is new and adds a
>> new feature bit that is enabled through mkfs.xfs -n delattr.  Attr
>> renames have been simplified into separate remove and set opertaions
>> which removes the need for the INCOMPLETE state used in non delayed
>> operations
>>
>> I've also made the corresponding updates to the user space side, and
>> xfstests as well.
>>
>> Question, comment and feedback appreciated!
>>
>> Thanks all!
>> Allison
>>
>> Allison Collins (15):
>>    xfs: Replace attribute parameters with struct xfs_name
> 
> Hi Allison,
> 
> The first patch in the series doesn't apply to current for-next or
> master. What is the baseline for this series? Perhaps a rebase is in
> order..?
> 
> Brian

The base line for the kernel space set is:
eb77b23 xfs: add a xfs_valid_startblock helper

And the user space set is:
e74aec5 xfsprogs: Release v5.3.0-rc1

And xfstests:
cda9817 common/quota: enable project quota correctly on f2fs

Yes, the for-next's may have advanced a bit since, so I'll need to 
update it.  Sometimes stuff moves so fast, by the time I've worked 
through all the conflicts, there's a new for-next already! I kind of 
figured though that people are still sort of settling on what they want 
the design to even look like, especially WRT to the *_later routines 
which are sort of complicated.  So I haven't been too worried about it 
since rebasing is mostly just mechanical adjustments, and it could be 
the next review may take the design in a different direction anyway.

For now though, please use those baselines if you want to apply the 
sets.  I will work on getting the bases updated.

Thanks!

Allison

> 
>>    xfs: Embed struct xfs_name in xfs_da_args
>>    xfs: Add xfs_dabuf defines
>>    xfs: Factor out new helper functions xfs_attr_rmtval_set
>>    xfs: Factor up trans handling in xfs_attr3_leaf_flipflags
>>    xfs: Factor out xfs_attr_leaf_addname helper
>>    xfs: Factor up commit from xfs_attr_try_sf_addname
>>    xfs: Factor up trans roll from xfs_attr3_leaf_setflag
>>    xfs: Add xfs_attr3_leaf helper functions
>>    xfs: Factor out xfs_attr_rmtval_invalidate
>>    xfs: Factor up trans roll in xfs_attr3_leaf_clearflag
>>    xfs: Add delay context to xfs_da_args
>>    xfs: Add delayed attribute routines
>>    xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
>>    xfs: Enable delayed attributes
>>
>> Allison Henderson (4):
>>    xfs: Add xfs_has_attr and subroutines
>>    xfs: Set up infastructure for deferred attribute operations
>>    xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
>>    xfs_io: Add delayed attributes error tag
>>
>>   fs/xfs/Makefile                 |    2 +-
>>   fs/xfs/libxfs/xfs_attr.c        | 1068 ++++++++++++++++++++++++++++++++++-----
>>   fs/xfs/libxfs/xfs_attr.h        |   53 +-
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |  277 ++++++----
>>   fs/xfs/libxfs/xfs_attr_leaf.h   |    7 +
>>   fs/xfs/libxfs/xfs_attr_remote.c |  103 +++-
>>   fs/xfs/libxfs/xfs_attr_remote.h |    4 +-
>>   fs/xfs/libxfs/xfs_da_btree.c    |    8 +-
>>   fs/xfs/libxfs/xfs_da_btree.h    |   27 +-
>>   fs/xfs/libxfs/xfs_defer.c       |    1 +
>>   fs/xfs/libxfs/xfs_defer.h       |    3 +
>>   fs/xfs/libxfs/xfs_dir2.c        |   22 +-
>>   fs/xfs/libxfs/xfs_dir2_block.c  |    6 +-
>>   fs/xfs/libxfs/xfs_dir2_leaf.c   |    6 +-
>>   fs/xfs/libxfs/xfs_dir2_node.c   |    8 +-
>>   fs/xfs/libxfs/xfs_dir2_sf.c     |   30 +-
>>   fs/xfs/libxfs/xfs_errortag.h    |    4 +-
>>   fs/xfs/libxfs/xfs_format.h      |   11 +-
>>   fs/xfs/libxfs/xfs_fs.h          |    1 +
>>   fs/xfs/libxfs/xfs_log_format.h  |   44 +-
>>   fs/xfs/libxfs/xfs_sb.c          |    2 +
>>   fs/xfs/libxfs/xfs_types.h       |    1 +
>>   fs/xfs/scrub/attr.c             |   12 +-
>>   fs/xfs/scrub/common.c           |    2 +
>>   fs/xfs/xfs_acl.c                |   29 +-
>>   fs/xfs/xfs_attr_item.c          |  764 ++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr_item.h          |   88 ++++
>>   fs/xfs/xfs_attr_list.c          |    1 +
>>   fs/xfs/xfs_error.c              |    3 +
>>   fs/xfs/xfs_ioctl.c              |   30 +-
>>   fs/xfs/xfs_ioctl32.c            |    2 +
>>   fs/xfs/xfs_iops.c               |   14 +-
>>   fs/xfs/xfs_log.c                |    4 +
>>   fs/xfs/xfs_log_recover.c        |  173 +++++++
>>   fs/xfs/xfs_ondisk.h             |    2 +
>>   fs/xfs/xfs_super.c              |    4 +
>>   fs/xfs/xfs_trace.h              |   20 +-
>>   fs/xfs/xfs_trans.h              |    1 -
>>   fs/xfs/xfs_xattr.c              |   31 +-
>>   39 files changed, 2509 insertions(+), 359 deletions(-)
>>   create mode 100644 fs/xfs/xfs_attr_item.c
>>   create mode 100644 fs/xfs/xfs_attr_item.h
>>
>> -- 
>> 2.7.4
>>
