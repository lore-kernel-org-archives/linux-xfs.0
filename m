Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29ADC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 23:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 659D820656
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 23:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bPbgMHRJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLCXkR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 18:40:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41324 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfLCXkQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 18:40:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3NTLSj160277;
        Tue, 3 Dec 2019 23:40:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8QLix/xkBNtOEZCyw+aFE8CNOgl3xF0b83ynOPQJQwI=;
 b=bPbgMHRJGAB0aY4RbhzLHvlTIcumz3YWNgviXqRKJPIt2aoXO0XbjVi58qImI4gNpd05
 5+Rc0ZJKPdOnB8vCEMTQ4lWocyF2YxAqK7cWETMbrOduYEWtknvarTY/QJZt6FReGCNP
 u5gx2UonxvO+KfyGZKKG84r27WKPGXI/6kvWjircFkpfAA3rSjWUNxvq0xT6YR1+4bPQ
 ovxrm0bNQbLlFHR+o3Uq9rJ3HjCa8X2Kh8NYHZGxUa+fcs9YDrQi9c0JlmtvJepSJbbH
 NFkFe573HSQR6hEG5StMJ6qPAQNk8vBXmxI4fTCh96Ybb6nCfZxlDo6bPmFbG7fspS+3 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcqb19v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 23:40:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3NStY1156250;
        Tue, 3 Dec 2019 23:40:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wp17c8r17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 23:40:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3Ne8SC014519;
        Tue, 3 Dec 2019 23:40:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 15:40:08 -0800
Date:   Tue, 3 Dec 2019 15:40:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 2/4] mkfs: check root inode location
Message-ID: <20191203234007.GL7335@magnolia>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
 <157530817131.126767.4542572453231190489.stgit@magnolia>
 <20191203130253.GA18418@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203130253.GA18418@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 08:02:53AM -0500, Brian Foster wrote:
> On Mon, Dec 02, 2019 at 09:36:11AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure the root inode gets created where repair thinks it should be
> > created.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/libxfs_api_defs.h |    1 +
> >  mkfs/xfs_mkfs.c          |   29 +++++++++++++++++++++++------
> >  2 files changed, 24 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> > index 645c9b1b..8f6b9fc2 100644
> > --- a/libxfs/libxfs_api_defs.h
> > +++ b/libxfs/libxfs_api_defs.h
> > @@ -156,5 +156,6 @@
> >  
> >  #define xfs_ag_init_headers		libxfs_ag_init_headers
> >  #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
> > +#define xfs_ialloc_find_prealloc	libxfs_ialloc_find_prealloc
> >  
> 
> Perhaps this should be in the previous patch..?

<shrug> I think the libxfs wrapper macro things shouldn't be introduced
until there's a caller outside of libxfs.

> 
> >  #endif /* __LIBXFS_API_DEFS_H__ */
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 18338a61..5143d9b4 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3521,6 +3521,28 @@ rewrite_secondary_superblocks(
> >  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
> >  }
> >  
> > +static void
> > +check_root_ino(
> > +	struct xfs_mount	*mp)
> > +{
> > +	xfs_agino_t		first, last;
> > +
> > +	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
> > +		fprintf(stderr,
> > +			_("%s: root inode created in AG %u, not AG 0\n"),
> > +			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> > +		exit(1);
> > +	}
> > +
> > +	libxfs_ialloc_find_prealloc(mp, &first, &last);
> > +	if (mp->m_sb.sb_rootino != XFS_AGINO_TO_INO(mp, 0, first)) {
> > +		fprintf(stderr,
> > +			_("%s: root inode (%llu) not created in first chunk\n"),
> > +			progname, (unsigned long long)mp->m_sb.sb_rootino);
> 
> If the root inode ended up somewhere in the middle of the first chunk,
> we'd fail (rightly), but with a misleading error message. Perhaps
> something like "root inode (..) not allocated in expected location"

Ok, fixed.

> would be better? I'd also like to see a comment somewhere in here to
> explain why we have this check. For example:
> 
> "The superblock refers directly to the root inode, but repair makes
> hardcoded assumptions about its location based on filesystem geometry
> for an extra level of verification. If this assumption ever breaks, we
> should flag it immediately and fail the mkfs. Otherwise repair may
> consider the filesystem corrupt and toss the root inode."

How about:

/*
 * The superblock points to the root directory inode, but xfs_repair
 * expects to find the root inode in a very specific location computed
 * from the filesystem geometry for an extra level of verification.
 *
 * Fail the format immediately if those assumptions ever break, because
 * repair will toss the root directory.
 */

> Feel free to reword that however appropriate (given the behavior change
> in subsequent patches), of course..

Ok.

--D

> Brian
> 
> > +		exit(1);
> > +	}
> > +}
> > +
> >  int
> >  main(
> >  	int			argc,
> > @@ -3807,12 +3829,7 @@ main(
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
> 
