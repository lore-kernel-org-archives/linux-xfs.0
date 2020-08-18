Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB598C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7CD4207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PoO5rQ3Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgHRPoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:44:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgHRPos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:44:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFR8KM160070;
        Tue, 18 Aug 2020 15:44:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nKvKZpfb9r+wPiT+LaVho0xeNUtFIy4Qb/LzRQE+UcA=;
 b=PoO5rQ3QY/rrr8A10th4mVBtuCz4cR4OeXjizqLO0HqG3dq8a50qQmyVnoZWtr24Ydur
 neIyXJLierkbcH4CiXBTL2lTZ9KYHx5B/6dY6d1MymAp+hLJc4naY9OOSRewneCNtqLO
 BZ2QuKVTJgrVIKW1ud4qUT2eL+GDLjill92L308WnQH4k2SRmANf3d8L/cGzyEPM0b+z
 mQW7mtFMi9l06xnzzcgwD3nSnzHqajheMNqJxsM+y/Zm9AuQjRSfpWl3Nn1hfipgvAGT
 8QCCw/q0/umBwpmdM4VHRbR8K5afo72posqyOP/cmqdp8meV4OBdzs4pKb156magX52F Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bn5jsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:44:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFYueP129638;
        Tue, 18 Aug 2020 15:44:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32xsmxcw4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:44:44 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IFihe3031289;
        Tue, 18 Aug 2020 15:44:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:44:43 -0700
Date:   Tue, 18 Aug 2020 08:44:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200818154442.GU6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia>
 <CAOQ4uxj=K5TCTZoKxd9G4F0cTRYeE73-6iQgmp+3pR3QJKYdvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj=K5TCTZoKxd9G4F0cTRYeE73-6iQgmp+3pR3QJKYdvg@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 03:00:49PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > time epoch).  This enables us to handle dates up to 2486, which solves
> > the y2038 problem.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> ...
> 
> > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > index 9f036053fdb7..b354825f4e51 100644
> > --- a/fs/xfs/scrub/inode.c
> > +++ b/fs/xfs/scrub/inode.c
> > @@ -190,6 +190,11 @@ xchk_inode_flags2(
> >         if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
> >                 goto bad;
> >
> > +       /* the incore bigtime iflag always follows the feature flag */
> > +       if (!!xfs_sb_version_hasbigtime(&mp->m_sb) ^
> > +           !!(flags2 & XFS_DIFLAG2_BIGTIME))
> > +               goto bad;
> > +
> 
> Seems like flags2 are not the incore iflags and that the dinode iflags
> can very well
> have no bigtime on fs with bigtime support:
> 
> xchk_dinode(...
> ...
>                 flags2 = be64_to_cpu(dip->di_flags2);
> 
> What am I missing?

Nothing.  That chunk is just plain wrong and needs to reworked.  Repair
gets it right, the only failure case is if the inode flag is set but the
feature isn't.

I probably wrote this before I had the thought of letting people upgrade
existing filesystems.

Will fix, thanks for catching this.

--D

> 
> Thanks,
> Amir.
