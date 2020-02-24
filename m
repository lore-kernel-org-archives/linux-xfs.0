Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C38C3567B
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD1520714
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sB1Mh/Iz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgBXHJR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 02:09:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgBXHJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 02:09:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01O77Zvm139205;
        Mon, 24 Feb 2020 07:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GlxRPPbfpGAUDlTY/kvrJF9b30RMtdR7K451pXNzyOU=;
 b=sB1Mh/IzpBmD1sSsWnQ9Tv5uIxzMt4xrffvn+iml5po04DvC70/hQkHQhtaX1C88AaPh
 CnlL1sdUdax4lMp/3QNyoUCHdMwfcdJHjrrGRYJ3RNFbcG0UEmZw/8buSePRHBgZjI17
 conyE6EAp4t9TP2ijkh6OnPZfglgUsjSAVkjS2/tcB47lY6PohhVTeeFSxemwNmpRZBl
 9L9lPD2h24o6lWzCOIWSrdciVvKycpouNHAG21gL2DWUAOeRsUFpTUwB5TtE6BTLJV1I
 CnKQNdEkCdxj5ngsvicdFrOdO+wuMIirE+I9OFjAGYaYLakTjWDV/HQ5mIJXxgD2T+YC HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ybvr4hmac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 07:09:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01O78XwI171189;
        Mon, 24 Feb 2020 07:09:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yby5ajcsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 07:09:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01O79DWo024563;
        Mon, 24 Feb 2020 07:09:13 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 23:09:13 -0800
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-8-allison.henderson@oracle.com>
 <CAOQ4uxj_X+Sm6A838CVsDqL8zkYy63G++RFuew1dYmLsXhOpQg@mail.gmail.com>
 <2abd5db4-bf0e-7ed0-3777-700dbc2e379e@oracle.com>
 <CAOQ4uxihN98SNE9SfHHc7Ajcs5siA-RXOYB5fgLqic+8ZDpGAQ@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0c916507-fd00-c767-62d9-305d6b22e252@oracle.com>
Date:   Mon, 24 Feb 2020 00:09:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxihN98SNE9SfHHc7Ajcs5siA-RXOYB5fgLqic+8ZDpGAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240062
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240062
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 11:38 PM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 8:38 PM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> On 2/23/20 5:42 AM, Amir Goldstein wrote:
>>> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
>>> <allison.henderson@oracle.com> wrote:
>>>>
>>>> Factor out new helper function xfs_attr_leaf_try_add.
>>>
>>> Right. This should be the subject.
>>> Not factor out xfs_attr_leaf_addname helper.
>>>
>>>> Because new delayed attribute
>>>> routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
>>>> that we can use, and move the commit into the calling function.
>>>
>>> And that is a different change.
>>> It is hard enough to review a pure factor out of a helper.
>>> Adding changed inside a pure re-factor is not good.
>>>
>>> Belongs to another change - move transaction commit to caller.
>>
>> Yes, this came up in the last review, but the reason I avoid it is
>> because I think the transaction looks weird in either helper.  The
>> reason the roll is here is because there is no room to add the attr as a
>> leaf, and so we need to hand it off to the node subroutines.  But that
>> seems like something that should be managed by the caller, not leaf
>> helpers.  So I was concerned that separating the split and the hoist
>> would generate more weird looks from people trying to understand the
>> split until the see the hoist in the next patch.  If people really think
>> it looks better that way, I can split them up.  But I know folks have a
>> tough enough time trying to recall the discussion history, so I'm trying
>> to avoid confusion of another type :-)
>>
>> Thoughts?
>>
> 
> It's fine, so long as you document it properly in commit message.
> See, we are so bad in this review process, that we rely on humans
> to verify that logic preserving re-factoring patches are indeed logic
> preserving. This is so lame to begin with, because there are static
> checker bots out there that would gladly do that work for us :) ...
I didnt know there were tools out there that did that.  They sound 
helpful though!

> if we only annotated the logic preserving patches as such.
> In the mean while, while we are substituting the review robots,
> the least a developer could do is not call out a patch "re-factoring"
> and sneak in a logic change without due notice to reviewers.
Ok, what if the title were to say something like:
xfs: Split out node handling from xfs_attr_leaf_addname

Or maybe just "Split apart xfs_attr_leaf_addname"?  Does that sound like 
it would be a better description here?

Thanks!
Allison

> 
> Thanks,
> Amir.
> 
