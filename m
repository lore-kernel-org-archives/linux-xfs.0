Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2ECC2BB1D
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 16:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1DE62071B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 16:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ESrQvub4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgCLQSE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 12:18:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgCLQSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 12:18:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CG9RcX181866;
        Thu, 12 Mar 2020 16:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jSOoOxXx2rsbRzFenwwIL4JKiOH5aXuc/zgFd87XfNw=;
 b=ESrQvub4j/X66MwHUlhHTlgIfcwc0eU6cURz9/FeoPHHHoL5c33FRreoLTbJ9hEPxB24
 gACSuBYdgTNPt10uNZMJqmUdjJj4eoRKwhsqRW1pw0rpoxK7wX9P4aKqlEz9E/VdprV8
 asOZrktMIU141ynDED6P9e7U9LARyRpRFxQtd0aisI8Zys51HI1cLkjdfE5CBhhuz61b
 0YWWFQ1mhCJ5NwHOa4EDVvcilLBUb3dwRIewh5HprPjvOlgJDlqKPsc7y3nIqKqqJmGN
 XNR5TjIM0jGluZxcon+/LnrHK7K1ZqqkkrLhYQr1QmsK/NCBf3NCMLqPof7uN+kWXEWZ 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yqkg89t2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 16:17:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CFwG62128418;
        Thu, 12 Mar 2020 16:17:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yqkvmxs45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 16:17:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CGHgpR021317;
        Thu, 12 Mar 2020 16:17:42 GMT
Received: from [192.168.1.223] (/67.1.237.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 09:17:42 -0700
Subject: Re: xfsprogs process question
To:     Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20200312141351.GA30388@infradead.org>
 <244a8391-77c4-94a1-3bd4-b78c7a1f39ad@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <445406be-4d04-1834-0afc-d8af31271c95@oracle.com>
Date:   Thu, 12 Mar 2020 09:17:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <244a8391-77c4-94a1-3bd4-b78c7a1f39ad@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120083
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/12/20 8:46 AM, Eric Sandeen wrote:
> On 3/12/20 9:13 AM, Christoph Hellwig wrote:
>> Hi Eric and others,
>>
>> I've recently tried to port my attr cleanups to xfsprogs, but noticed
>> that a lot of patches from others are missing before I could apply
>> my ptches.  Any chance we could try to have a real xfsprogs for-next
>> branch that everyone can submit their ports to in a timely fashion?
>> Without that I'm not sure how to handle the porting in a distributed
>> way.
> 
> I guess the problem is that libxfs/ is behind, right.  I have indeed
> always been late with that but it's mostly only affected me so far.
> 
> Would it help to open a libxfs-sync-$VERSION branch as soon as the kernel
> starts on a new version?
> 
> I've never quite understood what the common expectation for a "for-next"
> branch behavior is, though I recognize that my use of it right now is a bit
> unconventional.
> 
> -Eric

I've run across this a few times working on the delayed attr series too. 
Sometimes I'll just have to go through the kernel side patches and find 
the missing pieces and port them myself just to get things to seat 
correctly.  Eventually the xfsprogs side catches up, but it would seem 
to me that if we all did this it would help to catch up the user space 
side and keep it maintained.  I've often wondered how one person manages 
to keep up with that!  :-)

Allison
