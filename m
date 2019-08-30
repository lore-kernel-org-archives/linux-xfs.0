Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E48C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA44823439
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WpT28J2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfH3UeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 16:34:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3UeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 16:34:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKYHTB016051;
        Fri, 30 Aug 2019 20:34:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tytjGDqnjQW33/nZubo71+nDc9KWekyzGghg4SbpgF0=;
 b=WpT28J2kj6DdasB94tdOdFsB+7kmPBSnpzZioJKq0s4J28frV8pnehPF58em4d7hndkP
 kXepvchoaskoKdPD95a89iCZrBSmq3rw/DG03dBSFJU4WkfuYYqhtjID1oekf6uAWeD4
 jxvSSCNgx/vrwzqA1/9neGNwj4rh1eDARsHNoxAnn1GuX9BiimsklGw7nbT4QMsQE3Pr
 FRoH4vZJMbGr9WWwYk41xVArcOeq/WF9O7R6qYS0ntS0NKMc2XvCKB7UlKsO5wfeH8St
 /u3EAJnT8eV9jnSSVVu6fZVecXZ4a2SxYCKBHq0aawB3nNLqihVfhT5cOzwTWzRO1F2l iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uqaxgr04a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:34:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKXQHZ068370;
        Fri, 30 Aug 2019 20:34:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2upxabsfuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:34:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UKYBCG003906;
        Fri, 30 Aug 2019 20:34:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 13:34:11 -0700
Date:   Fri, 30 Aug 2019 13:34:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, gg@magnolia
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] libxfs: move topology declarations into separate
 header
Message-ID: <20190830203402.GF5354@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633308405.1215978.11329921136072672886.stgit@magnolia>
 <20190830054304.GD1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830054304.GD1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=-1004
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300196
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The topology functions live in libfrog now, which means their
> > declarations don't belong in libxcmd.h.  Create new header file for
> > them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/libxcmd.h  |   31 -------------------------------
> >  include/topology.h |   39 +++++++++++++++++++++++++++++++++++++++
> >  libfrog/topology.c |    1 +
> >  mkfs/xfs_mkfs.c    |    2 +-
> >  repair/sb.c        |    1 +
> >  5 files changed, 42 insertions(+), 32 deletions(-)
> >  create mode 100644 include/topology.h
> 
> I like the idea, but I'm wondering if we should have a similar
> setup to libxfs header files here.
> 
> i.e. the header file lives in libfrog/, and the install-headers make
> command creates include/libxfrog and links them for the build. That
> way the includes become namespaced like:
> 
> #include "libxfrog/topology,h"
> 
> and we don't pollute include with random header files from all
> different parts of xfsprogs...

What if I leave topology.h in libfrog/ and then create an
include/libfrog.h that pulls in all the libfrog header files like
libxfs.h does, and then put -I$(TOPDIR)/libfrog in GCFLAGS?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
