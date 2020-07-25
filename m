Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E9FC433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 02:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A278206EB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 02:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f2W85SOj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGYCw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:52:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYCw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 22:52:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2kdc2076934;
        Sat, 25 Jul 2020 02:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zi/y8cT+oPruIzvr1+pRqSjAm9AFb9OGj3u66UKFhtI=;
 b=f2W85SOjjy8mbeLuzoqom3Vy18kdm7QWJFPW7qEZmhePwLum3B4NYZzM83Dr/W4f58dx
 honEJwdOEUBDSFk1xgeYDZ9bf7kgaJ9xclzQ0LQW5L4NLJ6Mzy8MNtqmRPVXB/f7gKzd
 VjqdmFIg6SozmcgnclIB/alcWfCIJrtj92X4WlLn0gKCQ/6g3CAJsW3Z1ro/8tg5r8P9
 bj9eOKywLd0t+W9CKR8A9EIvwHWjUzGiZtKjQDygv9mJIT9NKOq+3PsdmCMGEwF/rBz9
 b8Wig3M96P3jIHZ4yJ/TKDHNAk2/KqANIVKofY0C7itjr4CDm6xkebjbQVI3Y0Dmdol1 RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32gc5qr0gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:52:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mEwX001236;
        Sat, 25 Jul 2020 02:50:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32gam27fmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:50:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2oP4p004091;
        Sat, 25 Jul 2020 02:50:25 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:50:25 +0000
Subject: Re: [PATCH v11 00/25] xfs: Delay Ready Attributes
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200724034100.GN2005@dread.disaster.area>
 <20200724053526.GP2005@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c33602dd-1705-f6ad-ec07-d4b6b553e514@oracle.com>
Date:   Fri, 24 Jul 2020 19:50:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724053526.GP2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/23/20 10:35 PM, Dave Chinner wrote:
> On Fri, Jul 24, 2020 at 01:41:00PM +1000, Dave Chinner wrote:
>> On Mon, Jul 20, 2020 at 05:15:41PM -0700, Allison Collins wrote:
>>> Hi all,
>>>
>>> This set is a subset of a larger series for delayed attributes. Which is a
>>> subset of an even larger series, parent pointers. Delayed attributes allow
>>> attribute operations (set and remove) to be logged and committed in the same
>>> way that other delayed operations do. This allows more complex operations (like
>>> parent pointers) to be broken up into multiple smaller transactions. To do
>>> this, the existing attr operations must be modified to operate as either a
>>> delayed operation or a inline operation since older filesystems will not be
>>> able to use the new log entries.  This means that they cannot roll, commit, or
>>> finish transactions.  Instead, they return -EAGAIN to allow the calling
>>> function to handle the transaction. In this series, we focus on only the clean
>>> up and refactoring needed to accomplish this. We will introduce delayed attrs
>>> and parent pointers in a later set.
>>>
>>> At the moment, I would like people to focus their review efforts on just this
>>> "delay ready" subseries, as I think that is a more conservative use of peoples
>>> review time.  I also think the set is a bit much to manage all at once, and we
>>> need to get the infrastructure ironed out before we focus too much anything
>>> that depends on it. But I do have the extended series for folks that want to
>>> see the bigger picture of where this is going.
>>>
>>> To help organize the set, I've arranged the patches to make sort of mini sets.
>>> I thought it would help reviewers break down the reviewing some. For reviewing
>>> purposes, the set could be broken up into 4 different phases:
>>>
>>> Error code filtering (patches 1-2):
>>> These two patches are all about finding and catching error codes that need to
>>> be sent back up to user space before starting delayed operations.  Errors that
>>> happen during a delayed operation are treated like internal errors that cause a
>>> shutdown.  But we wouldnt want that for example: when the user tries to rename
>>> a non existent attr.  So the idea is that we need to find all such conditions,
>>> and take care of them before starting a delayed operation.
>>>     xfs: Add xfs_has_attr and subroutines
>>>     xfs: Check for -ENOATTR or -EEXIST
>>>
>>> Move transactions upwards (patches 3-12):
>>> The goal of this subset is to try and move all the transaction specific code up
>>> the call stack much as possible.  The idea being that once we get them to the
>>> top, we can introduce the statemachine to handle the -EAGAIN logic where ever
>>> the transactions used to be.
>>>    xfs: Factor out new helper functions xfs_attr_rmtval_set
>>>    xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
>>>    xfs: Split apart xfs_attr_leaf_addname
>>>    xfs: Refactor xfs_attr_try_sf_addname
>>>    xfs: Pull up trans roll from xfs_attr3_leaf_setflag
>>>    xfs: Factor out xfs_attr_rmtval_invalidate
>>>    xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
>>>    xfs: Refactor xfs_attr_rmtval_remove
>>>    xfs: Pull up xfs_attr_rmtval_invalidate
>>>    xfs: Add helper function xfs_attr_node_shrink
>>>
>>> Modularizing and cleanups (patches 13-22):
>>> Now that we have pulled the transactions up to where we need them, it's time to
>>> start breaking down the top level functions into new subfunctions. The goal
>>> being to work towards a top level function that deals mostly with the
>>> statemachine, and helpers for those states
>>>    xfs: Remove unneeded xfs_trans_roll_inode calls
>>>    xfs: Remove xfs_trans_roll in xfs_attr_node_removename
>>>    xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
>>>    xfs: Add helper function xfs_attr_leaf_mark_incomplete
>>>    xfs: Add remote block helper functions
>>>    xfs: Add helper function xfs_attr_node_removename_setup
>>>    xfs: Add helper function xfs_attr_node_removename_rmt
>>>    xfs: Simplify xfs_attr_leaf_addname
>>>    xfs: Simplify xfs_attr_node_addname
>>>    xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
>>
>> I'm happy to see everything up to here merged.
> 
> BTW, that translates as:
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>
> 
> For the first 22 patches.
Alrighty, thank you!!

Allison

> 
> -Dave.
> 
