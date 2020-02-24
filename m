Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74937C11D2F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF422080D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wv23ZJxw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgBXQYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:24:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbgBXQYB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 11:24:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OG8YtG111146;
        Mon, 24 Feb 2020 16:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qYamDIbkE3ogmfTlGGP+afXew1/TkFpXtw01iyDNigU=;
 b=wv23ZJxwh959qmTwZeuIBj1HUzoBgZVuAB9EwCsdYGRXqHiOzDOCIuni/Y/5SRvCGUfG
 tqyA5CEnwpx9m+RoEdHjaFTZIVmbeL+3706fWO0lxd4ReTfHxED9Irp0fythJZKC/RFE
 b0+RUC+EjdHg5pX0ZBHvNiqjc06eApMkceLb4qaZYnyJsCh6KFAg+4WIYn5t/q955ISr
 5sOZ/qLB7EPBEK0UwObybsfz7YkTWFeEYxX3BxNtyxWT5n69iMgjIjJlfO7jlbYkUEfV
 5R/17woKsQUtFFJqZL0+Ph7HyVby2+d49PvMOtSxdDIkkQqE2Gx9cc3tU30DIGK5rQkr Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxrgcsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 16:23:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OG86Z4130388;
        Mon, 24 Feb 2020 16:23:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ybdsh3mp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 16:23:58 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01OGNv8t031948;
        Mon, 24 Feb 2020 16:23:57 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 08:23:57 -0800
Subject: Re: [PATCH v7 00/19] xfs: Delayed Ready Attrs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
 <5b2ade02-0f1b-b976-2b38-d10fcb41d317@oracle.com>
 <CAOQ4uxhhW2ZMVdF8zvHRPk65wsJTMn55tnCrJ7BVQK1CSAu3gQ@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <dedb52cd-fb96-2357-f29b-f2ae7813e83e@oracle.com>
Date:   Mon, 24 Feb 2020 09:23:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhhW2ZMVdF8zvHRPk65wsJTMn55tnCrJ7BVQK1CSAu3gQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 11:30 PM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 6:02 PM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>>
>>
>> On 2/23/20 12:55 AM, Amir Goldstein wrote:
>>> On Sun, Feb 23, 2020 at 4:06 AM Allison Collins
>>> <allison.henderson@oracle.com> wrote:
>>>>
>>>> Hi all,
>>>>
>>>> This set is a subset of a larger series for delayed attributes. Which is
>>>> a subset of an even larger series, parent pointers. Delayed attributes
>>>> allow attribute operations (set and remove) to be logged and committed
>>>> in the same way that other delayed operations do. This allows more
>>>> complex operations (like parent pointers) to be broken up into multiple
>>>> smaller transactions. To do this, the existing attr operations must be
>>>> modified to operate as either a delayed operation or a inline operation
>>>> since older filesystems will not be able to use the new log entries.
>>>
>>> High level question, before I dive into the series:
>>>
>>> Which other "delayed operations" already exist?
>>> I think delayed operations were added by Darrick to handle the growth of
>>> translation size due to reflink. Right? So I assume the existing delayed
>>> operations deal with block accounting.
>> Gosh, quite a few I think, but I'm not solid on what they all do.  If we
>> take a peek at XFS_LI_TYPE_DESC, theres an identifier for each type, to
>> give you an idea.  A lot of them do look like they are part of reflink
>> operations though.
>>
>>> When speaking of parent pointers, without having looked into the details yet,
>>> it seem the delayed operations we would want to log are operations that deal
>>> with namespace changes, i.e.: link,unlink,rename.
>>> The information needed to be logged for these ops is minimal.
>>> Why do we need a general infrastructure for delayed attr operations?
>>>
>>> Thanks,
>>> Amir.
>>>
>> Great question, this one goes back a ways.  I believe the train of logic
>> we had is that because parent pointers also include the filename of the
>> parent, its possible we can end up with really big attributes.  Which
>> may run into a lot of block map/unmap activity for name space changes.
>> We didnt want to end up with overly large transactions in the log, so we
>> wanted to break them up by returning -EAGAIN where ever the transactions
>> used to be rolled.  I'm pretty sure that covers a quick high level
>> history of where we are now?  Did that answer your question?
>>
> 
> Partly.
> My question was like this:
> It seems that your work is about implementing:
> [intent to set xattr <new parent inode,gen,offset> <new name>]
> [intent to remove xattr <old parent inode,gen,offset> <old name>]
> 
> While at a high level what the user really *intents* to do is:
> [intent to link <inode> to <new parent inode>;<new name>]
> [intent to unlink <inode> from <old parent inode>;<old name>]
> 
> I guess the log item sizes of the two variants is quite similar, so it
> doesn't make much of a difference and deferred xattr ops are more
> generic and may be used for other things in the future.
> 
> Another thing is that the transaction space required from directory
> entry changes is (probably) already taken into account correctly
> in the code, so there is no need to worry about deferred namespace
> operations from that aspect, but from a pure design perspective,
> if namespace operations become complex, *they* are the ones
> that should be made into deferred operations.
> 
> Or maybe I am not reading the situations correctly at all...
Ok, I think I understand what you're trying to say.  Would it help to 
explain then that setting or removing an attr becomes part of the 
namespace operations later?  When we get up into the parent pointer set, 
a lot of those patches add an attribute set or remove every time we 
link, unlink, rename etc.  Did that help answer your question?

Allison

> 
> Thanks,
> Amir.
> 
