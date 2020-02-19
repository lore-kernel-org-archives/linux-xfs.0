Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E74DC34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 107F82465D
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mQjw6f6A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBSVsN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 16:48:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45314 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbgBSVsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 16:48:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JLhghT068091;
        Wed, 19 Feb 2020 21:48:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=znI1wWoZHVMFoKciBT6eT+Xv6qeVTglMh7rT9sFIGBw=;
 b=mQjw6f6AqIgHzJKWvlTx0pZo2pre3pH3pfUpJk3XaVm0liNOaWreUVs7DCiDtC0VT5f1
 0Zwhy6TV258y7vP6YGbtVnFw9Uq6JYPsw2ZcluR5XdVcQRHyS+Dfw5QTfGSGu/KNTW0C
 qZ0hI0HY+GM/Zx9mIdIYRHv4uLm5BBEdjgNVFzQIiOD24EnYseULUz9qRE47dmddBjTV
 c0OHUqaKeWf065pGwPuFBboOfKUMuB1mUVldWDvch40tONqIod7HyuIT9MQqoYsv6LEn
 ZFfQA4nSJ1I62dn9JFHRzPm/HW6jkZ6k7s3r31UsS/9FO6k259+NUIKFh0ErxUTXoBp+ vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y8udke279-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 21:48:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JLflmC156848;
        Wed, 19 Feb 2020 21:48:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud7wx08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 21:48:01 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01JLltah018899;
        Wed, 19 Feb 2020 21:47:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 13:47:54 -0800
Date:   Wed, 19 Feb 2020 13:47:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the di_version field from struct icdinode
Message-ID: <20200219214753.GO9506@magnolia>
References: <20200116104640.489259-1-hch@lst.de>
 <20200218210615.GA3142@infradead.org>
 <20200219001852.GA9506@magnolia>
 <20200219145234.GE24157@bfoster>
 <20200219184519.GB22307@lst.de>
 <20200219192122.GJ24157@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219192122.GJ24157@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 02:21:22PM -0500, Brian Foster wrote:
> On Wed, Feb 19, 2020 at 07:45:19PM +0100, Christoph Hellwig wrote:
> > On Wed, Feb 19, 2020 at 09:52:34AM -0500, Brian Foster wrote:
> > > FWIW, I don't really view this patch as a straightforward
> > > simplification. IMO, this slightly sacrifices readability for slightly
> > > less code and a smaller xfs_icdinode. That might be acceptable... I
> > 
> > I actually find it easier to read.  The per-inode versioning seems
> > to suggest inodes could actually be different on the same fs, while
> > the new one makes it clear that all inodes on the fs are the same.
> > 
> 
> It's subjective. I read it as that the logic assumes all inodes on the
> fs are the same version, but doesn't tell me anything about whether that
> assumption is (or will always be) true. I find that confusing,
> particularly since that's not always the case on older sb versions that
> we still support. IOW, so long as the codebase has to handle the common
> denominator of non-uniform inode formats (or might in the future), I
> don't see much value in using such mixed (feature level) logic when the
> per-inode versioning handles both regardless of the particular sb
> version policy. Just my .02.
> 
> > > don't feel terribly strongly against it, but to me the explicit version
> > > checks are more clear in cases where the _hascrc() check is not used for
> > > something that is obviously CRC related (which is a pattern I'm
> > > generally not a fan of).
> > 
> > xfs_sb_version_hascrc is rather misnamed unfortunately.  In fact I think
> > just open coding it as 'XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5'
> > would improve things quite a bit.
> > 
> 
> Agreed. This would help mitigate my aesthetic gripe around the whole 'if
> (hascrc) { <do some non-crc related stuff> }' thing, at least.

That would work for me too.  Maybe leave a comment somewhere that
XFS_SB_VERSION_5 is required for ondisk di_version == 3, if we haven't
already done so?

--D

> Brian
> 
