Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C919C38BFA
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E820218AC
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fRlqH8N6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgBXWTo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 17:19:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXWTn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 17:19:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OMHfuC102196;
        Mon, 24 Feb 2020 22:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qTA36Q7ulfD0km9+i5eSSXNWCvgFmRfON/1Zv3DMSWo=;
 b=fRlqH8N6pggziS/GKqfsmD6/r+/8kE57hnLVRjJv7xpoy7oe1wmIOYIKOolhs6OAjRSv
 XE0aqM30D/CPd1qL25YX4vb6/LDxCd4x7VPGz2EcsSyBjpaaIm0gy9h3xN9bjQAXC0GE
 sPt6V7a9Ii45/srnCpXjhdb2AEZB2KN0P14FC399WK+to3fmuE6OzW9Z8Ho0y9/2aCoN
 OcDyNR/uOneFbU6nzhsKdHJbjQ0Zk/fZSd3oQkasERJR4J0gXtecfS3gvtKZ8ajL276I
 EVBBgcaVsgb7y6VsFdi1JLrXTjsxN9l8U9eEX21gq6LGpQ+eQaDxM7jK+vuqkJ5c5rzC fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ybvr4ppg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 22:19:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OMI6gY181265;
        Mon, 24 Feb 2020 22:19:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yby5dwkdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 22:19:34 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01OMJX3W004556;
        Mon, 24 Feb 2020 22:19:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 14:19:32 -0800
Date:   Mon, 24 Feb 2020 14:19:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200224221931.GA6740@magnolia>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de>
 <20200224220256.GA3446@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224220256.GA3446@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:02:56PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 30, 2020 at 02:33:38PM +0100, Christoph Hellwig wrote:
> > struct xfs_agfl is a header in front of the AGFL entries that exists
> > for CRC enabled file systems.  For not CRC enabled file systems the AGFL
> > is simply a list of agbno.  Make the CRC case similar to that by just
> > using the list behind the new header.  This indirectly solves a problem
> > with modern gcc versions that warn about taking addresses of packed
> > structures (and we have to pack the AGFL given that gcc rounds up
> > structure sizes).  Also replace the helper macro to get from a buffer
> > with an inline function in xfs_alloc.h to make the code easier to
> > read.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Any chance we can pick this up for 5.6 to unbreak arm OABI?

Yeah, I can do that.  Is there a Fixes: tag that goes with this?

Also, will you have a chance to respin the last patch for 5.7?

--D
