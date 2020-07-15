Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEE4C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 23:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8EF20714
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 23:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fKfAshlP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGOXy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 19:54:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36276 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOXy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 19:54:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FNgFmQ193447;
        Wed, 15 Jul 2020 23:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=r9/8Cs/B8aclrb/7RtzayUDLA4OIKFgT9PKPcVMQFxA=;
 b=fKfAshlPCkH1wxxFmoa5UkYDJDkr9uOGNoPZUNAMo6CgUfE4Ry+cB/3GL3v6zGF8QDNY
 K1B2QGSwhQP640iCQgl+bbbA/uLRS2/tV3FIDTN32GBncLfQKSA2O80fu3peUa7vNwoQ
 l4NfaD/HHNUZk8yv/ULrTonXx+mJdQT9w2O8+Rart3oqu0kRj1GB5ky64Lv5L6Dw6p0s
 XB1c6QWl7Upo2wfXIaYOxmIMQS62J2MmUvDfF8DrE1yKzTcg8nhnccaPlhOs0q6bUrii
 q1dCossd5py7dwUBBcVrksbsh5g33OyqNC3Utruzb6GNcQ3gRjqJCnkD+mSk+IgH2O3L MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urec7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 23:54:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FNcwVp149703;
        Wed, 15 Jul 2020 23:54:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qc202tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 23:54:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FNsGKm015845;
        Wed, 15 Jul 2020 23:54:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 16:54:16 -0700
Date:   Wed, 15 Jul 2020 16:54:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: don't double check dir2 sf parent in phase 4
Message-ID: <20200715235414.GF3151642@magnolia>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-3-bfoster@redhat.com>
 <20200715184350.GB23618@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715184350.GB23618@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=895 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=900 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 07:43:50PM +0100, Christoph Hellwig wrote:
> On Wed, Jul 15, 2020 at 10:08:34AM -0400, Brian Foster wrote:
> > The shortform parent ino verification code runs once in phase 3
> > (ino_discovery == true) and once in phase 4 (ino_discovery ==
> > false). This is unnecessary and leads to duplicate error messages if
> > repair replaces an invalid parent value with zero because zero is
> > still an invalid value. Skip the check in phase 4.
> 
> This looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> As far as the existing code is concerned:  Does anyone else find the
> ino_discovery booleand passed as int as annoying as I do?  An
> "enum repair_phase phase" would be much more descriptive in my opinion.

I can never remember what "ino_discovery" actually means.  true means
phase2 (looking at inodes for the first time) and false means phase4
(looking for crosslinked data and whatnot)?

--D
