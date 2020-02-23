Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3DDC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 16:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A3920836
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 16:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fnxV53PJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBWQCf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 11:02:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47900 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWQCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 11:02:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NG2W4P144314;
        Sun, 23 Feb 2020 16:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pbjZFsJS0pAsdwB51TPHPMmXd9pXLmYdMSD7iHUPWzU=;
 b=fnxV53PJaNzKnZmCnEP7yCoyoJSKDO852kYUY+cE1WlF/iTKELUZFGDZHws0VXxA61TI
 CNp6/yV6uTCPJRuAiD4kmtpW23QsqMXOaCf2Y3wc4YPQV0ibIDtuYknFIFQPfV0R6aBB
 T2Q+queWFPdXQDT89V/GtQUlVIp03kexOhuk24lgOoXof8KxDWcZctJECR+6xHAQFaDQ
 DwRudx/jYW6h5MVlXZ+OSbbUrSa+n+6X+bzeKR5hWr4cUPKbNZo0b1iadF/bjNfoQ2sK
 W4RB4rC2pvCdjbPb+F0o7TVO7q8N0Fo5LlU0iScGX+JW6remDNJ9vL0PIJvlXlwXyeax MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yavxrbnn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 16:02:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NG2Wkj024945;
        Sun, 23 Feb 2020 16:02:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe0y2yx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 16:02:32 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01NG2Vs1017859;
        Sun, 23 Feb 2020 16:02:31 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 08:02:31 -0800
Subject: Re: [PATCH v7 00/19] xfs: Delayed Ready Attrs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5b2ade02-0f1b-b976-2b38-d10fcb41d317@oracle.com>
Date:   Sun, 23 Feb 2020 09:02:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 12:55 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:06 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> Hi all,
>>
>> This set is a subset of a larger series for delayed attributes. Which is
>> a subset of an even larger series, parent pointers. Delayed attributes
>> allow attribute operations (set and remove) to be logged and committed
>> in the same way that other delayed operations do. This allows more
>> complex operations (like parent pointers) to be broken up into multiple
>> smaller transactions. To do this, the existing attr operations must be
>> modified to operate as either a delayed operation or a inline operation
>> since older filesystems will not be able to use the new log entries.
> 
> High level question, before I dive into the series:
> 
> Which other "delayed operations" already exist?
> I think delayed operations were added by Darrick to handle the growth of
> translation size due to reflink. Right? So I assume the existing delayed
> operations deal with block accounting.
Gosh, quite a few I think, but I'm not solid on what they all do.  If we 
take a peek at XFS_LI_TYPE_DESC, theres an identifier for each type, to 
give you an idea.  A lot of them do look like they are part of reflink 
operations though.

> When speaking of parent pointers, without having looked into the details yet,
> it seem the delayed operations we would want to log are operations that deal
> with namespace changes, i.e.: link,unlink,rename.
> The information needed to be logged for these ops is minimal.
> Why do we need a general infrastructure for delayed attr operations?
> 
> Thanks,
> Amir.
> 
Great question, this one goes back a ways.  I believe the train of logic 
we had is that because parent pointers also include the filename of the 
parent, its possible we can end up with really big attributes.  Which 
may run into a lot of block map/unmap activity for name space changes. 
We didnt want to end up with overly large transactions in the log, so we 
wanted to break them up by returning -EAGAIN where ever the transactions 
used to be rolled.  I'm pretty sure that covers a quick high level 
history of where we are now?  Did that answer your question?

Allison


