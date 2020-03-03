Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E87C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 22:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A67FB206E6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 22:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QnEagSbK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgCCW5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 17:57:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgCCW5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 17:57:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023MsFqJ152687;
        Tue, 3 Mar 2020 22:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FgTdjAWTAzOqN3ndx4r5zGCcyVTldWA495cDuT/y3mU=;
 b=QnEagSbKfWl71fVylvXn3k6SFdylSx5oQVwaW0qyKJ+iXCehSOU3Ti+p2gB4rMWC9m2m
 7WPz7y3WGGKlCrCqUAgEKG/l34Evgnil+P0UXdpKSwYvnFtWlxRinohlP07MK5vzStjQ
 E6d9CbiH399d1LI5z5PanmM36D2C4RFyXRNOPWUHeD9X8oTjHkmlnQ6djGffGvgVDgYo
 iIG79LHz8nO+xA5PZyGciRyw0lk3W+kP7TMIE2d1NtVUQVi15Bewgu7BBK6E+KQ+8giy
 2IXSxOg/wY5kQ7EicKJVFUXN8G/nIYeR2k6SOHj4nMEAslUpTfCofwqvQtJHB42U3MrW Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yffcujjnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 22:57:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023Mr45C192512;
        Tue, 3 Mar 2020 22:57:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yg1gyf6vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 22:57:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 023MvDpF017240;
        Tue, 3 Mar 2020 22:57:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 14:57:13 -0800
Date:   Tue, 3 Mar 2020 14:57:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: mark dir corrupt when lookup-by-hash fails
Message-ID: <20200303225712.GG8045@magnolia>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294094977.1730101.1658645036964056566.stgit@magnolia>
 <20200303222610.GV10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303222610.GV10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=8 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=8 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 09:26:10AM +1100, Dave Chinner wrote:
> On Fri, Feb 28, 2020 at 05:49:09PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xchk_dir_actor, we attempt to validate the directory hash structures
> > by performing a directory entry lookup by (hashed) name.  If the lookup
> > returns ENOENT, that means that the hash information is corrupt.  The
> > _process_error functions don't catch this, so we have to add that
> > explicitly.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/dir.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> > index 266da4e4bde6..54afa75c95d1 100644
> > --- a/fs/xfs/scrub/dir.c
> > +++ b/fs/xfs/scrub/dir.c
> > @@ -155,6 +155,11 @@ xchk_dir_actor(
> >  	xname.type = XFS_DIR3_FT_UNKNOWN;
> >  
> >  	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
> > +	if (error == -ENOENT) {
> > +		/* ENOENT means the hash lookup failed and the dir is corrupt */
> > +		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> > +		return -EFSCORRUPTED;
> > +	}
> >  	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
> >  			&error))
> >  		goto out;
> 
> So why is this error handling open coded rather than doing something
> like this to use the generic, pre-existing corruption handling:
> 
> 	if (error == -ENOENT) {
> 		/* ENOENT means the hash lookup failed and the dir is corrupt */
> 		error = -EFSCORRUPTED;
> 	}
> 	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
> 			&error))
> 		goto out;

No particular reason, I just figured that I might as well cut to setting
OFLAG_CORRUPT and bailing out.  I'll change it.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.co
