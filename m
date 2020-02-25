Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED33FC4BA06
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBE824680
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qaF4FYyk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgBYX1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:27:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44904 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730684AbgBYX1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:27:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PNNkX1113314;
        Tue, 25 Feb 2020 23:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kw/hIgaKa9JEX0MIvjVCcmidn4UjSWOuKd3RglnL37M=;
 b=qaF4FYyk27bFFgHaZB8H6iZCVfq2YaUcVRvqvn4Q7kdfQjVji02oYoC5J5q7grdXctqY
 WF8G9Bw1MW2YZGMTc4MZynqfJJWdOLR/AuCaqgqof4RsTEzKU3dFDn+wgRcxENFZbRaS
 ouhoCubDSPFXjs9yDh08p+uuLMTMgRFIKfo19HwfINgMnJ9t1E+VNUS3KWimR8Qhj56c
 3KWGsuwXjLHqcsac8pKDHV8F43/wglwmwM3RYph27RKkVBH0FFjWWO/jbveU8buNHnsR
 WY9/JqchcieA+qiiDzlfd5ymm+Mhqgfu3vjFm97nh1blbEjv3mr5tVA85RPiL3I5Csfb cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ydcsrg373-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 23:27:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PNI0Cw176877;
        Tue, 25 Feb 2020 23:27:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ydcs1hbb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 23:27:17 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PNRGF3016920;
        Tue, 25 Feb 2020 23:27:16 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 15:27:16 -0800
Subject: Re: [PATCH v7 12/19] xfs: Add helper function xfs_attr_rmtval_unmap
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-13-allison.henderson@oracle.com>
 <20200225072103.GH10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <40b03f50-d9db-20af-0eff-8fb95abe00d9@oracle.com>
Date:   Tue, 25 Feb 2020 16:27:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225072103.GH10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 12:21 AM, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:06:04PM -0700, Allison Collins wrote:
>> This function is similar to xfs_attr_rmtval_remove, but adapted to return EAGAIN for
>> new transactions. We will use this later when we introduce delayed attributes
> 
> 68-72 columns...
> 
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 28 ++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 29 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 3de2eec..da40f85 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -711,3 +711,31 @@ xfs_attr_rmtval_remove(
>>   	}
>>   	return 0;
>>   }
>> +
>> +/*
>> + * Remove the value associated with an attribute by deleting the out-of-line
>> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>> + * transaction and recall the function
>> + */
>> +int
>> +xfs_attr_rmtval_unmap(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int	error, done;
> 
> Best to initialise done to zero here.
> 
>> +
>> +	/*
>> +	 * Unmap value blocks for this attr.  This is similar to
>> +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
>> +	 * for new transactions
>> +	 */
>> +	error = xfs_bunmapi(args->trans, args->dp,
>> +		    args->rmtblkno, args->rmtblkcnt,
>> +		    XFS_BMAPI_ATTRFORK, 1, &done);
> 
> Got 80 columns for code, please use them all :)
> 
>> +	if (error)
>> +		return error;
>> +
>> +	if (!done)
>> +		return -EAGAIN;
> 
> Hmmm, I guess I'm missing the context at this point: why not just pass the done
> variable all the way back to the caller that will be looping on this function
> call?
> 
> That turns this function into:
> 
> int
> xfs_attr_rmtval_unmap(
> 	struct xfs_da_args      *args,
> 	bool			*donec
> {
> 	return xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> 				args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, done);
> }
Well, this is a helper we talked about adding in the v5 review ([PATCH 
v5 13/14] xfs: Add delay ready attr remove routines)  In v5, I did not 
have this helper function, and just open coded xfs_attr_rmtval_remove in 
the middle of the calling function (xfs_attr_remove_iter), except with 
out the transaction.  Then later we identified it as an area we could 
modularize.  It's kind of hard to see the bigger picture with out the 
states being here yet.  But really what we're trying to do is modularize 
everything that shows up between the states later in the set.

Hope that helps a bit!
Allison

> 
> Cheers,
> 
> Dave.
> 
