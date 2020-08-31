Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E00C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC3E2083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QodpyMel"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgHaTq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:46:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgHaTqX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:46:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJhbPf019739;
        Mon, 31 Aug 2020 19:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UZupMG9/TgQavRA+RfNip5BSCmBqFZCsPCLz9fxlKY8=;
 b=QodpyMeliutzTAuVvEtpX+tdlEapB5roQEDQiwq/67xWwrG2/W3NjcQZuZpIu6dN27o9
 ShQ9XLO2wl0tcsaBjDt8cPwfOZttyvk9TC5IfkOJfVw5lgysehgDXbJNcDVMnbH1VU/S
 SWapKTKL+6EaPkXwookD66cy1CK8R8QUEeV97O5l+Zrv2tbSKqzBMPltmbr9GyG5sJTw
 ESujusqDPHePzVX0Upue/lAAek4Vu+gh9siO+qoUeIYkMLg1cUx6wCziglhZDIJ+h1jk
 urlNvLGsPRch6FtONJjcsIe1rB06cJfWbKm2JAGku5B6kLX7nHYfztTVOdVcWL33d0uL 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhf9gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 19:46:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJZAeS090146;
        Mon, 31 Aug 2020 19:44:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380km53qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 19:44:13 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VJi5PF014914;
        Mon, 31 Aug 2020 19:44:05 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 12:44:05 -0700
Date:   Mon, 31 Aug 2020 12:44:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, amir73il@gmail.com,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk inode timestamps to deal with
 y2038+
Message-ID: <20200831194408.GU6096@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885405947.3608006.8484361543372730964.stgit@magnolia>
 <20200831160810.GC7091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831160810.GC7091@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 05:08:10PM +0100, Christoph Hellwig wrote:
> On Sun, Aug 30, 2020 at 11:07:39PM -0700, Darrick J. Wong wrote:
> > +static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
> > +{
> > +	return (xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC) + tv.tv_nsec;
> 
> Nit: no need for the braces due to operator precedence.

Fixed.

> > +	return xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
> > +	       !xfs_inode_has_bigtime(ip);
> > +}
> > +
> >  /*
> >   * This is called to mark the fields indicated in fieldmask as needing to be
> >   * logged when the transaction is committed.  The inode must already be
> > @@ -131,6 +137,16 @@ xfs_trans_log_inode(
> >  			iversion_flags = XFS_ILOG_CORE;
> >  	}
> >  
> > +	/*
> > +	 * If we're updating the inode core or the timestamps and it's possible
> > +	 * to upgrade this inode to bigtime format, do so now.
> > +	 */
> > +	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> > +	    xfs_inode_want_bigtime_upgrade(ip)) {
> > +		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
> > +		flags |= XFS_ILOG_CORE;
> > +	}
> 
> Despite the disagree with Dave I find it very confusing to use
> both a direct reference to XFS_DIFLAG2_BIGTIME and one hidden under
> two layers of abstraction in the direct same piece of code.

Same here, I'll change it back to:

	/*
	 * If we're updating the inode core or the timestamps and it's possible
	 * to upgrade this inode to bigtime format, do so now.
	 */
	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
	    xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
	    !xfs_inode_has_bigtime(ip)) {
		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
		flags |= XFS_ILOG_CORE;
	}

I'm not a huge fan of the single-line inode-has-bigtime predicate
either, but at least it's consistent stylistically with the predicate
for the dinode and the log dinode...

Anyway, thanks for the review!  Now on to the buffer disposition v2
series....

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
