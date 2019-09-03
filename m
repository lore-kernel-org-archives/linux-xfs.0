Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE69EC3A59E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 03:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90516217F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 03:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f8utMcTh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfICDQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 23:16:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33136 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfICDQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Sep 2019 23:16:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8339F5S107276;
        Tue, 3 Sep 2019 03:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FWmZjfcYxYfrU7tPXShPcaGJQBZyzniL9nqV+9+xuYg=;
 b=f8utMcThAx/8Sxe5r4wF4gtrJStDY8SuqIQfdHgIq7uyJp/ZYwKlbFzNHuyEotcTQJYr
 O0IQ/h79VgXh88ACJL9UYHO0HRIsp0WP48/b5eQ48967o/Ym8dcw9+SqL28v2cu9gzqO
 Xi/xlIUFMUGSqQK+sNR7+Ixr049+mP8K8falBbGrUCQ7dS3wwClMsqE4wsPiGIxa4NLN
 0Jmhb/26wyJRFyCUZaPR6VSZEWR3kbexeP5lrWwmS4+bXoiC22o8Zjn+LyPqiv+Ddcqx
 NcGSPKm7EgEhgRy14Cr9peKqZ1iIb9iiGitnsMZYaQV/GTiaV/rBECmV4N8BQQ+SSRjR jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2usfy501by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 03:16:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8338TAC049947;
        Tue, 3 Sep 2019 03:16:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2us5pgbut8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 03:16:02 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x833G1uV007205;
        Tue, 3 Sep 2019 03:16:01 GMT
Received: from localhost (/10.159.255.57)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Sep 2019 20:16:01 -0700
Date:   Mon, 2 Sep 2019 20:16:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     gg@magnolia, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] libxfs: move topology declarations into separate
 header
Message-ID: <20190903031601.GU5354@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633308405.1215978.11329921136072672886.stgit@magnolia>
 <20190830054304.GD1119@dread.disaster.area>
 <20190830203402.GF5354@magnolia>
 <20190902223345.GS1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902223345.GS1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=-1004
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030034
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 08:33:46AM +1000, Dave Chinner wrote:
> On Fri, Aug 30, 2019 at 01:34:02PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > The topology functions live in libfrog now, which means their
> > > > declarations don't belong in libxcmd.h.  Create new header file for
> > > > them.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  include/libxcmd.h  |   31 -------------------------------
> > > >  include/topology.h |   39 +++++++++++++++++++++++++++++++++++++++
> > > >  libfrog/topology.c |    1 +
> > > >  mkfs/xfs_mkfs.c    |    2 +-
> > > >  repair/sb.c        |    1 +
> > > >  5 files changed, 42 insertions(+), 32 deletions(-)
> > > >  create mode 100644 include/topology.h
> > > 
> > > I like the idea, but I'm wondering if we should have a similar
> > > setup to libxfs header files here.
> > > 
> > > i.e. the header file lives in libfrog/, and the install-headers make
> > > command creates include/libxfrog and links them for the build. That
> > > way the includes become namespaced like:
> > > 
> > > #include "libxfrog/topology,h"
> > > 
> > > and we don't pollute include with random header files from all
> > > different parts of xfsprogs...
> > 
> > What if I leave topology.h in libfrog/ and then create an
> > include/libfrog.h that pulls in all the libfrog header files like
> > libxfs.h does, and then put -I$(TOPDIR)/libfrog in GCFLAGS?
> 
> libxfs is a basket case - it's done that way so we don't need all
> the whacky games we play to shim the kernel functionality correctly
> in every xfsprogs file that needs libxfs functionality.
> 
> libxfrog is very different - we have progs that just need topology
> or number conversion, but not both. I'd prefer for libxfrog we only
> include the headers we require, that way avoiding defining things we
> don't actually need...

Ok, will rework this tomorrow.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
