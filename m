Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984B3C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 19:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9A020B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 19:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DmjwhE2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbfJITsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 15:48:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48788 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731173AbfJITsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 15:48:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99JhuLT151185;
        Wed, 9 Oct 2019 19:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=aRGFY/1sepvMtKTWM0pjHGpLksGX8MVCsubt8jGp6pA=;
 b=DmjwhE2rRpXKIX4R0WcXjS2yklIYjYfq2+OKcMx3cDp8tVH/osos3pB4r5Xsgbzdoq/4
 o+4aQm3xLoZfvDHMmm+ePGsRpYzxybeokxD52YgabESyGGldu35lfR0Wpsk+X8USLLK1
 hNECP92a+A/VuYXPDg3WZW/Zx/69d9iY5CU8VzPWDcl7ILyOje7D4+xvI1PBXPzx5g23
 5PQ6pU8YRjaUUcSK/V1dsWULhutKR/Zrv84p4PIhe6ISoLxH36HfoBkgLo+Vg2RtN1RV
 g6SlCk4ol6RbYfX2PPvGTid9wsjf3LhzProzmYkAM+4Sb3wZG6FLICUjZxbrO8+qJhsp Ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vek4qpwpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 19:47:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99JTFnB098327;
        Wed, 9 Oct 2019 19:47:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vh5cbd6vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 19:47:52 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99JlnNO004930;
        Wed, 9 Oct 2019 19:47:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 12:47:49 -0700
Date:   Wed, 9 Oct 2019 12:47:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 08/17] xfs: mount-api - move xfs_parseargs()
 validation to a helper
Message-ID: <20191009194747.GH13108@magnolia>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062065250.32346.13350789812067183237.stgit@fedora-28>
 <20191009150206.GF10349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009150206.GF10349@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 08:02:06AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:30:52PM +0800, Ian Kent wrote:
> > +#ifndef CONFIG_XFS_QUOTA
> > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > +		xfs_warn(mp, "quota support not available in this kernel.");
> > +		return -EINVAL;
> > +	}
> > +#endif
> 
> this can use IS_ENABLED.

I didn't think that macro needed a CONFIG_XFS_QUOTA check...?

--D
