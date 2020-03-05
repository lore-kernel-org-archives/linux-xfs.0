Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EB4C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 17:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D45620848
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 17:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MXgSoSV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgCERtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 12:49:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCERtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 12:49:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 025HT5mB026679;
        Thu, 5 Mar 2020 17:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gBSLuQTcG3pjwSSor/YnapvaCFcE9qt5HDcY0yWg8Kc=;
 b=MXgSoSV7PQVA2t4QKFGPr3cDe4QsNg37Aa5ZtCh3fNb+COJoh/mtA14zkX7V+XGhBP40
 MUGwjEzab42jdOabVFgkfztiroq98sn4OTkLG8SXgkvAR5NS8PUk34ZM7Req+aYm/N8Z
 ckVqrMAhw7o8a5kn/5vVSk974Asn/8OUpnDe1exxAeAGapgCLFhcw4+pbyqSLQ+I8UAc
 P5usQLNY/WjO/bhsbK8WC1czubsqGvTjDgGZphjXJqpdM3WiViD1USfjrnzmq7jxcSXN
 0E6W8XfOtG4IOt6zAWO/ouP/SbqC2Ke4WQ2FDgdYrfo/y4OtP4nIy9gtpZ0ukPULWHUT SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yghn3jh32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 17:48:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 025Hka5o083594;
        Thu, 5 Mar 2020 17:48:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yg1pb5rx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 17:48:50 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 025Hmn6I031803;
        Thu, 5 Mar 2020 17:48:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Mar 2020 09:48:49 -0800
Date:   Thu, 5 Mar 2020 09:48:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: check owner of dir3 blocks
Message-ID: <20200305174848.GT8045@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294094178.1729975.1691061577157111397.stgit@magnolia>
 <20200305165128.GE7630@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305165128.GE7630@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 08:51:28AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 28, 2020 at 05:49:01PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check the owner field of dir3 block headers.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> > +		(*bpp)->b_flags &= ~XBF_DONE;
> > +		xfs_trans_brelse(tp, *bpp);
> > +		*bpp = NULL;
> > +		return -EFSCORRUPTED;
> 
> Although I wonder if we should factor this repeated sniplet into a
> helper..

Yes.  Dave and I were discussing in patch 1 that
xfs_buf_corruption_error() is the correct function to call for a buffer
that we've decided is corrupt outside of a read verifier, so this all
becomes:

if (fa) {
	xfs_buf_corruption_error(*bpp...);
	xfs_trans_brelse(tp, *bpp);
	*bpp = NULL;
	return -EFSCORRUPTED;
}

(We also observed that xfs_buf_corruption_error ought to stale the
corrupt buffer to get it out of the system asap.)

--D
