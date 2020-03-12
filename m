Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CAFC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 04:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93651206EB
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 04:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gDYjxuL9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbgCLE4R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 00:56:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387676AbgCLE4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 00:56:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C4qV8W164779;
        Thu, 12 Mar 2020 04:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Gt2OoDhYP4kLNYCEiHUFP64EbxVESWStj4p2rYHslL0=;
 b=gDYjxuL9KZyzFmJ43fXtTPWRSQyOdTLCRjPoV6TZobJ+ta60mdAtJI8C2SGhPfPK0Cug
 mMz+9hF94W1k3VEVFZxAmF7Sr/t/oGGbayo6JzGJpBVgYV6NYPaLKowvfbelCDsy2+yv
 nSnpdJM3/bsI/W5BILAqboA5LKXlmzxcBNu6ObIvcDA3LjWvLQ5+/bL2BHkwOjyYEbMI
 ExqT3e2jwq4Xw8u2s9brYxySCBT3gAGK13+B+q9SO2opvBuN64rrv3djOm2ZYzdrtbFD
 jeRvlufZ3xbb1KJlWa15DFeD69uKVXk40k7lAbuS2kWk6pIn9jXNo8Pmr7N76dr1y0qD mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yp9v6aex5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 04:56:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C4q8R4153811;
        Thu, 12 Mar 2020 04:56:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yp8qyedq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 04:56:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C4uCuO010150;
        Thu, 12 Mar 2020 04:56:12 GMT
Received: from localhost (/67.169.218.210) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 11 Mar 2020 21:55:59 -0700
USER-AGENT: Mutt/1.9.4 (2018-02-28)
MIME-Version: 1.0
Message-ID: <20200312045558.GK8045@magnolia>
Date:   Wed, 11 Mar 2020 21:55:58 -0700 (PDT)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/7] xfs: add a function to deal with corrupt buffers
 post-verifiers
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
 <158388763904.939165.1796274155705134706.stgit@magnolia>
 <20200311182533.GI8045@magnolia> <20200312043723.GI10776@dread.disaster.area>
In-Reply-To: <20200312043723.GI10776@dread.disaster.area>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:37:23PM +1100, Dave Chinner wrote:
> On Wed, Mar 11, 2020 at 11:25:33AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a helper function to get rid of buffers that we have decided are
> > corrupt after the verifiers have run.  This function is intended to
> > handle metadata checks that can't happen in the verifiers, such as
> > inter-block relationship checking.  Note that we now mark the buffer
> > stale so that it will not end up on any LRU and will be purged on
> > release.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: drop the (broken) dirty buffer check
> 
> Looks good now.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cool, thanks for the review!

--D

> Dave Chinner
> david@fromorbit.com
