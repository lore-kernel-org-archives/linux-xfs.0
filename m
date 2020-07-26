Return-Path: <SRS0=7j32=BF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACDCC433E1
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jul 2020 18:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8789D2065F
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jul 2020 18:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BxVz57kj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGZSKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 14:10:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgGZSKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 14:10:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06QI8wBo071408;
        Sun, 26 Jul 2020 18:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Nv0UqfEaNWqNWYV7wmwERgHrNlwsvD86rMIhbNf+AhA=;
 b=BxVz57kjbYjuDkel7EOwJMyPbV66jxflUyONhXLnagd4aAgp4bCVdG/557g3miN4+DKG
 tgIJH3G1OOYNcEJCJmtSnJkTv3moSo6B8X4bzoiMyOpmsTy66ga+Q5DvpFHMSemv/4+W
 oHRTXgbyr40v3W2RWefbzh8RRDA+GakKxx2oPK1WaIXjZNL4XSuBsaj1bt8c0oLOzUcf
 NoPnCIDQh9XqbT5dtpTCS9DvoH0S3cNaR5Xx56sRO9O2l/Y/86rh26Bvsq+lT0cwW3BN
 NJluw7dXEAyOAFESm1z2e9H2z+HzdSPypKftEotA5c/uIE7S9RmVc6TYHM/MUx2OPhhp xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32gx46hmh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 26 Jul 2020 18:10:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06QI9DsD064357;
        Sun, 26 Jul 2020 18:10:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32hdppaw0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jul 2020 18:10:32 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06QIAVYB017936;
        Sun, 26 Jul 2020 18:10:32 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jul 2020 11:10:31 -0700
Subject: Re: [PATCH 2/2] xfs: Fix compiler warning in xfs_attr_shortform_add
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20200725230102.22192-1-allison.henderson@oracle.com>
 <20200725230102.22192-3-allison.henderson@oracle.com>
 <ae37c9e6-8e21-51ad-b8ca-a32e1bc7343e@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <cc8bd065-7990-eee7-de49-fc29a6a8e45a@oracle.com>
Date:   Sun, 26 Jul 2020 11:10:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ae37c9e6-8e21-51ad-b8ca-a32e1bc7343e@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007260143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007260143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/25/20 11:48 PM, Eric Sandeen wrote:
> On 7/25/20 4:01 PM, Allison Collins wrote:
>> @@ -730,7 +730,8 @@ xfs_attr_shortform_add(
>>   	ASSERT(ifp->if_flags & XFS_IFINLINE);
>>   	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>>   	error = xfs_attr_sf_findname(args, &sfe, NULL);
>> -	ASSERT(error != -EEXIST);
>> +	if (error == -EEXIST)
>> +		return error;
>>   
>>   	offset = (char *)sfe - (char *)sf;
>>   	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> 
> ASSERTs are normally "this cannot happen unless somebody made a
> programming mistake," not an error that can actually happen in normal
> use.
> 
> So now it's being handled as a normal error. (here and in other places
> in these patches)
> 
> Is -EEXIST an error that should be handled, or if we get it does that
> indicate that somebody made a coding mistake?
> 
> I ask because "fix compiler warnings" don't usually turn into
> "add a bunch of new error handling" so ... some extra explanation would
> be helpful for these changes.
I see. At this point in the attr process, if this error happens, I would 
call it "a programming mistake" of sorts.  This condition of the attr 
already existing is handled much earlier in the code, so this error code 
path really shouldn't ever execute at this point unless something weird 
happened.

Should I have both the assert and the error handling for the compiler 
warning?  I wasn't really sure how concerned people actually were about 
the warnings.  It's not really that the variable is unused, it's just 
only used for the assert.

Thanks!
Allison

> 
> Thanks,
> -Eric
> 
