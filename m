Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4919DC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08A8C2173E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 15:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ERNI9/yc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfH2Pyw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:54:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35046 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbfH2Pyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 11:54:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFnvdX026670;
        Thu, 29 Aug 2019 15:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=OWxktI5CVSCDIHgullLxsJl+5/aW238DfxAkTQdbXjc=;
 b=ERNI9/ycTy0p8fajf5frDyJJeZsQ5HKm9LTC8YXN3gGSr3H8JBnzLipZsnuLBftewly8
 WdhW4u7/vC5sTWkUm61j99MtDy2pJ/McYftxwabxUuD/HQTlX/ZBK+lrjnnmCzzuiMsK
 g81aHA9d5Du0LDPGSycQBeD1eaHP+v/IbMPxk6lRjikAcnS4HLcJwOWYdfKjwn3wpjDD
 SX8ggHgQ/+W7qGfPiHvnasBojklzr5a9BT0f6knEyJ6MYqB2P1zd3jgKWKUg36EfWF8Y
 YskykO57KzhKjtAAWk+j08mszjxiDWWRT/8UE3BwY7QJBjGSBTmyGOFA97g5xajvFLAP hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uphper193-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:54:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFhTgh061203;
        Thu, 29 Aug 2019 15:54:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvu06sh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:54:47 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TFslhj013984;
        Thu, 29 Aug 2019 15:54:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 08:54:46 -0700
Date:   Thu, 29 Aug 2019 08:54:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Deadlock during generic/530 test
Message-ID: <20190829155445.GE5354@magnolia>
References: <20190829133156.GA11187@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829133156.GA11187@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=974 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 03:31:56PM +0200, Jan Kara wrote:
> Hello,
> 
> When running fstests, I've hit a deadlock with generic/530 test with
> 5.3-rc6 based kernel (commit 9e8312f5e160 in particular) in my test VM.
> Full dmesg is attached. BTW mount is the only task in D state. In
> particular all xfs kernel processes are happily sitting in interruptible
> sleep.

Hm, is this possibly the same as:

https://lore.kernel.org/linux-xfs/20190821110448.30161-1-chandanrlinux@gmail.com/

(Something about needing to nudge the log along when dumping unlinked
inodes during log recovery?)

--D

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR


