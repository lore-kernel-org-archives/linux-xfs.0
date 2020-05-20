Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4A5C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B05520671
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n50a+gIz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgETSSj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 14:18:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETSSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 14:18:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIHRVt000770;
        Wed, 20 May 2020 18:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HDgxKuKRDYZvoPAQGbXSoKgBKBXCYX1azLAxa603Zu0=;
 b=n50a+gIzF1TEyURHp1IXT83gjj0yUBuVbhDiLryqw0BhJA/Dey/isC+Q12/of7GyD5Pd
 9uyriEEgzF5kZg/UhGEZYhHDDcjxdku0I05Rs9/U9CRtmcT+VLuIL7tYPTfF0Fqar+5I
 JXuhxy6aJW1gjICUfs3EhW2HDg2Q9n11zoYJ/f9mOpn8HwzgEnrzHtgmiWnFTKxgytBG
 0rqtpgoblAbX9WJGY4nAcT1MYhmjMyVPDT/d9k+mVJXN+ZN5SVv6au4bsqtRswPijXBK
 Q9Qs6WmJSsGL610+N9bV1ckjO2ovRXjfWY0wBGU9CLUrYnU5hfDDIv0oGTLUuG2TuXpW UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31501rb6x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 18:18:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KID95G187236;
        Wed, 20 May 2020 18:18:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t38bpkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 18:18:11 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KIIA4b011747;
        Wed, 20 May 2020 18:18:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 11:18:09 -0700
Date:   Wed, 20 May 2020 11:18:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: replace libreadline with libedit
Message-ID: <20200520181808.GV17627@magnolia>
References: <158984953155.623441.15225705949586714685.stgit@magnolia>
 <158984955088.623441.1505969186471077833.stgit@magnolia>
 <20200520173713.GC1713@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520173713.GC1713@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 10:37:13AM -0700, Christoph Hellwig wrote:
> On Mon, May 18, 2020 at 05:52:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that upstream has dropped libreadline support entirely, switch the
> > debian package over to libedit.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Do we need to resync with the real Debian packaging?  That has switched
> over quite a while ago.

It did?  It looks to me like debian uses the upstream packaging, even
though they occasionally curse us for doing so.

Now, Ubuntu seems to be doing some sort of valueadd thing around blkid
and "broken configure" but AFAICT they're not sending whatever they
fixed back to us.  Party like it's 2005 again.

--D
