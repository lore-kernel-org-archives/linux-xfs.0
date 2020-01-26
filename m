Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46398C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D5420716
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pBxJaMej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgAZWKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:10:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgAZWKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:10:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QM9BK0064589;
        Sun, 26 Jan 2020 22:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+n+gWIk8RNQchkpuQt8eu0KzbPX8OgkLcFSFeYhG+IY=;
 b=pBxJaMejRMHeRALybOoofuYo44ibKx8VFfOZBatKl2D4TxA8OznpeCvTA+E8OfPS3aCd
 3op76dhAVGyMKyjBD2kEbcmIHDSBOA7EjSY/4x0O1+fijs3gSXtmbCJufNaRxUpjFOns
 he+Dr0M0dJVYNVbyydZ76mH7dPB8MGOMMl41xZ7kG8wvQH5F3wbrjOhFEJ5Fk9m8BElR
 ttjUuKlmhqW5inoXUc10CtXM2+lkCXX5kObsOct0rjEfLJjKFkkBECaQZCjQwCvWMm95
 IMt2jR+3egFdo/RWgHP/+cVHR8xZopK7k5M9VYq7q52WuoLneqryiytCD/c3DKBxVQDo 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xrd3tvgt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:09:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QM9BfB163488;
        Sun, 26 Jan 2020 22:09:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xry6nahry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:09:39 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00QM9c7u013357;
        Sun, 26 Jan 2020 22:09:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:09:38 -0800
Date:   Sun, 26 Jan 2020 14:09:37 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfsprogs: alphabetize libxfs_api_defs.h
Message-ID: <20200126220937.GB3447196@magnolia>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
 <5660a718-54b8-2139-8bcf-ae362d09ee5e@redhat.com>
 <20200125231443.GC15222@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125231443.GC15222@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=704
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=768 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 25, 2020 at 03:14:43PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 22, 2020 at 10:41:05AM -0600, Eric Sandeen wrote:
> > Rather than randomly choosing locations for new #defines in the
> > future, alphabetize the file now for consistency.
> 
> This looks ok, but can we just kill off the stupid libxfs_ aliases
> instead?  They add absolutely no value.  I volunteer to do the work.

About the only use I have for them is xfs/437 which checks that we
actually use the libxfs names and that we invert error codes correctly.

So if you're going to kill the libxfs_* aliases you might as well make
the error code sign consistent too.

--D
