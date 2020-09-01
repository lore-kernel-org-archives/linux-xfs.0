Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2485DC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 17:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 012CD207D3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 17:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DwcYqVnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgIARxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 13:53:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53782 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbgIARxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 13:53:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081Ho7ph001708;
        Tue, 1 Sep 2020 17:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Hq1xIETdU6LdhcVnHgqDrH+I6k/5cxdUtFTqzdQsqdc=;
 b=DwcYqVnDFSL4f8pS6lOrK/Le4sN6jVUl2TiJC0BkJi5G7uWp69/q5C4BCo46DkGY2PZl
 mxhQ856m7KZeyzn/RC5bqbHUKL4mcvtiRNcT9vN40zZNbSbevR1xV3PwtykNiC058Qu+
 ob9hXd+0ZMHB/7jYVp8XHLo3Ibv29sOHgzCkCjSDfz6JGiy2nvR4z54LNGLqwj9P49Lg
 IzFKusE6+w8YxG3Y15X+jyPDcmmBST7lUJdNYjNMu3Ixg1D8mUiPlEa3Zco2rjfzOv7U
 FrhUX4h2gEPeryVJh9PiLiarYxoVE6nLrjdiSGP2zStmTIQf4aaM1ZEL5eTWHaDt1lhb DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eym5xm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 17:53:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081HobNO026081;
        Tue, 1 Sep 2020 17:53:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380x41mjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 17:53:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 081HrQ7d015875;
        Tue, 1 Sep 2020 17:53:27 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 10:53:26 -0700
Date:   Tue, 1 Sep 2020 10:53:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk inode timestamps to deal with
 y2038+
Message-ID: <20200901175323.GJ6096@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885405947.3608006.8484361543372730964.stgit@magnolia>
 <20200901114412.GE32609@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901114412.GE32609@xiangao.remote.csb>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 07:44:12PM +0800, Gao Xiang wrote:
> On Sun, Aug 30, 2020 at 11:07:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Redesign the ondisk inode timestamps to be a simple unsigned 64-bit
> > counter of nanoseconds since 14 Dec 1901 (i.e. the minimum time in the
> > 32-bit unix time epoch).  This enables us to handle dates up to 2486,
> > which solves the y2038 problem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Look good to me overall (although I'm little curious if
> folding in xfs_inode_{encode,decode}_bigtime() would be
> better (since it may have rare users in the future?)...
> and may be

They were open-coded in previous iterations, but one of the reviewers
asked for the bigtime de/encoding code to be split into separate
functions.

> > +static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
> > +{
> > +	return (xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC) + tv.tv_nsec;
> 
> parentheses isn't needed here since it's basic arithmetic
> but all things above are quite minor...

Yes, that was fixed...

--D

> Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Thanks,
> Gao Xiang
> 
