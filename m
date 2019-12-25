Return-Path: <SRS0=hYYw=2P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2A2C2D0DA
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Dec 2019 17:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 216E52072A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Dec 2019 17:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FxJgxIwR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfLYRnb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Dec 2019 12:43:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfLYRnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Dec 2019 12:43:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBPHdAbM091512;
        Wed, 25 Dec 2019 17:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rfyV3V+kM2V53mq0udDdfqa8LY6JtQ377I2HPaU4qHs=;
 b=FxJgxIwR7OUWmhj3xw8RT8GVnNcXcIr9S6cnIq0VERd1Xq6oaN+830tto5JefwqjWvRK
 tX+rd7VV0eUhHwPDaoy2xfiBqCqG26vlg0DrRJW6H3ptMA2R7XzUxBRIHCySrHADyyL/
 OWwrrmtnN6aEGcy48gGNi8m5RliBJHyhjUli1Itm3jpq1XI1MhcaVGTz4Jp+AmVICDwl
 9QAcDWlREWL3+48MDzDrcTthMr4OaM4TtozBJ1ryL04YwANVTEnpVOqWdeTzDjCOk6B3
 1kgWbI7xMjll9Mf3IDRM6Eltt4jvgcbEGG2YqWbCKCPXl/o9uDWT1Wmhtt10FWIrmFzy Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x1attqte8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 17:43:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBPHd8g2100531;
        Wed, 25 Dec 2019 17:43:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x3brex383-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Dec 2019 17:43:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBPHhGjD031395;
        Wed, 25 Dec 2019 17:43:16 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Dec 2019 09:43:16 -0800
Subject: Re: [PATCH v5 05/14] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-6-allison.henderson@oracle.com>
 <20191224121410.GB18379@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <07284127-d9d7-e3eb-8e25-396e36ffaa93@oracle.com>
Date:   Wed, 25 Dec 2019 10:43:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191224121410.GB18379@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=837
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912250151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=878 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912250151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/24/19 5:14 AM, Christoph Hellwig wrote:
> On Wed, Dec 11, 2019 at 09:15:04PM -0700, Allison Collins wrote:
>> Break xfs_attr_rmtval_set into two helper functions
>> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
>> xfs_attr_rmtval_set rolls the transaction between the
>> helpers, but delayed operations cannot.  We will use
>> the helpers later when constructing new delayed
>> attribute routines.
> 
> Please use up the foll 72-ish characters for the changelog (also for
> various other patches).
Hmm, in one of my older reviews, we thought the standard line wrap 
length was 68.  Maybe when more folks get back from holiday break, we 
can have more chime in here.

> 
> For the actual patch: can you keep the code in the order of the calling
> conventions, that is the lower level functions up and
> xfs_attr_rmtval_set at the bottom?  Also please keep the functions
> static until callers show up (which nicely leads to the above order).
> 

Sure, will do.

Allison
