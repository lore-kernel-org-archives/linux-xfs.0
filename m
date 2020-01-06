Return-Path: <SRS0=XUqT=23=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18ED2C33C8C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 18:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4BCF24676
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 18:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gd5cI517"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgAFS36 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:29:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48962 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgAFS36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jan 2020 13:29:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006IJZb8055260;
        Mon, 6 Jan 2020 18:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=EK12HxmfPxnA1SfAf6k3tw34k2uKFZ4Mbgg/utAa+jc=;
 b=Gd5cI517xTCXU0Kp+6jUtBGcPV3aH+ZvLrJS66EBMyllNotzmDq/a2A9GI/7J4oiur1f
 Jjgs/abfJ7JcJ02yoqrbkYNydsbawO8L75ckw7RUrNH0M4uE+soMPfhk+RgF4C3+Bfb6
 MFj7LpTZEJ97tCBDq9BG5k5qFcj+PKFLNnP5iKOItwzcvUe85skasRpEOsWLRygeYbCK
 2dyeNnIid6rju4Wde9mA1f50zsIaNBs5dL5KDDjLohqA6y3P60Bgi5ofRzOkmRP+bLvc
 E+KemCUMonbTInE1jj469hYR7XYa5g0PibPKP2hIL2Gj4iFsAzUmBEfRC9WQxi18q0zs 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xaj4ts1m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 18:29:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006IT03V043537;
        Mon, 6 Jan 2020 18:29:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xb4upcuju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 18:29:36 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 006ITUFW031422;
        Mon, 6 Jan 2020 18:29:30 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 10:29:30 -0800
Subject: Re: [PATCH v5 05/14] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-6-allison.henderson@oracle.com>
 <20191224121410.GB18379@infradead.org>
 <07284127-d9d7-e3eb-8e25-396e36ffaa93@oracle.com>
 <20200106144650.GB6799@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <af903a9f-2e2c-ac21-37a4-093be64f113d@oracle.com>
Date:   Mon, 6 Jan 2020 11:29:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200106144650.GB6799@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=824
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001060153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=858 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001060152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/6/20 7:46 AM, Brian Foster wrote:
> On Wed, Dec 25, 2019 at 10:43:15AM -0700, Allison Collins wrote:
>>
>>
>> On 12/24/19 5:14 AM, Christoph Hellwig wrote:
>>> On Wed, Dec 11, 2019 at 09:15:04PM -0700, Allison Collins wrote:
>>>> Break xfs_attr_rmtval_set into two helper functions
>>>> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
>>>> xfs_attr_rmtval_set rolls the transaction between the
>>>> helpers, but delayed operations cannot.  We will use
>>>> the helpers later when constructing new delayed
>>>> attribute routines.
>>>
>>> Please use up the foll 72-ish characters for the changelog (also for
>>> various other patches).
>> Hmm, in one of my older reviews, we thought the standard line wrap length
>> was 68.  Maybe when more folks get back from holiday break, we can have more
>> chime in here.
>>
> 
> I thought it was 68 as well (I think that qualifies as 72-ish" at
> least), but the current commit logs still look short of that at a
> glance. ;P
> 
> Brian
Ok I doubled checked, the last few lines do wrap a little early, but the 
rest is correct for 68 because of the function names.  We should 
probably establish a number though.  In perusing around some of the 
other patches on the list, it looks to me like people are using 81?

Allison

> 
>>>
>>> For the actual patch: can you keep the code in the order of the calling
>>> conventions, that is the lower level functions up and
>>> xfs_attr_rmtval_set at the bottom?  Also please keep the functions
>>> static until callers show up (which nicely leads to the above order).
>>>
>>
>> Sure, will do.
>>
>> Allison
>>
> 
