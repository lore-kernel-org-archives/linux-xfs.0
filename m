Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFDAC33CB6
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6D8F2072B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VyKQ5/0p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgAQGSH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:18:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40408 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgAQGSG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:18:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68w4h150414;
        Fri, 17 Jan 2020 06:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HBNLcSeaD/W5hfvXizZReTomydmFa2dESINNThPsAeM=;
 b=VyKQ5/0priy3kME076gJm/plIURa2UsYI59kYEj0aSN71p6KBz1NMRqaKeWvl5JGK7pH
 s5y/I+DjyzVjz0a/jDxTIodEmzvJBrahMsCmS0eo835uUKtvozOCeiV5fY123C0eOyoE
 yGTsuYPaw/O0ZYUqoBv0OCEfHzynaPXujZQlEA99vkswEjIHNBcfxXLX1SPWOiu8jOWU
 k1TlOeBDwMU5E5fapD2+i79cIiqhCnZv1f5k5wtGzqpNEgTZQUrNqp6sR+wOU7zUWstL
 L/+i6fX+ahhC/H9ol322Td7CdfyzUfGeLoQk8S0nTs7+KJploo1ytftp1sGUmRW1sG/0 SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73u6qtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:17:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68U3Z129423;
        Fri, 17 Jan 2020 06:15:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xjxp4h725-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:15:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00H6FtcJ032100;
        Fri, 17 Jan 2020 06:15:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:15:55 -0800
Date:   Thu, 16 Jan 2020 22:15:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     guaneryu@gmail.com, jbacik@fusionio.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, zhengbin13@huawei.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH] xfs/126: fix that corrupt xattr might fail with a small
 probability
Message-ID: <20200117061552.GQ8247@magnolia>
References: <20200108092758.41363-1-yukuai3@huawei.com>
 <20200108162227.GD5552@magnolia>
 <3c7e9497-e0ed-23e4-ff9c-4b1c1a77c9fa@huawei.com>
 <20200109164615.GA8247@magnolia>
 <51e99fd5-617f-6558-7a04-c4a198139cdd@huawei.com>
 <20200116160323.GC2149943@magnolia>
 <bc9afd0d-91e5-ef0a-94cb-599b8a57b136@huawei.com>
 <da1c7dd8-b036-73fb-3a55-d2800f3f650e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da1c7dd8-b036-73fb-3a55-d2800f3f650e@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=988
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 17, 2020 at 11:10:45AM +0800, yukuai (C) wrote:
> 
> 
> On 2020/1/17 10:20, yukuai (C) wrote:
> > After adding "-o 4", I tested over 200 times, and blocktrash never
> > failed to corrupt xattr anymore.
> 
> Unfortunately, test failed with more attempts:
> 
> _check_dmesg: something found in dmesg (see
> /root/xfstests-dev/results//xfs/126.dmesg)
> 
> [ 4597.649086] BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!
> [ 4597.649709] turning off the locking correctness validator.

That's a deficiency in lockdep not being able to follow XFS crazy
locking.  It's not a bug in XFS itself.

--D

> [ 4597.650363] CPU: 4 PID: 377 Comm: kworker/4:1H Not tainted 5.5.0-rc6 #197
> [ 4597.651027] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> ?-20180531_142017-buildhw-08.phx2.fedoraproject.org-1.fc28 04/01/2014
> [ 4597.652276] Workqueue: xfs-log/sdb xlog_ioend_work
> [ 4597.652803] Call Trace:
> [ 4597.653109]  dump_stack+0xdd/0x13f
> [ 4597.653573]  __lock_acquire.cold.46+0x7a/0x409
> [ 4597.654000]  lock_acquire+0xf6/0x270
> [ 4597.654487]  ? xlog_state_do_callback+0x1eb/0x4e0
> [ 4597.654921]  _raw_spin_lock+0x45/0x70
> [ 4597.655250]  ? xlog_state_do_callback+0x1eb/0x4e0
> [ 4597.655666]  xlog_state_do_callback+0x1eb/0x4e0
> [ 4597.656123]  xlog_state_done_syncing+0x8b/0x110
> [ 4597.656727]  xlog_ioend_work+0x94/0x150
> [ 4597.657210]  process_one_work+0x346/0x910
> [ 4597.657714]  worker_thread+0x284/0x6d0
> [ 4597.658125]  ? rescuer_thread+0x550/0x550
> [ 4597.658647]  kthread+0x168/0x1a0
> [ 4597.658931]  ? kthread_unpark+0xb0/0xb0
> [ 4597.659470]  ret_from_fork+0x24/0x30
> 
> I wonder, could we increase the number of "-o 4" to fix this?
> 
> Thanks!
> Yu Kuai
> 
