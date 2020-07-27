Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D883C433E5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 22:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 444712075D
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 22:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wv3h7ROW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgG0WUT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 18:20:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0WUS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 18:20:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RMHfck122162;
        Mon, 27 Jul 2020 22:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Pn2Ld3nRO3YXMmwCgCULiSwkKN2n9nClQ3+5rR96aXQ=;
 b=wv3h7ROWXC1Z+PDHKWelWmeNXTIbdLgxqrwPJ1JI1KgKSpkCMe/wpBg8ytO1IDDrXJvd
 /DkW4BksXWPUyjdmMq/kUybT5ZfiWGMmWXq9QalnPDSSvDKUjfNtmSOThdDbHLEZnQP3
 9fbcdYoQjcijL+k0Y9OZqaJLPWpqarmec36SPKEhAWqtE9PvGrdGROhAFaW5USi50tjB
 cmXK3ZdCLEHyV/dTOv970biqVzO4gI6WZKWaH8RtiCMqXhKfEixWoXU2Uu6Gf2QBDXVP
 4nYYmPpg+vMcJVZKCxQeXsDBAlXubHYQkzkFnhLNa4dVne6KZqbcelF8xYYWrmZRdEB4 cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32hu1jc644-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 22:20:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RMIfLX035254;
        Mon, 27 Jul 2020 22:20:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32hu5t9a2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 22:20:15 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RMKEJt021024;
        Mon, 27 Jul 2020 22:20:14 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 15:20:14 -0700
Subject: Re: [PATCH v3 2/2] xfs: Fix compiler warning in
 xfs_attr_shortform_add
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20200727200656.6318-1-allison.henderson@oracle.com>
 <20200727200656.6318-3-allison.henderson@oracle.com>
 <4144b860-1cae-3f68-9ea8-0fa159783047@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <15d8413e-8e50-f1dd-e5cf-c2fb16f47645@oracle.com>
Date:   Mon, 27 Jul 2020 15:20:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4144b860-1cae-3f68-9ea8-0fa159783047@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/20 2:58 PM, Eric Sandeen wrote:
> On 7/27/20 1:06 PM, Allison Collins wrote:
>> Fix compiler warning warning: variable 'error' set but not used in
>> xfs_attr_shortform_add. error is used only in an ASSERT so only declare
>> error when DEBUG is set.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> same problem...
> 
> you've made the existence of "error" conditional on DEBUG, but
> then you unconditionally assign to it in the function:
> 
> 	error = xfs_attr_sf_findname(args, &sfe, NULL);
>          ASSERT(error != -EEXIST);
> 
> so this won't build.
Hmm, should I add some error handling back in then?  Maybe just
	if (error == -EEXIST)
		return;

Right after the ASSERT?  I think that makes all the compiler configs 
correct then?

Allison
> 
> -Eric
> 
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index ad7b351..db985b8 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -715,7 +715,10 @@ xfs_attr_shortform_add(
>>   {
>>   	struct xfs_attr_shortform	*sf;
>>   	struct xfs_attr_sf_entry	*sfe;
>> -	int				offset, size, error;
>> +	int				offset, size;
>> +#if DEBUG
>> +	int				error;
>> +#endif
>>   	struct xfs_mount		*mp;
>>   	struct xfs_inode		*dp;
>>   	struct xfs_ifork		*ifp;
>>
