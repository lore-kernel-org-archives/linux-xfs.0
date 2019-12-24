Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6740C2D0C3
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 23:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77501206D3
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 23:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dIepkXMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfLXXSQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 18:18:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49202 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfLXXSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 18:18:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBONEngA147543;
        Tue, 24 Dec 2019 23:18:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DYW428K2mM6Bjv87V4SJwc7X0Xgl02NN3ShMB7pbeqI=;
 b=dIepkXMW4TflB5azbX9QRCkOzax8YDvjauWuAauSDqQUT7OAFfMs2cbfeTm4lcWywXtJ
 2eC3DEcUlf5ivlWsKpKr+rehItGLbfFtsoPgY8phcpCB5btDB+IMxnNBiBd+B2W7opXM
 x7FNgixZfBNiTsNH3hgDhHxaryJuh8gi33dYh2W5aPrnclSK7z/HEyL9dNQ6o6hatpJN
 nVcODAqQOI0d7mM5pEoRYdJgLAPUAWspiQ7NkdBTNonz/33tb5JfPpNYcrzEhQ8mFWBo
 08qwuoH5L0Co2Q+axZ5iaN4KFdheKBkMyN9pjS+0pTmHG8O1Z91/ghc6tRHMiaFFgmKB Ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x1bbpw6wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 23:18:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBONEi99187976;
        Tue, 24 Dec 2019 23:18:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x3bre2qum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 23:18:02 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBONI1FS023660;
        Tue, 24 Dec 2019 23:18:02 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 15:18:01 -0800
Subject: Re: [PATCH v5 13/14] xfs: Add delay ready attr remove routines
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-14-allison.henderson@oracle.com>
 <20191224123025.GI18379@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <6cfffc64-350c-e16e-5e4a-a45775ea1faa@oracle.com>
Date:   Tue, 24 Dec 2019 16:18:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191224123025.GI18379@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'll have to come back and respond to your other reviews in depth later 
when I have a little more time, but I think responding to this one 
quickly will help answer a lot of questions.  The set actually has a lot 
more history as a delayed attributes series, and even more as parent 
pointers.  I try to keep the whole set up to date because parent 
pointers is sort of a good test case for the rest it.  And also because 
I want to make sure things still work for the future uses they are 
intended for.

To give you an idea, this is the same series + delayed attrs + parent pptrs:
https://github.com/allisonhenderson/xfs_work/tree/pptrs_restart41

I usually just send out the "delay ready" portion of it just to cut down 
on the amount of code that people have to review (because I know people 
are swamped with review backlog).  And also because some time ago, folks 
felt that trying to push it in all at once was a little unwieldy, so 
they requested that I chop it down to this sub series that focuses on 
refactor only with no functional change.  And then that would give it 
time to stabilize before proceeding too.

I hope the history of it helps a bit.  Otherwise I can see where it 
looks like a whole bunch of craziness for nothing, but that's the long 
term plan for it.  And while I think people agree that it's not the 
prettiest at the moment, the function that we are trying to achieve with 
it isn't simplest either, so people have been pretty active in shaping 
it as it goes along.  I'll go through your set and see which bits I can 
pick up and sort of integrate so that we don't have so much conflict. 
Thanks!

Allison

On 12/24/19 5:30 AM, Christoph Hellwig wrote:
> This code looks pretty scary, mostly because it adds hard to parse
> monster functions.  Also as-is it seems totally pointless as no
> user of the change appears.  In fact this series adds almost 500
> lines of code without adding any code or speeding operations up (in
> fact I think it will cause minor slow downs).  So to me it is a very
> hard sell.
> 
