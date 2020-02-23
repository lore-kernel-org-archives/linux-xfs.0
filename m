Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A712FC35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CA8920836
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mRxUU9Ez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWSiv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 13:38:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWSiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 13:38:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIcmQK159374;
        Sun, 23 Feb 2020 18:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jCrLbAT8PYrKMMLtel1OdVL8yg6oI2bLHP6UofqVvs4=;
 b=mRxUU9EzY4cP/CIBZOCXdzVUw3xeQZYKX8VIV99SlTFRkWyQF56VUA/DjHJpcsxlugVb
 PT1BdpQRLMPvh4UKvsAzxsoCCLabwcDe0+TXn+g4hZjOgIQ+cOwVXA29b211u7Ni053D
 2gnXNlHceQ7XEIPEIPH1vfpCJ66KJSATLpNmk4qUhR1OTl5kWKOTLSYtP+ZYRpT+s/m1
 Rp52HrmACPq4XSaHAAteW6MpAYh+W0Q0QToUGiQQwANsGn1fS5f1xqZcN1t4sAXSzdMe
 ssL79XB25YjVTk8hFpNXYLrytRuxpdGySlJN9U8+RLW7hgp8OAnt7GRJj3f6vzwnXpEg SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yavxrbvej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:38:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIcStd053049;
        Sun, 23 Feb 2020 18:38:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe0ya4q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:38:47 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01NIclme018885;
        Sun, 23 Feb 2020 18:38:47 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 10:38:47 -0800
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-8-allison.henderson@oracle.com>
 <CAOQ4uxj_X+Sm6A838CVsDqL8zkYy63G++RFuew1dYmLsXhOpQg@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2abd5db4-bf0e-7ed0-3777-700dbc2e379e@oracle.com>
Date:   Sun, 23 Feb 2020 11:38:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj_X+Sm6A838CVsDqL8zkYy63G++RFuew1dYmLsXhOpQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/23/20 5:42 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> Factor out new helper function xfs_attr_leaf_try_add.
> 
> Right. This should be the subject.
> Not factor out xfs_attr_leaf_addname helper.
> 
>> Because new delayed attribute
>> routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
>> that we can use, and move the commit into the calling function.
> 
> And that is a different change.
> It is hard enough to review a pure factor out of a helper.
> Adding changed inside a pure re-factor is not good.
> 
> Belongs to another change - move transaction commit to caller.

Yes, this came up in the last review, but the reason I avoid it is 
because I think the transaction looks weird in either helper.  The 
reason the roll is here is because there is no room to add the attr as a 
leaf, and so we need to hand it off to the node subroutines.  But that 
seems like something that should be managed by the caller, not leaf 
helpers.  So I was concerned that separating the split and the hoist 
would generate more weird looks from people trying to understand the 
split until the see the hoist in the next patch.  If people really think 
it looks better that way, I can split them up.  But I know folks have a 
tough enough time trying to recall the discussion history, so I'm trying 
to avoid confusion of another type :-)

Thoughts?

Allison

> 
> Thanks,
> Amir.
> 
