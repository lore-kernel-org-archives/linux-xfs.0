Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5CBC432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 16:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9A22071F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 16:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sop/ppQ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfLBQkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 11:40:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49626 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfLBQkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 11:40:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2GdbCL181606;
        Mon, 2 Dec 2019 16:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=B9Vo9BgjDNSzIlthiBxCj8wMoX9IkK5PZxJwCssBn1w=;
 b=Sop/ppQ1e3J9AUtYHqyZSN7zRzJed/zWxMUpZCbz/b4n7VGZOQiIQBixXbPkkVzRxOui
 CJrg/mewsQTKqQdjbLSc0Z2NduxtkzBlkfnJ4TjMCCilCTgaTeu8wECfev6MSX3EJ2gN
 0UDs1lsrKFaWuHAEN88Nj20qi5Z+XxPg3FGKukoPQfncV64TdkqPtjkxd+BzUq8CgJdc
 NC2nxvSvzW1MhyGd4BuVrBtSvll0OgZSmS3tm+v0us9dThs3f1e9ZveYZeGBpc24M2iv
 w1Xv3pg7KLxcE2b1GRKKmP6a06JJOL24SCN0XvcKai7OfQc03hSg8e0lJsW0ClopsW7b Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wkh2r16hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 16:40:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2GcOR6039680;
        Mon, 2 Dec 2019 16:40:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wn4qmykwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 16:40:39 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2Ged1C008433;
        Mon, 2 Dec 2019 16:40:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 08:40:38 -0800
Date:   Mon, 2 Dec 2019 08:40:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191202164038.GC7335@magnolia>
References: <20191128062139.93218-1-preichl@redhat.com>
 <BYAPR04MB5749DD0BFA3B6928A87E54B086410@BYAPR04MB5749.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB5749DD0BFA3B6928A87E54B086410@BYAPR04MB5749.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=684
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=806 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 30, 2019 at 10:01:17PM +0000, Chaitanya Kulkarni wrote:
> Not an XFS expert, but patch to handle ^C is been discussed on the
> block layer mailing list which includes discard operations. [1]

Heh, I wasn't aware of that. :)

> This solution seems specific to one file system, which will lead to
> code repetition for all the file systems which are in question.
> 
> How about we come up with the generic solution in the block-layer so
> it can be reused for all the file systems ?
> 
> (fyi, I'm not aware of any drawbacks of handling ^C it in the block
> layer and would like to learn if any).

The only one that I can think of is how to signal a partial completion,
but if you're only aborting on *fatal* signals then that doesn't matter.

Fixing the block layer seems like a better answer anyway.

> [1] https://patchwork.kernel.org/patch/11234607/

Though looking through that patch raises the question of whether xfs'
control loops also need to check for fatal signals, similar to what the
online scrub loops do?

--D

> -Chaitanya
> 
> On 11/27/2019 10:21 PM, Pavel Reichl wrote:
> > Some users are not happy about the BLKDISCARD taking too long and at the same
> > time not being informed about that - so they think that the command actually
> > hung.
> >
> > This commit changes code so that progress reporting is possible and also typing
> > the ^C will cancel the ongoing BLKDISCARD.
> >
> > Signed-off-by: Pavel Reichl<preichl@redhat.com>
> > ---
> 
