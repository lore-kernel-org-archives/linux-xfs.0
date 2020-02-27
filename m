Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C0AC4BA24
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 04:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8940624683
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 04:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o0IzFlyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgB0ETE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 23:19:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgB0ETE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 23:19:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R4ErMv142249;
        Thu, 27 Feb 2020 04:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=k1JhsTlB3Om2Vc6Ls5at5U4R1jKMqBUvnPkHxbGK6TU=;
 b=o0IzFlypseDFZJgmU5H8O9oMfgMVn6mxa0DemBh0aRlEojx3sAZqeDQUGlKJuBxHE99e
 73IIK4nmD6jt0H0WB31QnDYFtljGk8Y1j0+buhP6fVssn7NczJa0+U+aI10Zbur0Hgs9
 vuCYQzZRHVIFQ0qm4PHfpmwMWkTZUvwgHTUAD0rlZXYZ2eBaYDGcISL6v7vhwq5HLFDm
 i1RlmrC5KbITsmGqIG/CY+LSMHr9vf3Zm780+dzMVyMPcbokhbSCl76+Fg4wdTKVE6Oy
 2UCRfw9zf2deO97J9mnU2V/NbQmfyHCstWyHauw1+PPOkTJH+7nLgnGa/II6Xv9NuCM+ oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsng99t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 04:19:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R4EWbc135463;
        Thu, 27 Feb 2020 04:18:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcs7f2bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 04:18:59 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01R4Iwbb020580;
        Thu, 27 Feb 2020 04:18:58 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 20:18:58 -0800
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
 <20200225085705.GI10776@dread.disaster.area>
 <6075dabe-c503-05e4-ac3a-9eb028d40e9d@oracle.com>
 <20200226223417.GA10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <3256b993-d673-3524-57ef-29e7205aa74a@oracle.com>
Date:   Wed, 26 Feb 2020 21:18:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200226223417.GA10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/26/20 3:34 PM, Dave Chinner wrote:
> On Tue, Feb 25, 2020 at 04:57:46PM -0800, Allison Collins wrote:
>> On 2/25/20 1:57 AM, Dave Chinner wrote:
>>> On Sat, Feb 22, 2020 at 07:06:05PM -0700, Allison Collins wrote:
>>>> +out:
>>>> +	return error;
>>>> +}
>>>
>>> Brian commented on the structure of this loop better than I could.
>>>
>>>> +
>>>> +/*
>>>> + * Remove the attribute specified in @args.
>>>> + *
>>>> + * This function may return -EAGAIN to signal that the transaction needs to be
>>>> + * rolled.  Callers should continue calling this function until they receive a
>>>> + * return value other than -EAGAIN.
>>>> + */
>>>> +int
>>>> +xfs_attr_remove_iter(
>>>>    	struct xfs_da_args      *args)
>>>>    {
>>>>    	struct xfs_inode	*dp = args->dp;
>>>>    	int			error;
>>>> +	/* State machine switch */
>>>> +	switch (args->dac.dela_state) {
>>>> +	case XFS_DAS_RM_SHRINK:
>>>> +	case XFS_DAS_RMTVAL_REMOVE:
>>>> +		goto node;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>
>>> Why separate out the state machine? Doesn't this shortcut the
>>> xfs_inode_hasattr() check? Shouldn't that come first?
>> Well, the idea is that when we first start the routine, we come in with
>> neither state set, and we fall through to the break.  So we execute the
>> check the first time through.
>>
>> Though now that you point it out, I should probably go back and put the
>> explicit numbering back in the enum (starting with 1) or they will default
>> to zero, which would be incorrect.  I had pulled it out in one of the last
>> reviews thinking it would be ok, but it should go back in.
>>
>>>
>>> As it is:
>>>
>>> 	case XFS_DAS_RM_SHRINK:
>>> 	case XFS_DAS_RMTVAL_REMOVE:
>>> 		return xfs_attr_node_removename(args);
>>> 	default:
>>> 		break;
>>>
>>> would be nicer, and if this is the only way we can get to
>>> xfs_attr_node_removename(c, getting rid of it from the code
>>> below could be done, too.
>> Well, the remove path is a lot simpler than the set path, so that trick does
>> work here :-)
>>
>> The idea though was to establish "jump points" with the "XFS_DAS_*" states.
>> Based on the state, we jump back to where we were.  We could break this
>> pattern for the remove path, but I dont think we'd want to do the same for
>> the others.  The set routine is a really big function that would end up
>> being inside a really big switch!
> 
> Right, which is why I think it should be factored into function
> calls first, then the switch statement simply becomes a small set of
> function calls.
> 
> We use that pattern quite a bit in the da_btree code to call
> the correct dir/attr function based on the type of block we are
> manipulating (i.e. based on da_state context). e.g. xfs_da3_split(),
> xfs_da3_join(), etc.
I see, sure will do.  The patches were ordered much that way in the last 
version, so it wouldnt be hard to undo.

> 
>>>>    	struct xfs_da_geometry *geo;	/* da block geometry */
>>>>    	struct xfs_name	name;		/* name, length and argument  flags*/
>>>>    	uint8_t		filetype;	/* filetype of inode for directories */
>>>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>>>> index 1887605..9a649d1 100644
>>>> --- a/fs/xfs/scrub/common.c
>>>> +++ b/fs/xfs/scrub/common.c
>>>> @@ -24,6 +24,8 @@
>>>>    #include "xfs_rmap_btree.h"
>>>>    #include "xfs_log.h"
>>>>    #include "xfs_trans_priv.h"
>>>> +#include "xfs_da_format.h"
>>>> +#include "xfs_da_btree.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_reflink.h"
>>>>    #include "scrub/scrub.h"
>>>
>>> Hmmm - why are these new includes necessary? You didn't add anything
>>> new to these files or common header files to make the includes
>>> needed....
>>
>> Because the delayed attr context uses things from those headers.  And we put
>> the context in xfs_da_args.  Now everything that uses xfs_da_args needs
>> those includes.  But maybe if we do what you suggest above, we wont need to.
>> :-)
> 
> put:
> 
> struct xfs_da_state;
> 
> and whatever other forward declarations are require for the pointer
> types used in the delayed attr context at the top of xfs_attr.h.
> 
> These are just pointers in the structure, so we don't need the full
> structure definitions if the pointers aren't actually dereferenced
> by the code that includes the header file.
Alrighty, will fix.

Thanks for the reviews!
Allison

> 
> Cheers,
> 
> Dave.
> 
