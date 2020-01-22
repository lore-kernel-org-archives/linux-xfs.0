Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A71C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 00:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50014217F4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 00:28:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ByuNbA2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAVA2D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 19:28:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43860 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVA2D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 19:28:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M08oxx066546;
        Wed, 22 Jan 2020 00:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QMA/qZNj+IqD60n6CuxNrZe+Myto8ih23uf1NMkyxIQ=;
 b=ByuNbA2rQBJpIyzKl3d8C7fvg9BGDNYkZEoqx+C89bRAvP9QzxfeWTk3ATXMNEYKpfoc
 vQ5k2aCR9zHT2WuWgY9EvBG4K3xgoP3AePL/zCQoPtMhlGolhRQ8marwLAg/QcDTmRRL
 SXvgf2Ngu2ufxhTHh29HmfsgKZ7HwGiedloKiRf2te+gUZT2sHQOv+GwsOiFtzeXEE72
 faj/BN4ePrPaJ2H8lD01LDNCBLNMQBTN3MFw3aUKdYsLncTpbsFqsmJPmBBFLcYHmDuE
 8lIlVpxguleCSBcfjdUhcuVKGpzt7kFR4ko2G+io5UU2g1UjzSKcyxuA7WjTs9pfE4me vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xktnr8e8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 00:27:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M08kE5005413;
        Wed, 22 Jan 2020 00:25:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xnsj5q30a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 00:25:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00M0PmtM024142;
        Wed, 22 Jan 2020 00:25:49 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 16:25:48 -0800
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
 <20191224121830.GD18379@infradead.org>
 <2b29c0a0-03bb-8a21-8a8a-fd4754bff3ff@oracle.com>
 <20200121223059.GG8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <6f955cc1-8739-7c00-0dcb-0b9e4a912380@oracle.com>
Date:   Tue, 21 Jan 2020 17:25:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121223059.GG8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/20 3:30 PM, Darrick J. Wong wrote:
> On Tue, Dec 24, 2019 at 09:21:49PM -0700, Allison Collins wrote:
>> On 12/24/19 5:18 AM, Christoph Hellwig wrote:
>>> On Wed, Dec 11, 2019 at 09:15:03PM -0700, Allison Collins wrote:
>>>> From: Allison Henderson <allison.henderson@oracle.com>
>>>>
>>>> This patch adds a new functions to check for the existence of
>>>> an attribute.  Subroutines are also added to handle the cases
>>>> of leaf blocks, nodes or shortform.  Common code that appears
>>>> in existing attr add and remove functions have been factored
>>>> out to help reduce the appearance of duplicated code.  We will
>>>> need these routines later for delayed attributes since delayed
>>>> operations cannot return error codes.
>>>
>>> Can you explain why we need the ahead of time check?  The first
>>> operation should be able to still return an error, and doing
>>> a separate check instead of letting the actual operation fail
>>> gracefully is more expensive, and also creates a lot of additional
>>> code.  As is I can't say I like the direction at all.
>>>
>>
>> This one I can answer quickly: later when we get into delayed attributes,
>> this will get called from xfs_defer_finish_noroll as part of a .finish_item
>> call back.  If these callbacks return anything other than 0 or -EAGAIN, it
>> causes a shutdown.
> 
> When does this happen, exactly?  

Sure, lets take a look at fs/xfs/libxfs/xfs_defer.c line 399
We have the callback invocation:
error = ops->finish_item(*tp, li, dfp->dfp_done, &state);

This is where the intent items get to finish out their operations.  If 
they return -EAGAIN, they get get put back in the list, but if they 
error out, we jump to the error handler (line 445), where we abort the 
transaction and do a shutdown.


Now, if we peek ahead at the first patch that belongs to the next 
delayed attribute series:

https://github.com/allisonhenderson/xfs_work/commit/7d5b7395fe3b1df7739089c0643e20b09de2e0b0

If you expand the diff for fs/xfs/xfs_attr_item.c, and zip down to line 
269, you'll see a ".finish_item	= xfs_attr_finish_item".  This callback 
will do some leg work to unwrap the log item and feed the appropriate 
parameters back into xfs_attr_set_iter.  So this is why we go through 
all the trouble to check for any expected errors ahead of time.


Are you saying that during log
> recovery, we can end up replaying a delayed attr log item that hits
> ENOATTR/EEXIST somewhere and passes that out, which causes log recovery
> to fail?
Well, the idea is to avoid that with this helper function.  Reading 
ahead, it looks like you've already connected the two :-)

> 
>> Which is not what we would want for example: when the
>> user tries to rename a non-existent attribute.  The error code needs to go
>> back up.  So we check for things like that before starting a delayed
>> operation.  Hope that helps.  Thanks!
> 
> ...because as far as requests from user programs goes, we should be
> doing all these precondition checks after allocating a transaction and
> ILOCKing the inode, so that we can send the error code back to userspace
> without cancelling a dirty transaction.
Yes, we do that later in the set, but I think you've got it ;-)

Allison

> 
> (I dunno, am I misunderstanding here?)
> 
>> Allison
