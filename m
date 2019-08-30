Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFEEC3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B57D21721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DNeFbhFa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfH3Fkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:40:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfH3Fkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:40:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U5dEe5170203;
        Fri, 30 Aug 2019 05:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Gm3/Ji8gfWPOFwrmfRYpW7QaqIujUEGHecpJDSu2hVU=;
 b=DNeFbhFaHIy6Ui4Y5D8q65rh1OjaaxH7RuhFPNuk7MTibUavw9OlLZ5/5kt5DpZfsxnX
 A4PrNtV2kJSmoyY1nPlNUVcVAAp7CgqlgHv1Nd5mELxVjyK20P8ehOPsYvNw1DGlUOuQ
 QaVanbJPaibymiVcm86sMQr3nW115TQ3h083oDEN+YJ0ntYLz4YyiJ+p1cOJyBsSupPy
 Gcs7ZiiCzRyhX/2H2W0vdTeL2ll+ZC2LT90hwePHFvJqbxBQZ/im7ioR+hHK91XJecsY
 CswR6XT4VJTdnG4B7BvnIeOwbJr/hJt1Mvziuaj8cnzA+A20HbaE3VB2vnMnaSF6Md6u 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2upwuf8080-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 05:40:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U5c9ud141792;
        Fri, 30 Aug 2019 05:40:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2unvu11rct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 05:40:28 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7U5eQLo012089;
        Fri, 30 Aug 2019 05:40:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 22:40:26 -0700
Date:   Thu, 29 Aug 2019 22:40:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] libxfs-diff: try harder to find the kernel
 equivalent libxfs files
Message-ID: <20190830054025.GY5354@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633307795.1215978.8644291951311062567.stgit@magnolia>
 <20190830053812.GC1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830053812.GC1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300059
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 03:38:12PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 01:31:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we're syncing userspace libxfs/ files with kernel fs/xfs/
> > files, teach the diff tool to try fs/xfs/xfs_foo.c if
> > fs/xfs/libxfs/xfs_foo.c doesn't exist.
> 
> I'd prefer we have a strategy that moves fs/xfs files to
> fs/xfs/libxfs once they are synced instead of breaking the "files
> in libxfs/ are the same in both user and kernel space" rule we set
> for libxfs...

Ok, I will kill this patch.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
