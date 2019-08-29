Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B50C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 03:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9775C23403
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 03:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CP9LBitI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfH2Dv2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 23:51:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41728 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfH2Dv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 23:51:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T3ovVi156503;
        Thu, 29 Aug 2019 03:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qQD6r4NUqDV6pUgfMyaZA78hD69e0kwLe5cJjja2n+A=;
 b=CP9LBitIjrMmyY4IMYRF8E6DLe15t4VxZakwTPueLO1F5iajVknOaQQlc4Nsp2rHSrCs
 MI0mXKXUIYIzTuq1tGoUbq4SpfnZFxpH2JYFotzQlaRLg77PsinVXM4WYuGb3ELAZ9XT
 wqQiy0abm1ubSDBQimjoB3cChP1k98lLBaiEi9hIkJCIw0Gx/pldzJ+EacwJAxyPeyeH
 wq7L6XD+0gxq14zGm70qpU+yu9+5wP4qpGhNEqgtNgxkTrcVmoh0qx06sjk0NfWs2jQ3
 rV3uaO3uR35UfPpsl7+y1jjU1gGe7k1ebSW02dlmWuHpResk57py0zrR051yJpvuPuMo Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2up74tg057-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 03:51:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T3n0cR096118;
        Thu, 29 Aug 2019 03:51:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2unteuaaxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 03:50:13 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7T3mlnF024753;
        Thu, 29 Aug 2019 03:48:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 20:48:46 -0700
Date:   Wed, 28 Aug 2019 20:48:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_spaceman: convert open-coded unit conversions to
 helpers
Message-ID: <20190829034845.GN1037350@magnolia>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
 <156685444520.2839773.6764652190281485485.stgit@magnolia>
 <20190827081528.GH1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827081528.GH1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 06:15:28PM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2019 at 02:20:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create xfrog analogues of the libxfs byte/sector/block conversion
> > functions and convert spaceman to use them instead of open-coded
> > arithmatic we do now.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/xfrog.h   |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  libfrog/fsgeom.c  |    1 +
> >  spaceman/freesp.c |   18 ++++++--------
> >  spaceman/trim.c   |    9 ++++---
> >  4 files changed, 80 insertions(+), 14 deletions(-)
> 
> ....
> > +/* Convert fs block number to sector number. */
> > +static inline uint64_t
> > +xfrog_fsb_to_bb(
> > +	struct xfs_fd		*xfd,
> > +	uint64_t		fsbno)
> > +{
> > +	return fsbno << xfd->blkbb_log;
> > +}
> > +
> > +/* Convert sector number to fs block number, rounded down. */
> > +static inline uint64_t
> > +xfrog_bb_to_fsbt(
> > +	struct xfs_fd		*xfd,
> > +	uint64_t		daddr)
> > +{
> > +	return daddr >> xfd->blkbb_log;
> > +}
> 
> Same comment as previous ones about off_fsb_to_<foo> and vice versa.
> 
> And the more I see it, the less "xfrog" really means in these unit
> conversion functions. How about we prefix them "cvt_"?
> 
> Then the name of the function actually does exactly what is says.
> i.e. "convert basic blocks to offset in filesystem blocks"

Ok.  prefix conversion done.

> > @@ -174,8 +170,10 @@ scan_ag(
> >  	l = fsmap->fmh_keys;
> >  	h = fsmap->fmh_keys + 1;
> >  	if (agno != NULLAGNUMBER) {
> > -		l->fmr_physical = agno * bperag;
> > -		h->fmr_physical = ((agno + 1) * bperag) - 1;
> > +		l->fmr_physical = xfrog_bbtob(
> > +				xfrog_agb_to_daddr(xfd, agno, 0));
> > +		h->fmr_physical = xfrog_bbtob(
> > +				xfrog_agb_to_daddr(xfd, agno + 1, 0));
> >  		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
> >  	} else {
> >  		l->fmr_physical = 0;
> 
> This is why - that's quite hard to read. A simple wrapper might be
> better:
> 
> static inline uint64_t
> cvt_agbno_to_off_b(
> 	struct xfs_fd		*xfd,
> 	xfs_agnumber_t		agno,
> 	xfs_agblock_t		agbno)
> {
> 	return cvt_bbtob(cvt_agbno_to_daddr(xfd, agno, agbno));
> }
> 
> And then we have:
> 
> 		l->fmr_physical = cvt_agbno_to_off_b(xfd, agno, 0);
> 		h->fmr_physical = cvt_agbno_to_off_b(xfd, agno + 1, 0);
> 
> 
> > @@ -206,9 +204,9 @@ scan_ag(
> >  			if (!(extent->fmr_flags & FMR_OF_SPECIAL_OWNER) ||
> >  			    extent->fmr_owner != XFS_FMR_OWN_FREE)
> >  				continue;
> > -			agbno = (extent->fmr_physical - (bperag * agno)) /
> > -								blocksize;
> > -			aglen = extent->fmr_length / blocksize;
> > +			agbno = xfrog_daddr_to_agbno(xfd,
> > +					xfrog_btobbt(extent->fmr_physical));
> 
> That's the reverse - cvt_off_b_to_agbno().
> 
> > +			aglen = xfrog_b_to_fsbt(xfd, extent->fmr_length);
> >  			freeblks += aglen;
> >  			freeexts++;
> >  
> > diff --git a/spaceman/trim.c b/spaceman/trim.c
> > index ea1308f7..8741bab2 100644
> > --- a/spaceman/trim.c
> > +++ b/spaceman/trim.c
> > @@ -23,7 +23,8 @@ trim_f(
> >  	char			**argv)
> >  {
> >  	struct fstrim_range	trim = {0};
> > -	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
> > +	struct xfs_fd		*xfd = &file->xfd;
> > +	struct xfs_fsop_geom	*fsgeom = &xfd->fsgeom;
> >  	xfs_agnumber_t		agno = 0;
> >  	off64_t			offset = 0;
> >  	ssize_t			length = 0;
> > @@ -66,11 +67,11 @@ trim_f(
> >  		length = cvtnum(fsgeom->blocksize, fsgeom->sectsize,
> >  				argv[optind + 1]);
> >  	} else if (agno) {
> > -		offset = (off64_t)agno * fsgeom->agblocks * fsgeom->blocksize;
> > -		length = fsgeom->agblocks * fsgeom->blocksize;
> > +		offset = xfrog_bbtob(xfrog_agb_to_daddr(xfd, agno, 0));
> > +		length = xfrog_fsb_to_b(xfd, fsgeom->agblocks);
> 
> cvt_agbno_to_off_b() again...

Done.

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
