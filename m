Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5C4C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89F02343B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jofVSPS9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH3Us6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 16:48:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbfH3Us6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 16:48:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKmMGr040259;
        Fri, 30 Aug 2019 20:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=geOxkpglc6xMtafmsQK3DC1UHjWPxf7FQL92nicwMJ8=;
 b=jofVSPS9o+3D+2Pjpr69YHdaeJJtVNvhEKJnVu9XX6ZNp8l2YcKImJJkOvdoSa1Eqjyg
 uc4ewMw/NQgNqMV25VEw3P3EHZ6tOmtT6HAuXq8ZGtz/8LDnufx1+x12Xe5KqnPyBRaJ
 EvN2ysEbm/trBJUNARXOySgFQhXDiL1bNIrKh0UkwhOeKh8FFOXVILYYCZdlmLW+qB8z
 OSm1ohXEudFwCmAo4HWcQDU6lqWXXcmBguessWCfixzsZqu8wPmVUxBuT5YjJwKZkRP6
 GXJARsXKxMcAW09AwDYlPvum3H0DrF7AWQrbbYgF++W9TgGbI+S0cVZP0GomO7i+DmbT YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uqb5fr04c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:48:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKmjF9128553;
        Fri, 30 Aug 2019 20:48:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2upc8xwrsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:48:53 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UKmoTB007596;
        Fri, 30 Aug 2019 20:48:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 13:48:50 -0700
Date:   Fri, 30 Aug 2019 13:48:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] man: document the new allocation group geometry
 ioctl
Message-ID: <20190830204849.GH5354@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633310832.1215978.10494838202211430225.stgit@magnolia>
 <20190830055347.GH1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830055347.GH1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 03:53:47PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 01:31:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Document the new ioctl to describe an allocation group's geometry.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_ag_geometry.2 |   74 ++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3                |    6 +++
> >  2 files changed, 80 insertions(+)
> >  create mode 100644 man/man2/ioctl_xfs_ag_geometry.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_ag_geometry.2 b/man/man2/ioctl_xfs_ag_geometry.2
> > new file mode 100644
> > index 00000000..5dfe0d08
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_ag_geometry.2
> > @@ -0,0 +1,74 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-AG-GEOMETRY 2 2019-04-11 "XFS"
> > +.SH NAME
> > +ioctl_xfs_ag_geometry \- query XFS allocation group geometry information
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <xfs/xfs_fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_AG_GEOMETRY, struct xfs_ag_geometry *" arg );
> > +.SH DESCRIPTION
> > +This XFS ioctl retrieves the geometry information for a given allocation group.
> > +The geometry information is conveyed in a structure of the following form:
> > +.PP
> > +.in +4n
> > +.nf
> > +struct xfs_ag_geometry {
> > +	uint32_t  ag_number;
> > +	uint32_t  ag_length;
> > +	uint32_t  ag_freeblks;
> > +	uint32_t  ag_icount;
> > +	uint32_t  ag_ifree;
> > +	uint32_t  ag_sick;
> > +	uint32_t  ag_checked;
> > +	uint32_t  ag_reserved32;
> > +	uint64_t  ag_reserved[12];
> 
> Where's the flags field for feature versioning? Please don't tell me
> we merged an ioctl structure without a flags or version field in
> it...

Yes, we did, though the "reserved fields are always zeroed" enables us
to retroactively define this to v0 of the structure.

> > +};
> > +.fi
> > +.in
> > +.TP
> > +.I ag_number
> > +The number of allocation group that the caller wishes to learn about.
> 
> "the index of"....
> 
> "The number of" is easily confused with a quantity....
> 
> Is this an input or an output?

Purely an input.

"The caller must set this field to the index of the allocation group
that the caller wishes to learn about." ?

> > +.TP
> > +.I ag_length
> > +Length of the allocation group, in units of filesystem blocks.
> 
> The length of the AG is returned in this field, in units....
> 
> Same for the rest...

Ok.

> > +.TP
> > +.I ag_freeblks
> > +Number of free blocks in the allocation group, in units of filesystem blocks.
> > +.TP
> > +.I ag_icount
> > +Number of inode records allocated in this allocation group.
> > +.TP
> > +.I ag_ifree
> > +Number of unused inode records (of the space allocated) in this allocation
> > +group.
> > +.TP
> > +.IR ag_reserved " and " ag_reserved32
> > +Will be set to zero.
> 
> It would be better to say "all reserved feilds will be set to zero
> on return" so that we don't have to change this every time we rev
> the structure....

Ok.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
