Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC6DC46466
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C51D7207BC
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ARARMwjK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgJERDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 13:03:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58758 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgJERDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 13:03:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095H0HSi013531;
        Mon, 5 Oct 2020 17:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hfVat8ihSER2hIPAJZ/6O9or1S/Dbe1BA2pCN+nANd0=;
 b=ARARMwjKmfV1YGDInahQOy9KjW+AlIgWweAsgu876T94W/RBwKRT18RiNpAjO5njgVRk
 82CkkL0xR7xRswGMg3JfLiN52GxNfWJoCYForyR6wiM9snFXqismUQyNpBVv2A4Ro7m1
 djdxIz9IyPGRkMYDO2OjQ/szKdW3zksUVx5GMA0yBN9mIteimOOnXhcRcuXfq+YotZTL
 OQz2g0YJwUM/MfLTh/kI8eMgv5kjQ/B98YI28lK31OuJ5NxmH9YyEDFdV3zVX7Mbxq3/
 juM8sMDCCmPeeOZch/yvlole2ZO9G5bNNLk/smB839K35O1guksYawBHIcjfrhFnOmfA SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetapuuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 17:02:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095GtEOL034876;
        Mon, 5 Oct 2020 17:02:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vkrurt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 17:02:55 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095H2sX5000428;
        Mon, 5 Oct 2020 17:02:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 10:02:54 -0700
Date:   Mon, 5 Oct 2020 10:02:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: streamline xfs_getfsmap performance
Message-ID: <20201005170253.GG49547@magnolia>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia>
 <160161417069.1967459.11222290374186255598.stgit@magnolia>
 <20201002071505.GB32516@infradead.org>
 <20201002175808.GZ49547@magnolia>
 <20201005063001.GA4302@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005063001.GA4302@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 07:30:01AM +0100, Christoph Hellwig wrote:
> On Fri, Oct 02, 2020 at 10:58:08AM -0700, Darrick J. Wong wrote:
> > On my 2TB /home partition, the runtime to retrieve 6.4 million fsmap
> > records drops from 107s to 85s.
> 
> Please add these sorts of numbers to the commit log..

I did add them to the V2 patch, but maybe you're just waiting for the
resend... :)

(On its way shortly)

--D
