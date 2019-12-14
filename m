Return-Path: <SRS0=IS9S=2E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A92C43603
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 07:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B73F2073D
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 07:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ATKZWeYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfLNH4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Dec 2019 02:56:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfLNH4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Dec 2019 02:56:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE7sKka103687;
        Sat, 14 Dec 2019 07:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=sj82Hn+XtGPMmmEU5FfplfwUMOOYHu9JXpBwGHOyzEk=;
 b=ATKZWeYfayds6hV9AgJk7AJp+QcGtVxbmldDqlx8+63JjBQr4gZ3P7HcN8Z+oJoB+Q+e
 iKPvVCVHTJ2deJX+a9x3CmTYcUzk0ytz19TFDLkNeinqP0SjtbVM0n39dsFanAN/CSfI
 S4gdcRu5DIES0F0bsW/JC100q0myAnPm94TOGZwWwZ17UVctvtSWe/7nT4W5P7BpIl2i
 1XXjRhHi/3lLFVJ+eQSkTnBhsRG1ikV/TqLrowM7ryX+iJOqkyD/v6x7nKDR3+GszTQt
 WAcewSehUKBcYCUOdE77BtuwH7bQ1rA/dRMVuYftuUWZqDMIJwfaMN41Ic09Qki4foHi Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcqrb9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 07:56:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE7rvX1186811;
        Sat, 14 Dec 2019 07:56:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wvqjuhc2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 07:56:17 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBE7uGox015038;
        Sat, 14 Dec 2019 07:56:16 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 23:56:16 -0800
Subject: Re: [PATCH v5 12/14] xfs: Check for -ENOATTR or -EEXIST
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-13-allison.henderson@oracle.com>
 <20191213141601.GF43376@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f49ed64e-559a-30d9-2799-74de988f7c58@oracle.com>
Date:   Sat, 14 Dec 2019 00:56:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191213141601.GF43376@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140057
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/13/19 7:16 AM, Brian Foster wrote:
> On Wed, Dec 11, 2019 at 09:15:11PM -0700, Allison Collins wrote:
>> Delayed operations cannot return error codes.  So we must check for
>> these conditions first before starting set or remove operations
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index a3dd620..b5a5c84 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -446,6 +446,18 @@ xfs_attr_set(
>>   		goto out_trans_cancel;
>>   
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>> +
>> +	error = xfs_has_attr(&args);
>> +	if (error == -EEXIST) {
>> +		if (name->type & ATTR_CREATE)
>> +			goto out_trans_cancel;
>> +		else
>> +			name->type |= ATTR_REPLACE;
> 
> Hmm.. this bit looks funny to me. Shouldn't this already be set by
> userspace? What's the reason for setting it here?
> 
> Brian
There was a reason I did this, and now i'm trying to remember what it 
was.  I'm pretty sure it's reminiscent of an earlier series that handled 
a replace with explicit remove and set to avoid in flight error codes 
with delayed operations.  I think I can take it out at this point 
though, the set has gone through a lot of changes since.

Allison

> 
>> +	}
>> +
>> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>> +		goto out_trans_cancel;
>> +
>>   	error = xfs_attr_set_args(&args);
>>   	if (error)
>>   		goto out_trans_cancel;
>> @@ -534,6 +546,10 @@ xfs_attr_remove(
>>   	 */
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>>   
>> +	error = xfs_has_attr(&args);
>> +	if (error != -EEXIST)
>> +		goto out;
>> +
>>   	error = xfs_attr_remove_args(&args);
>>   	if (error)
>>   		goto out;
>> -- 
>> 2.7.4
>>
> 
