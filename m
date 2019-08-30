Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65531C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 344AB21874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YoRRnwOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfH3UlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 16:41:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42900 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfH3UlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 16:41:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKcw4N034626;
        Fri, 30 Aug 2019 20:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=n6J/cZqBzkGJkkXQwdFxnP3mXjV0oP+SCAE1YfFv6bo=;
 b=YoRRnwOWWryVyblJGZP5cTjqU2hGvsi8nWnCTIkQKN2USBKJ/tdoik0CC5BGaVz42XCt
 eNagPlJor6k/wz2cfq4qiKPDU2Vi6IT9P5JGuxPxbeU/e6kbEel0W938DcFoGm9aKh9t
 sGi4lWpL+oD5N0QcPmAyyvwIFimS0iEMUPIUaAk+II76cEsoNCjPyehPCaTIyeLERVaJ
 fdORCAqOopKHW3JyELNzppDCl6OGnMMLQDXSvkNt8z126sny8F0yP0ENrcDywbwwrH7u
 lacgkozZl9wI08oTDTQWe9g8xaOSLYHM5fI3zD+etye+IKfQb0fOYtqtqplNl8MR1ZL2 ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uqay500y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:40:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKcE6Y077800;
        Fri, 30 Aug 2019 20:40:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2upxabsndj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:40:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UKerFK027466;
        Fri, 30 Aug 2019 20:40:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 13:40:53 -0700
Date:   Fri, 30 Aug 2019 13:40:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] man: document the new v5 fs geometry ioctl
 structures
Message-ID: <20190830204052.GG5354@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633309613.1215978.13281783388020912868.stgit@magnolia>
 <20190830054459.GF1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830054459.GF1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300197
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 03:44:59PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 01:31:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Amend the fs geometry ioctl documentation to cover the new v5 structure.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libfrog/fsgeom.c                   |    4 ++++
> >  man/man2/ioctl_xfs_fsop_geometry.2 |    8 ++++++++
> >  2 files changed, 12 insertions(+)
> > 
> > 
> > diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> > index 06e4e663..159738c5 100644
> > --- a/libfrog/fsgeom.c
> > +++ b/libfrog/fsgeom.c
> > @@ -88,6 +88,10 @@ xfrog_geometry(
> >  	if (!ret)
> >  		return 0;
> >  
> > +	ret = ioctl(fd, XFS_IOC_FSGEOMETRY_V4, fsgeo);
> > +	if (!ret)
> > +		return 0;
> > +
> >  	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
> >  }
> 
> This hunk is in the previous patch.

Dunno where that came from, and it's not reflected in my git repo at
this point ... ?   Weird.

> >  
> > diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_fsop_geometry.2
> > index 68e3387d..365bda8b 100644
> > --- a/man/man2/ioctl_xfs_fsop_geometry.2
> > +++ b/man/man2/ioctl_xfs_fsop_geometry.2
> > @@ -12,6 +12,8 @@ ioctl_xfs_fsop_geometry \- report XFS filesystem layout and features
> >  .PP
> >  .BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY, struct xfs_fsop_geom*" arg );
> >  .br
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V4, struct xfs_fsop_geom_v4 *" arg );
> > +.br
> >  .BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V1, struct xfs_fsop_geom_v1 *" arg );
> >  .SH DESCRIPTION
> >  Report the details of an XFS filesystem layout, features, and other descriptive items.
> > @@ -43,6 +45,9 @@ struct xfs_fsop_geom {
> >  	/* struct xfs_fsop_geom_v1 stops here. */
> >  
> >  	__u32         logsunit;
> > +	/* struct xfs_fsop_geom_v4 stops here. */
> > +
> > +	__u64         reserved[18];
> >  };
> >  .fi
> >  .in
> 
> And this looks like a stray, too.

That's not a stray, that's part of the manpage update to reflect the
extra space at the end of the structure.

--D

> The man page changes look fine, though :P
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
