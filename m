Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C946DC3F2CE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 15:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DF262076F
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 15:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+NitH41"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbgCPPET (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:04:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731860AbgCPPET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 11:04:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GF2diQ159541;
        Mon, 16 Mar 2020 15:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LipaG7Qiy9HgGJ0pNR47PpCB7j89PZBJlc6+LYkT5QA=;
 b=V+NitH41f8Z7PMRwsBEHFmTNof+KQBMgbIWuNGIrXetndr3zsD958R287+f1tkFCH6re
 rOWMxukChmbcWKGr18I+Ui0xJNgMwVYGpoWTU/bzOU5u7LyGaZPDB83CjV8O2vpAOxId
 LYzA9+AfVAaqa3K/+4/bbDEPoYluhhPGy+G96tH+JuNyRsLHrwqjTU3BBPL3a6Bd2yPo
 6rlhnVsJ3Li4cadBtxJ6qGWzQmpNOpnYM8vyFwmMqeOlaGNv7hcG8poRnsWWFwpY52OV
 6Ngsir74eLNQa7k73Pa7+IkSrwL1reiCLKiliQQ+aPJ19mx6aj9qCQrkPlEpQ/7ZXTp/ 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yrq7kqe7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 15:04:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GF2Y4J010183;
        Mon, 16 Mar 2020 15:04:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ys8tpwgn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 15:04:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GF3s8B014789;
        Mon, 16 Mar 2020 15:03:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 08:03:53 -0700
Date:   Mon, 16 Mar 2020 08:03:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/7] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200316150353.GC256767@magnolia>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431624662.357791.16507650161335055681.stgit@magnolia>
 <20200316104106.GA9730@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316104106.GA9730@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:41:06AM -0700, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 135f4478aa5a..3b0b21a4dcde 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -41,6 +41,7 @@ xfs-y				+= $(addprefix libxfs/, \
> >  				   xfs_bmap.o \
> >  				   xfs_bmap_btree.o \
> >  				   xfs_btree.o \
> > +				   xfs_btree_staging.o \
> 
> We only needs this for online repair don't we?  Can we exclude the
> file from the build for xfs configs without scrub/repair?

That could be done, provided we don't mind having #ifdef
CONFIG_XFS_ONLINE_REPAIR checks in the parts of libxfs that call
xfs_btree_commit_afakeroot and xfs_btree_stage_*fakeroot.

After which we'll have to work around that in xfsprogs when I (re)send
my series to refactor all the open-coded btree creation code out of
xfs_repair.

Not a big deal if others want to save ~9k of space (debug mode is on):

   text    data     bss     dec     hex filename
   8767     313       0    9080    2378 fs/xfs/libxfs/xfs_btree_staging.o

--D
