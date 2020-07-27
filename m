Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA46C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 01:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A828B206F6
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 01:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hAbuNCFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgG0B5l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 21:57:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0B5l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 21:57:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R1pboC117557;
        Mon, 27 Jul 2020 01:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X0k9pEe7RrBFt0FjSghtqSQ8JSIz34b6IjRMAjohWdU=;
 b=hAbuNCFhPeMO45SxN2IhyKJ4lEyLs39i7OuQ9bzhIm7Utc3X2lleDEluLfsPfpe1FOXF
 1LKivWWsMBJrvm+OMmeIyIwV+EadeI/GkjzNflBasl+bGvuQAtO86SqAy1SCPZEngtlU
 an6QpcGNPEJi4s79fmyq907L2PGSP6ZLoUl9bCKf8M47hNz17JS4GO0BWb9e6gbNfTqT
 BwutJ0qR8rX+aNmntJY2vP09uHW38f9V8Y/tSM8GvdIHncHFrCPT4PKf9eCumB2IJ9ra
 36wu4EdR947Z6eqYsCVDW11HZnMwW/e9ZrlFa4ssa0M7fnZpS6qROUC6YXUu0QzBy3hV NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32gxd3j4pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 01:57:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R1qaPn016605;
        Mon, 27 Jul 2020 01:57:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32hbt06yuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 01:57:38 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06R1vYXm030437;
        Mon, 27 Jul 2020 01:57:37 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jul 2020 18:57:34 -0700
Subject: Re: [PATCH 2/2] xfs: Fix compiler warning in xfs_attr_shortform_add
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20200725230102.22192-1-allison.henderson@oracle.com>
 <20200725230102.22192-3-allison.henderson@oracle.com>
 <ae37c9e6-8e21-51ad-b8ca-a32e1bc7343e@sandeen.net>
 <cc8bd065-7990-eee7-de49-fc29a6a8e45a@oracle.com>
 <d64b2e38-e9fc-b19f-d647-361287a76917@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <9338750c-4d5d-16bb-4f01-ebf831c9f1a4@oracle.com>
Date:   Sun, 26 Jul 2020 18:57:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d64b2e38-e9fc-b19f-d647-361287a76917@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/26/20 5:27 PM, Eric Sandeen wrote:
> On 7/26/20 11:10 AM, Allison Collins wrote:
>>
>>
>> On 7/25/20 11:48 PM, Eric Sandeen wrote:
>>> On 7/25/20 4:01 PM, Allison Collins wrote:
>>>> @@ -730,7 +730,8 @@ xfs_attr_shortform_add(
>>>>        ASSERT(ifp->if_flags & XFS_IFINLINE);
>>>>        sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>>>>        error = xfs_attr_sf_findname(args, &sfe, NULL);
>>>> -    ASSERT(error != -EEXIST);
>>>> +    if (error == -EEXIST)
>>>> +        return error;
>>>>          offset = (char *)sfe - (char *)sf;
>>>>        size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
>>>
>>> ASSERTs are normally "this cannot happen unless somebody made a
>>> programming mistake," not an error that can actually happen in normal
>>> use.
>>>
>>> So now it's being handled as a normal error. (here and in other places
>>> in these patches)
>>>
>>> Is -EEXIST an error that should be handled, or if we get it does that
>>> indicate that somebody made a coding mistake?
>>>
>>> I ask because "fix compiler warnings" don't usually turn into
>>> "add a bunch of new error handling" so ... some extra explanation would
>>> be helpful for these changes.
>> I see. At this point in the attr process, if this error happens, I would call it "a programming mistake" of sorts.  This condition of the attr already existing is handled much earlier in the code, so this error code path really shouldn't ever execute at this point unless something weird happened.
>>
>> Should I have both the assert and the error handling for the compiler warning?  I wasn't really sure how concerned people actually were about the warnings.  It's not really that the variable is unused, it's just only used for the assert.
> 
> hi Allison -
> 
> Well, it really is unused if #ifdef DEBUG isn't set.  :)  And we do want to eliminate gcc warnings so you're doing the right thing by addressing them.
> 
> If these are typical ASSERTs which are "debug only, should never happen, if it does you broke the code" then I'd say wrap the variable declarations in
> 
> #ifdef DEBUG
> 	int foo;
> #endif
> 
> it's ugly, but we do it in many places.
> 
> if it's a real, possible error that actually needs to be handled at runtime then the way you've done it makes sense, I'd just suggest a commit log that explains the rationale for the change.
> 
> Sorry for not being conversant enough in this code to know the difference between the two, it just kind of stuck out at me to see ASSERTs being turned into error handlers as a response to compiler warnings.
No worries, thanks for the feed back.  Ok, will send out a v2.

Allison

> 
> Thanks
> -Eric
> 
