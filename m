Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6296C54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95FE22077D
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uUyKXmFa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgDWXT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:19:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbgDWXT5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:19:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNJ2g9172950;
        Thu, 23 Apr 2020 23:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LbSd6CsTiA2Veksd8DGyWrKfe8Ejlfukh3kopnI4Yqs=;
 b=uUyKXmFaPpRcMCsS4EcF31GZ90qHDBfH3mlSTBCm3jytOzi+h4I8rrUAznI9Z4eQJT+P
 fQwLm6fTHUtk1JqT229ceuIGsqF1wHk0uzgaiwppkERgFHBr+R9zciFG8bJGiFd4VIcL
 NTZEb084LW2HyiS+d3jLJ5d6US/J8E3nqjGLKp82tnECqcbTI3nciEEtrO+YBYuXWiSN
 c8KcGu9s5T6loYwqPS3DVgNqsBSnk6bunJct4tlAdqmXI/cch15yb6MhFcYUoyhJH6DR
 Cq9bGh5wWxwYxKQDhawDhK/XRG5tGYhYX6fQJxUeh3yChcf96dlo6gymoTsKMIZWrm7O Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30k7qe432h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:19:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNGdKT179986;
        Thu, 23 Apr 2020 23:19:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30gbbnemcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:19:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NNJrxs028852;
        Thu, 23 Apr 2020 23:19:53 GMT
Received: from dhcp-10-159-236-155.vpn.oracle.com (/10.159.236.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:19:53 -0700
Subject: Re: [PATCH] xfs: don't change to infinate lock to avoid dead lock
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200423172325.8595-1-wen.gang.wang@oracle.com>
 <20200423230515.GZ27860@dread.disaster.area>
 <ed040889-5f79-e4f5-a203-b7ad8aa701d4@oracle.com>
Message-ID: <bca65738-3deb-ef43-6dde-1c2402942032@oracle.com>
Date:   Thu, 23 Apr 2020 16:19:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ed040889-5f79-e4f5-a203-b7ad8aa701d4@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=3 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=3 mlxlogscore=999 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 4/23/20 4:14 PM, Wengang Wang wrote:
>
> On 4/23/20 4:05 PM, Dave Chinner wrote:
>> On Thu, Apr 23, 2020 at 10:23:25AM -0700, Wengang Wang wrote:
>>> xfs_reclaim_inodes_ag() do infinate locking on pag_ici_reclaim_lock 
>>> at the
>>> 2nd round of walking of all AGs when SYNC_TRYLOCK is set 
>>> (conditionally).
>>> That causes dead lock in a special situation:
>>>
>>> 1) In a heavy memory load environment, process A is doing direct memory
>>> reclaiming waiting for xfs_inode.i_pincount to be cleared while holding
>>> mutex lock pag_ici_reclaim_lock.
>>>
>>> 2) i_pincount is increased by adding the xfs_inode to journal 
>>> transection,
>>> and it's expected to be decreased when the transection related IO is 
>>> done.
>>> Step 1) happens after i_pincount is increased and before 
>>> truansection IO is
>>> issued.
>>>
>>> 3) Now the transection IO is issued by process B. In the IO path (IO 
>>> could
>>> be more complex than you think), memory allocation and memory direct
>>> reclaiming happened too.
>> Sure, but IO path allocations are done under GFP_NOIO context, which
>> means IO path allocations can't recurse back into filesystem reclaim
>> via direct reclaim. Hence there should be no way for an IO path
>> allocation to block on XFS inode reclaim and hence there's no
>> possible deadlock here...
>>
>> IOWs, I don't think this is the deadlock you are looking for. Do you
>> have a lockdep report or some other set of stack traces that lead
>> you to this point?
>
> As I mentioned, the IO path can be more complex than you think.
>
> The real case I hit is that the process A is waiting for inode unpin 
> on XFS A which is a loop device backed mount.

And actually, there is a dm-thin on top of the loop device..

thanks,
wengang

>
> And the backing file is from a different (X)FS B mount. So the IO is 
> going through loop device, (direct) writes to (X)FS B.
>
> The (direct) writes to (X)FS B do memory allocations and then memory 
> direct reclaims...
>
> thanks,
> wengang
>
