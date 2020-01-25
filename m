Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B026C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 16:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03E522070A
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 16:41:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oDvme29Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAYQlw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 11:41:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38558 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAYQlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 11:41:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00PGXxJh120585
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jan 2020 16:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gc9cnrEdqrNeD5tnuriYwBFCG0iSo6laTSWuewEKXDM=;
 b=oDvme29QTopDCFUS+86ULnC9PFvw5jysuGaZ0wbSIikc+lN49tRRlhQ9GvuEUllchoDo
 AfAdxK8Acs3oVqwVXpCtx2ScEELxBUykwVrGUtJrh38aYTgw9jxe7LdArWg6nq0ELwXH
 5qLpnqDz9A3FTYU8mHHukEKVEbe35U3p/Hz6T4DDafcEQux7E65zBLiTrIz3uuWM+I8w
 P6Y4/r8bmI1A4DApRkWGMUhEzZrXGx/Fu+xuNYNwy7zHtPhezuoz4mdvCDSxo3HO9+oX
 ep7TjALGue0hKJnAik+Z6yi9zKCM5FpuQdIHS9aJgZOANggHZX7czCZM2JtlqJmPng/S iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xrdmq1d2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jan 2020 16:41:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00PGWLFd009632
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jan 2020 16:41:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xrdh4b4b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jan 2020 16:41:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00PGfmg1027246
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jan 2020 16:41:49 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jan 2020 08:41:47 -0800
Subject: Re: [PATCH v6 11/16] xfs: Check for -ENOATTR or -EEXIST
From:   Allison Collins <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-12-allison.henderson@oracle.com>
 <20200121231530.GK8247@magnolia>
 <68dcf7a7-9e10-2d64-9c5c-d520d2372c2b@oracle.com>
Message-ID: <26a49cf4-52df-55bd-67bb-9c0c981a860d@oracle.com>
Date:   Sat, 25 Jan 2020 09:41:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <68dcf7a7-9e10-2d64-9c5c-d520d2372c2b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001250139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001250139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/21/20 9:29 PM, Allison Collins wrote:
> 
> 
> On 1/21/20 4:15 PM, Darrick J. Wong wrote:
>> On Sat, Jan 18, 2020 at 03:50:30PM -0700, Allison Collins wrote:
>>> Delayed operations cannot return error codes.  So we must check for
>>> these conditions first before starting set or remove operations
>>
>> Answering my own question from earlier -- I see here you actually /are/
>> checking the attr existence w.r.t. ATTR_{CREATE,REPLACE} right after we
>> allocate a transaction and ILOCK the inode, so
>>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Alrighty, thank you!
> 
>>
>> Though I am wondering if you could discard the predicates from the
>> second patch in favor of doing a normal lookup of the attr with a zero
>> valuelen to determine if there's already an attribute?
> I think I likely answered this in the response to that patch.  Because 
> it's used as part of the remove procedures, we still need it.  We could 
> make a simpler version just for this application I suppose, but it seems 
> like it'd just be extra code since we still need the former.
> 
> Thank you for the reviews!
> Allison
> 
>>
>> --D
>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
>>>   1 file changed, 12 insertions(+)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index a2673fe..e9d22c1 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -457,6 +457,14 @@ xfs_attr_set(
>>>           goto out_trans_cancel;
>>>       xfs_trans_ijoin(args.trans, dp, 0);
>>> +
>>> +    error = xfs_has_attr(&args);
>>> +    if (error == -EEXIST && (name->type & ATTR_CREATE))
>>> +        goto out_trans_cancel;
>>> +
>>> +    if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>>> +        goto out_trans_cancel;
>>> +
>>>       error = xfs_attr_set_args(&args);
So I was thinking of adding this one to a smaller 3 patch series I 
mentioned earlier.  I was also thinking of adding in some asserts here:

ASSERT(error != -EEXIST)
ASSERT(error != -ENOATTR)

Just to make sure the changes are enforcing the behavioral changes that 
we want.  I thought this might be a good stabilizer to the rest of the 
delayed attr series.  Because chasing this bug back up through the log 
replay is a much bigger PITA than catching it here.  Thoughts?

>>>       if (error)
>>>           goto out_trans_cancel;
>>> @@ -545,6 +553,10 @@ xfs_attr_remove(
>>>        */
>>>       xfs_trans_ijoin(args.trans, dp, 0);
>>> +    error = xfs_has_attr(&args);
>>> +    if (error != -EEXIST)
>>> +        goto out;
>>> +
Here too:
ASSERT(error != -EEXIST)

Let me know what folks think.  Thanks!

Allison

>>>       error = xfs_attr_remove_args(&args);
>>>       if (error)
>>>           goto out;
>>> -- 
>>> 2.7.4
>>>
