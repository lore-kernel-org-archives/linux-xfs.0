Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF17EC4BA09
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE63F21744
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:17:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q6xy4DEN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBZCRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 21:17:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgBZCRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 21:17:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2DZUP038092;
        Wed, 26 Feb 2020 02:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=z4wqb9eMGoGT7tgcY/vOB69kOtUhRS/1RsRCb13ycNY=;
 b=Q6xy4DENkUhLM9MJEoRK+Dgew1aQl5+q91QDbFAZ/YgNVub+msO9XQklFN47KVQm4stz
 06ODyCiZUJigjl/GJoGqWja4b48o1jx0fjKoWdJBQqcQgE36APN0fmWDK0cXGumoO+hg
 fJYG0PEJi1z2TpZX5ztU28EuCcxdFtwm93bb92RcpPVRBoRv+fLdzmIEO+pBbAUtPXFz
 z4JsyiGrd7xRXP46Nd9mTRogysOiH3h+4AoMSWj7qIkIidTalS/jgFHUM2fzv8orL+0G
 kj07VTMgaTExJ1nHrf1TI24NFrYAQoXa/0E7EagZHoLKHK7hPYcZrw+nXbd2L2TSqHWH 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ydcsn8jqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:17:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2EFd6151136;
        Wed, 26 Feb 2020 02:17:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ydcs0tjbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:17:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01Q2H07s026021;
        Wed, 26 Feb 2020 02:17:01 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 18:17:00 -0800
Subject: Re: [PATCH v7 17/19] xfs: Add helper function
 xfs_attr_leaf_mark_incomplete
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-18-allison.henderson@oracle.com>
 <20200225093143.GL10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <639a59bb-cddf-ce03-2a49-d4113caa8e38@oracle.com>
Date:   Tue, 25 Feb 2020 19:17:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225093143.GL10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 2:31 AM, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:06:09PM -0700, Allison Collins wrote:
>> This patch helps to simplify xfs_attr_node_removename by modularizing the code
>> around the transactions into helper functions.  This will make the function easier
>> to follow when we introduce delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Another candidate for being at the start of this patchset.
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>>   1 file changed, 31 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index dd935ff..b9728d1 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1416,6 +1416,36 @@ xfs_attr_node_shrink(
>>   }
>>   
>>   /*
>> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
>> + * for later deletion of the entry.
>> + */
>> +STATIC int
>> +xfs_attr_leaf_mark_incomplete(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	int error;
>> +
>> +	/*
>> +	 * Fill in disk block numbers in the state structure
>> +	 * so that we can get the buffers back after we commit
>> +	 * several transactions in the following calls.
>> +	 */
> 
> Reformat to use all 80 columns.
> 
> [ Handy vim hints, add this to your .vimrc:
> 
> " set the textwidth to 80 characters for C code
>   au BufNewFile,BufRead *.c,*.h set tw=80
> 
> " set the textwidth to 68 characters for guilt commit messages
>   au BufNewFile,BufRead guilt.msg.*,.gitsendemail.*,git.*,*/.git/* set tw=68
> 
> " Formatting the current paragraph according to
> " the current 'textwidth' with ^J (control-j):
>    imap <C-J> <c-o>gqap
>     map <C-J> gqap
> 
> " highlight textwidth
> set cc=+1
> 
> ]

Ah, alrighty, I will try these out and update the comment.

Thanks!
Allison
> 
> Cheers,
> 
> Dave.
> 
