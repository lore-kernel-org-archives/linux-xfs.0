Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7B4C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0FC206F7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ePAn55+M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHXCcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:32:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgHXCcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 22:32:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2USWv148494;
        Mon, 24 Aug 2020 02:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=v7lJr4hbIXFzE7bi9DNZrWVM6RycfpYCL+WZXipNr5k=;
 b=ePAn55+MzN3hXQQAi440Y7d6a4s80q2crfUhpVEBTEqL4UP0IkjR5IozDzSGcdQswwTE
 ZhP1idESq+u1C50lqrnsO21aOtL8+MNK/WzX61BAUTgp0m1FhXCA9GSwbjwntQ3eeb+u
 2a9+9zkogaJl0TXkXdZv7CsqM5QyHp4lu2AnUkl57pRARl+fsGwr30I1lZZIWWompLic
 ilJFqymLkrMqGfoysYnKknRWrPmBPrgMnjoZTXlVw8VbN1elzlFrZniU5rvCfxkyo6it
 dLM3liycAVJ0OQmZ9/F9FIIo3SaqYzI0ww2TeQBElDxNH24llZUE4H83Y7PgRFKsYzXT jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 333csht3kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 02:31:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2U4ew183648;
        Mon, 24 Aug 2020 02:31:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 333ru3j6ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 02:31:48 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07O2VgFI007576;
        Mon, 24 Aug 2020 02:31:43 GMT
Received: from localhost (/10.159.140.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Aug 2020 19:31:42 -0700
Date:   Sun, 23 Aug 2020 19:31:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log code
Message-ID: <20200824023141.GN6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797592235.965217.10770400527713016921.stgit@magnolia>
 <20200822071631.GE1629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822071631.GE1629@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=1 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 22, 2020 at 08:16:31AM +0100, Christoph Hellwig wrote:
> On Thu, Aug 20, 2020 at 07:12:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move this function to xfs_inode_item.c to match the encoding function
> > that's already there.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> An good reason to not move it towards its only caller in
> fs/xfs/xfs_inode_item_recover.c?

"Darrick forgot to do that after refactoring the log recovery code"? :D

Yeah, I'll take care of that.

--D
