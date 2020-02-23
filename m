Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22C2C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B85E3206E2
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dMkOyWg2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgBWSwP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 13:52:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60710 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWSwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 13:52:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIgRIh068178;
        Sun, 23 Feb 2020 18:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r7GeuIWgQZe9/1aQUFghB+ek97t8bzvr5xePrmxhTbQ=;
 b=dMkOyWg2j1kBfkRXZYi+w12B97NGRF+JYnySsfPmOAvp6f9YpyWydy6IsrIIqKQKLdmk
 nKIoQAEV5VkddmwZwqRmBRmf6c/drqJ7Ua4dkj56dH6TGtf2NtPbmn/qpHcrgQQ6dKcO
 rXFx3T3AtcnRP/5Xt+FzYBpjqFlZB0NSd+0/0B/U1FURu29XZk4BFNi97Y7mIKcBPZMc
 ED5hB80Ezy3kUcBbX81csRM0WXw/BZGL5N56HF0KnVv4qtRIoxGbagruUWhbfZz/bgsH
 9sbkvyslg4QejyqKDt3wVNy0u3SovEyoNFajAoEp7beTt4xX3eKiVyuC5XFGDQAVn3Fx xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yavxrbvy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:52:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIfqqu137884;
        Sun, 23 Feb 2020 18:50:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ybe0yark6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:50:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01NIoBA7027589;
        Sun, 23 Feb 2020 18:50:12 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 10:50:11 -0800
Subject: Re: [PATCH v7 19/19] xfs: Remove xfs_attr_rmtval_remove
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-20-allison.henderson@oracle.com>
 <CAOQ4uxiOE0h6g0ausoxJ2N9ZABh1SDLgt=Cu4Kfn2G7fmnJDHw@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <3a887119-1570-9276-e272-9943b5c0e5ce@oracle.com>
Date:   Sun, 23 Feb 2020 11:50:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiOE0h6g0ausoxJ2N9ZABh1SDLgt=Cu4Kfn2G7fmnJDHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 6:54 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> xfs_attr_rmtval_remove is no longer used.  Clear it out now
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Patch 12/19 add a new function similar to this one called
> xfs_attr_rmtval_unmap() and now this function is removed.
> I wonder if it wouldn't have been simpler to keep the original function
> name and change its behavior to that of xfs_attr_rmtval_unmap().
I thought about this, but then decided against it.  Really what's 
happening is that the original function disappears across patches 13 and 
14, and I wanted to keep those patches focused on the state machine 
rather than lumping the helpers in with it.

> 
> Unless the function name change makes the logic change more clear
> for the future users???

I think they are about equivalent myself.  But the name difference helps 
the old function to stick around until it is completely phased out.  If 
folks feel strongly though, please chime in :-)

Thanks for the reviews!  I know it's a lot!

Allison

> 
>>   fs/xfs/libxfs/xfs_attr_remote.c | 42 -----------------------------------------
>>   fs/xfs/xfs_trace.h              |  1 -
>>   2 files changed, 43 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index a0e79db..0cc0ec1 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -734,48 +734,6 @@ xfs_attr_rmtval_invalidate(
>>   }
>>
>>   /*
>> - * Remove the value associated with an attribute by deleting the
>> - * out-of-line buffer that it is stored on.
>> - */
>> -int
>> -xfs_attr_rmtval_remove(
>> -       struct xfs_da_args      *args)
>> -{
>> -       xfs_dablk_t             lblkno;
>> -       int                     blkcnt;
>> -       int                     error = 0;
>> -       int                     done = 0;
>> -
>> -       trace_xfs_attr_rmtval_remove(args);
>> -
>> -       error = xfs_attr_rmtval_invalidate(args);
>> -       if (error)
>> -               return error;
>> -       /*
>> -        * Keep de-allocating extents until the remote-value region is gone.
>> -        */
>> -       lblkno = args->rmtblkno;
>> -       blkcnt = args->rmtblkcnt;
>> -       while (!done) {
>> -               error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>> -                                   XFS_BMAPI_ATTRFORK, 1, &done);
>> -               if (error)
>> -                       return error;
>> -               error = xfs_defer_finish(&args->trans);
>> -               if (error)
>> -                       return error;
>> -
>> -               /*
>> -                * Close out trans and start the next one in the chain.
>> -                */
>> -               error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -               if (error)
>> -                       return error;
>> -       }
>> -       return 0;
>> -}
>> -
>> -/*
>>    * Remove the value associated with an attribute by deleting the out-of-line
>>    * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>>    * transaction and recall the function
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index 159b8af..bf9a683 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -1775,7 +1775,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
>>
>>   DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
>>   DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
>> -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
>>
>>   #define DEFINE_DA_EVENT(name) \
>>   DEFINE_EVENT(xfs_da_class, name, \
>> --
>> 2.7.4
>>
