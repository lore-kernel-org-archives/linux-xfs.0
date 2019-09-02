Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E557C3A59E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74201206BB
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ems2JOtp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfIBREr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 13:04:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52294 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfIBREr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Sep 2019 13:04:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82H3k6Y084049;
        Mon, 2 Sep 2019 17:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=t+pFZdUO9dHjUWHHEfHUboeHeflf008VeT1nr2urlZk=;
 b=ems2JOtp7/3PBnNwxc0lbyLJDy6frW/xoI+ox9J19eZL9ZPr+rbHA/52Do2KPURq4bDg
 ByDlz5FQEWLKBIGHQno34ysE3rLrGsagPicnrzDtbi1HZEHTkf4fz9BxdnFJLtbqrL+j
 kvZJtaio2E4odQ620YCbbs5qD13RzCpjwDB34QqpX52cUOVV7xml2GbH34xurEA0C10h
 BtCr2Nd2Z+T33f4jk5fMrCJgt246MNduQihebEjMkHM5dDeYDduBODcC9o8f8+7ZqdpT
 mXdXjIEItzi78CliQUodzK5NzfwvH23BIex9ibIw7eValV+HRkav9QOi3wZHJYCE/QHK tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2us70s0132-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 17:04:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82H3FE8009025;
        Mon, 2 Sep 2019 17:04:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2urww6nqhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 17:04:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x82H4evg030920;
        Mon, 2 Sep 2019 17:04:41 GMT
Received: from localhost (/10.159.145.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Sep 2019 10:04:40 -0700
Date:   Mon, 2 Sep 2019 10:04:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190902170440.GS5354@magnolia>
References: <20190830102411.519-1-hch@lst.de>
 <20190830102411.519-2-hch@lst.de>
 <20190830150650.GA5354@magnolia>
 <20190830153253.GA20550@lst.de>
 <20190901073634.GA11777@lst.de>
 <20190901203140.GP5354@magnolia>
 <20190902075946.GB29137@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902075946.GB29137@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=870
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909020192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=937 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909020192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 02, 2019 at 09:59:46AM +0200, Christoph Hellwig wrote:
> On Sun, Sep 01, 2019 at 01:31:40PM -0700, Darrick J. Wong wrote:
> > It's been mildly helpful for noticing when my online/offline repair
> > prototype code totally screws up, but at that point so much magic smoke
> > is already pouring out everywhere that it's hard not to notice. :)
> 
> That suggests to just keep the macro as I submitted it, maybe with
> a big fat comment explaining the usage.

Ok.  Do you want to resubmit with a comment of your choosing, or let me
write in whatever:

/*
 * Check the mapping for obviously garbage allocations that could trash
 * the filesystem immediately.
 */

?

--D
