Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99F1C282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE04820692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sr7jcG6Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgAHQh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:37:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgAHQh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 11:37:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GXEi9031147;
        Wed, 8 Jan 2020 16:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=S8qgM3EbhSxsUhN36m8hqN/WFK3xRk/eStO/ia5FO6U=;
 b=Sr7jcG6Ybf689ULVd4La/aSUiZbtOa7LABSLv5snoeqX1ol4wEqgcYjPX3+HSzXucU5b
 jI1UIcIYlfLrQNobBF8K95ufi2/PP+NdgsktflhVbHECy+QMjDxzGfZzck4FYI2JDCMM
 HpGKxFH6PEb0983AKTPZhvhOM8ZJje9SMIxb7XCp2GSQdrHb9NPM1iccns5LpGI2vVU3
 iHB1cg4A/6AachRocARrgN6V+c4fBNV2JplWj64y8VYBbwXKg5Bt6b/01owL1GkrmqUn
 uL8nklUkEWNwP0FkUKMXZLnBfdgomEujJ468Ekv3zh+jba6TALVFmRG4t+AAaeIlEXNo fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xajnq51q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:37:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GY2Z2020198;
        Wed, 8 Jan 2020 16:37:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xcqbpkyg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:37:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 008GbKv8002445;
        Wed, 8 Jan 2020 16:37:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 08:37:19 -0800
Date:   Wed, 8 Jan 2020 08:37:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200108163718.GF5552@magnolia>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845705884.82882.5003824524655587269.stgit@magnolia>
 <20200108080927.GA25201@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108080927.GA25201@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 08, 2020 at 12:09:27AM -0800, Christoph Hellwig wrote:
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1540,6 +1540,7 @@ typedef struct xfs_bmdr_block {
> >  #define BMBT_BLOCKCOUNT_BITLEN	21
> >  
> >  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> > +#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK)
> 
> I think throwing in a comment here would be useful.
> 
> Otherwise the patch looks good to me.

Ok, done.

--D
