Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FCFC2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E424A214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mUGkxd5p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgA3UT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 15:19:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59148 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgA3UT0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 15:19:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UK8F0Z189846;
        Thu, 30 Jan 2020 20:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=S+9oHR6Ci5KDAkbTOzixhIiQQTF3hygwYemuIYs6wvI=;
 b=mUGkxd5pzD4K0AWZ+AXQtsWVTJDJDS1qxoAa/wfY5o+/qFryzV8H4ubfroYOIroxSmpI
 FDiZdcxzFt9JQM1qjzqerrA2u5AhkqoC/p3Emqd9zWL4TS1I8leZhAzUAlbpyn9Uu2sX
 fQl/ESAnN5jXS+VyZPVEHTxdJrsza8AVmI0bttNMxONlNiCj/dxPhkrcMQfyy2VI9xnQ
 gp3fYeZXCDgDQd8q3POWCs0ubzzJ56rrXNWII269HWEYMva6Fqpw5Gth/vWAulTkA2XR
 UmnG+dU0mJEw86zmrpLXYI7R5ok2/BzBzoUIILzfh7X0Dj+p9HWnEaqH0DZHkKQCTvmI Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xrdmqxkke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 20:19:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UK9IeL076024;
        Thu, 30 Jan 2020 20:19:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xu8e9du6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 20:19:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00UKJLf1026703;
        Thu, 30 Jan 2020 20:19:21 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 12:19:21 -0800
Date:   Thu, 30 Jan 2020 12:19:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 1/6] mkfs: check root inode location
Message-ID: <20200130201917.GD3447196@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
 <157982505230.2765631.2328249334657581135.stgit@magnolia>
 <226f970e-2368-9e68-cb1b-4de92414d043@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <226f970e-2368-9e68-cb1b-4de92414d043@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001300136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001300136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 01:32:30PM -0600, Eric Sandeen wrote:
> On 1/23/20 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure the root inode gets created where repair thinks it should be
> > created.
> 
> Actual mkfs-time location calculation is still completely separate from 
> the code in xfs_ialloc_calc_rootino though, right?  Maybe there's nothing
> to do about that.

Correct, because proto.c uses the regular inode allocation routines to
create the root inode, and mkfs doesn't have the ability to compute the
root inode and Make It So.

> I mostly find myself wondering what a user will do next if this check fails.

Complain. :)

To be fair, if there was a mismatch prior to this patch, the user would
end up with a filesystem that formats fine, mounts ok, and explodes in
xfs_repair.  Better we fail early than have repair shred the filesystem
after they've loaded up their production data and deleted the backups.

--D

> Assuming we trust xfs_ialloc_calc_rootino though, this seems fine.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/libxfs_api_defs.h |    1 +
> >  mkfs/xfs_mkfs.c          |   39 +++++++++++++++++++++++++++++++++------
> >  2 files changed, 34 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> > index cc7304ad..9ede0125 100644
> > --- a/libxfs/libxfs_api_defs.h
> > +++ b/libxfs/libxfs_api_defs.h
> > @@ -172,6 +172,7 @@
> >  
> >  #define xfs_ag_init_headers		libxfs_ag_init_headers
> >  #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
> > +#define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
> >  
> >  #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
> >  #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 784fe6a9..91a25bf5 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3549,6 +3549,38 @@ rewrite_secondary_superblocks(
> >  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
> >  }
> >  
> > +static void
> > +check_root_ino(
> > +	struct xfs_mount	*mp)
> > +{
> > +	xfs_ino_t		ino;
> > +
> > +	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
> > +		fprintf(stderr,
> > +			_("%s: root inode created in AG %u, not AG 0\n"),
> > +			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> > +		exit(1);
> > +	}
> > +
> > +	/*
> > +	 * The superblock points to the root directory inode, but xfs_repair
> > +	 * expects to find the root inode in a very specific location computed
> > +	 * from the filesystem geometry for an extra level of verification.
> > +	 *
> > +	 * Fail the format immediately if those assumptions ever break, because
> > +	 * repair will toss the root directory.
> > +	 */
> > +	ino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
> > +	if (mp->m_sb.sb_rootino != ino) {
> > +		fprintf(stderr,
> > +	_("%s: root inode (%llu) not allocated in expected location (%llu)\n"),
> > +			progname,
> > +			(unsigned long long)mp->m_sb.sb_rootino,
> > +			(unsigned long long)ino);
> > +		exit(1);
> > +	}
> > +}
> > +
> >  int
> >  main(
> >  	int			argc,
> > @@ -3835,12 +3867,7 @@ main(
> >  	/*
> >  	 * Protect ourselves against possible stupidity
> >  	 */
> > -	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
> > -		fprintf(stderr,
> > -			_("%s: root inode created in AG %u, not AG 0\n"),
> > -			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> > -		exit(1);
> > -	}
> > +	check_root_ino(mp);
> >  
> >  	/*
> >  	 * Re-write multiple secondary superblocks with rootinode field set
> > 
