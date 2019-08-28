Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2032DC3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 17:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E967A22DA7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 17:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IremCd3g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfH1Rfl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 13:35:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1Rfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 13:35:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SHYHFQ074748;
        Wed, 28 Aug 2019 17:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1h+7HnrYWuh/WLyGNsPQv36a7S6Nb5z0A5cwHLTLeV4=;
 b=IremCd3gb70LWv4zVx/hCIfHgzfTHAzUcUzHZ8McmFLShytEXu9RKM3bJ+2pCspt1YPJ
 lxsXmdpXVccujvX6J7Gj6Yurmp2l7tXhPgZzUnngAr03mB83dBhr78eYSDVfdag37UPI
 Z5BJuDYL82faXvKOebIrlmwvObxNRkA69LbVTK1c230cIIckewoOJpTnsbKpD6c2qJAS
 7fa6vELe7fHXCpnJUO2HaFbhasv9p8ndWJG0IE1YKTVuitlUHf6J8bi4OdKEG/Iijmjp
 7FgSe7bsWlvdvW37BkJ5VNuhzHqfrLi+G74hxcWnIXMLWNKgmrv3lSGVCJ1P58Hi9raw zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2unx4cg0ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 17:35:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SHWqbR044707;
        Wed, 28 Aug 2019 17:35:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2unvtxkv9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 17:35:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7SHZZ0e002699;
        Wed, 28 Aug 2019 17:35:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 10:35:35 -0700
Date:   Wed, 28 Aug 2019 10:35:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] libfrog: create online fs geometry converters
Message-ID: <20190828173534.GG1037350@magnolia>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
 <156633305717.1215733.17610092313024714477.stgit@magnolia>
 <20190827071106.GD1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827071106.GD1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 05:11:06PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 01:30:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create helper functions to perform unit conversions against a runtime
> > filesystem, then remove the open-coded versions in scrub.
> 
> .... and there they are...
> 
> > +/* Convert fs block number into bytes */
> > +static inline uint64_t
> > +xfrog_fsb_to_b(
> > +	const struct xfs_fd	*xfd,
> > +	uint64_t		fsb)
> > +{
> > +	return fsb << xfd->blocklog;
> > +}
> 
> FWIW, this is for converting linear offsets in fsb /units/, not the
> sparse fsbno (= agno | agbno) to bytes. I've always found it a bit
> nasty that this distinction is not clearly made in the core FSB
> conversion macros.
> 
> perhaps off_fsb_to_b?

Ok to both.

--D

> > +/* Convert bytes into (rounded down) fs block number */
> > +static inline uint64_t
> > +xfrog_b_to_fsbt(
> > +	const struct xfs_fd	*xfd,
> > +	uint64_t		bytes)
> > +{
> > +	return bytes >> xfd->blocklog;
> > +}
> 
> Ditto.
> 
> Otherwise looks ok.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
