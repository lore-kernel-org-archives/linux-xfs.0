Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7430DC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42B5320656
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xdeE9TGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgBWRgF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:36:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWRgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 12:36:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHYVKA152724;
        Sun, 23 Feb 2020 17:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JAEUp9/w/7l+WE5uiZBRVqAoENiwtv6Z/sloq7Dj16Y=;
 b=xdeE9TGNLkY/s6AXk9YULP9ptkMiuWGlFNC7sI488lhIzY8DXy0nTD+diO3IL6kiBCoD
 vJVlJRE4jLtDNYNnZb9cS++iuwMqpKJWzjJ9N5Eh7qn+8ElUmz9HYSwHCUPmDs6a4raE
 s6cysj78a74xghU135hAbbfXfFCgkchtG377eh6chglr/fJhlGz3M637MSfZh6mHck+4
 1eyLCkBGLmTLPBVT9/oIjFRx+y3HqWHpKbEbX6kLQXKIwTmJU6yznfkiG9HVgCeniO1p
 t7QS9oJDvZMf8KdN8+ZvbWk9Ffxld7pWTFTT5Q/RwOWl9NsbXLaew425JWXxz+lEKkCS aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yavxrbswh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:36:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHW8ie116318;
        Sun, 23 Feb 2020 17:36:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ybe3ck2c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:36:02 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01NHa2Ak030845;
        Sun, 23 Feb 2020 17:36:02 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 09:36:02 -0800
Subject: Re: [PATCH v7 06/19] xfs: Factor out trans handling in
 xfs_attr3_leaf_flipflags
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-7-allison.henderson@oracle.com>
 <CAOQ4uxjsQSzcTWWvybT2DAkE=DPoek-hGqL0zPZt8EO6oLUdJw@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <efc8adc9-9d84-e7be-d7aa-8cc4b584cc65@oracle.com>
Date:   Sun, 23 Feb 2020 10:36:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjsQSzcTWWvybT2DAkE=DPoek-hGqL0zPZt8EO6oLUdJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 5:30 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> Since delayed operations cannot roll transactions, factor up the transaction
>> handling into the calling function
> 
> I am not a native English speaker, so not sure what the correct phrase is,
> but I'm pretty sure its not factor up, nor factor out???
Sorry, I got used to this usage on another team though only recently 
have people mention they thought it odd.  I meant to clean them out and 
must of missed this one.  Will remove.

Allison

> 
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  7 +------
>>   2 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index a2f812f..cf0cba7 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -739,6 +739,13 @@ xfs_attr_leaf_addname(
>>                  error = xfs_attr3_leaf_flipflags(args);
>>                  if (error)
>>                          return error;
>> +               /*
>> +                * Commit the flag value change and start the next trans in
>> +                * series.
>> +                */
>> +               error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +               if (error)
>> +                       return error;
>>
>>                  /*
>>                   * Dismantle the "old" attribute/value pair by removing
>> @@ -1081,6 +1088,13 @@ xfs_attr_node_addname(
>>                  error = xfs_attr3_leaf_flipflags(args);
>>                  if (error)
>>                          goto out;
>> +               /*
>> +                * Commit the flag value change and start the next trans in
>> +                * series
>> +                */
>> +               error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +               if (error)
>> +                       goto out;
>>
>>                  /*
>>                   * Dismantle the "old" attribute/value pair by removing
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 9d6b68c..d691509 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2973,10 +2973,5 @@ xfs_attr3_leaf_flipflags(
>>                           XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>>          }
>>
>> -       /*
>> -        * Commit the flag value change and start the next trans in series.
>> -        */
>> -       error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -
>> -       return error;
>> +       return 0;
>>   }
>> --
>> 2.7.4
>>
