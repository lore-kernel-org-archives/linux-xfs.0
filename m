Return-Path: <SRS0=hYYw=2P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC88BC2D0C8
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Dec 2019 04:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A99A72053B
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Dec 2019 04:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bJhPwhOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLYEWF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 23:22:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33240 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfLYEWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 23:22:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBP4JxK3185776;
        Wed, 25 Dec 2019 04:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=7MBzP4S/3K7+JlBZRzIp/2HsB2y4cytznLogt6im6jU=;
 b=bJhPwhOZF4yJW1FXXEETQpuQ+0obMkxhstlVYvPIIuPduebWTUjDg5m5bQCQJvGGm1Ag
 aGQ3vfujEmWAzT6gFMrYJh0jDcRcY3wwS0T/R7nBvD4obI48A9fN9pKKEXSB/Dl+RzlB
 HnU1op2LdorO62gh/ceK3FheO/WX+89XsAGLZypiPz5hXXrCOT3lL727hCYZjhLtwa5t
 f4sA4TfEaguZBySchXdreZ+Y5nPfctUdhc1iGuVKhLd9Wg9KxGkQs4OlDrORrt51ZfBa
 XuLTGsajUPj2AL5neE6yv2EwRq4BrqshHcKh+rwx4AhDfFKE2z428AeQ8Ql79wK/PGU9 uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x1attp8mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 04:21:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBP4Imiu099975;
        Wed, 25 Dec 2019 04:21:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x3amuhamy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 04:21:55 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBP4LpF8019831;
        Wed, 25 Dec 2019 04:21:51 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 20:21:51 -0800
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
 <20191224121830.GD18379@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2b29c0a0-03bb-8a21-8a8a-fd4754bff3ff@oracle.com>
Date:   Tue, 24 Dec 2019 21:21:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191224121830.GD18379@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912250030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912250030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/24/19 5:18 AM, Christoph Hellwig wrote:
> On Wed, Dec 11, 2019 at 09:15:03PM -0700, Allison Collins wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a new functions to check for the existence of
>> an attribute.  Subroutines are also added to handle the cases
>> of leaf blocks, nodes or shortform.  Common code that appears
>> in existing attr add and remove functions have been factored
>> out to help reduce the appearance of duplicated code.  We will
>> need these routines later for delayed attributes since delayed
>> operations cannot return error codes.
> 
> Can you explain why we need the ahead of time check?  The first
> operation should be able to still return an error, and doing
> a separate check instead of letting the actual operation fail
> gracefully is more expensive, and also creates a lot of additional
> code.  As is I can't say I like the direction at all.
> 

This one I can answer quickly: later when we get into delayed 
attributes, this will get called from xfs_defer_finish_noroll as part of 
a .finish_item call back.  If these callbacks return anything other than 
0 or -EAGAIN, it causes a shutdown.  Which is not what we would want for 
example: when the user tries to rename a non-existent attribute.  The 
error code needs to go back up.  So we check for things like that before 
starting a delayed operation.  Hope that helps.  Thanks!

Allison
