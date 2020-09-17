Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2704DC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF5A720795
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AwdTDW8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgIQQ0h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:26:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38344 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728077AbgIQQ0F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 12:26:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HGOt3t187371;
        Thu, 17 Sep 2020 16:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=M+Bq4CKF0eM/Wshgk7g3+4XAf9CTCNTp63BR7hKxN/A=;
 b=AwdTDW8ug5A2LybvWtWC1SBguyypAXdoRYAL8Si9UUH74oPXGzGdfzxMzorNDAiEuCWQ
 tRl8SCSrM8dhQ2M+ddGxw/9wjiGKQSOdDynm5t9XniCm5MkLPXpQHkQzTSTditN1ef8H
 3sUdrQF+tsN33R1mixbRzxiAT0YFxDZhyawrXczQJgwlPdoptfZlIdT0llB4WruM7JVa
 4uhppnE4yrCVzGy59SHx1YV+fn6Kqs8PbB0vMhXhg1O3TbtnI1LRIMDsT+M5JXVLjroi
 P1leNQ/riKz23DSpWv/DAzl4ti70sWZbQWDRtAcoP+HyIzTmvv9Hf7LbaopAD0LoqSmU Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9mjbnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 16:26:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HGPwU1037482;
        Thu, 17 Sep 2020 16:25:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33hm35519j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 16:25:58 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08HGPmD3012617;
        Thu, 17 Sep 2020 16:25:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 16:25:47 +0000
Date:   Thu, 17 Sep 2020 09:25:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: don't allow creation of realtime files from a
 proto file
Message-ID: <20200917162546.GE7955@magnolia>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
 <160013468391.2932378.13825727040727340226.stgit@magnolia>
 <20200917080234.GV26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917080234.GV26262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 09:02:34AM +0100, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 06:51:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If someone runs mkfs with rtinherit=1, a realtime volume configured, and
> > a protofile that creates a regular file in the filesystem, mkfs will
> > error out with "Function not implemented" because userspace doesn't know
> > how to allocate extents from the rt bitmap.  Catch this specific case
> > and hand back a somewhat nicer explanation of what happened.
> 
> Would this be so hard to fix?

Probably not, but I'd prefer to see users asking for this feature before
porting more code to userspace.

I guess I could take a look for 5.10, maybe it's not that difficult.

Though given the amount of bitrot and math errors I've seen recently, I
get the funny sense that my crash test box and TV are the only things
using rt support.

--D
