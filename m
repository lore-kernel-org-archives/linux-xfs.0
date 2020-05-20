Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FABDC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3EC2072C
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 18:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FCBEeD1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgETSff (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 14:35:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33620 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETSff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 14:35:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIXGqK005949;
        Wed, 20 May 2020 18:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GgjVx4bgNsl6NMLy2dVq28kR3mg28GSjrD3VTPmhqAM=;
 b=FCBEeD1wD99hlFvTaVctv8B+fujxZDIJI23kJltJmOUbPNlWZfR0D4Vgt80tyksZpknK
 ii9SRzmdVtiVX52RmC4LrGVjT4WDCd17jzGBT2N+r7UYGz1h5s7LYThkma0NZvGZ65Iu
 A/lVoPziOErk4JrOH8nK8bForRFgTI4XuJJATr0fMcT0Sl3HdF6bXU9SDxlERQFazbEx
 T4iRuK+0TLgxpbY2IP88jgA/NTfTl764pS5AfXCBqFPZFNCTbLjeTZRcIYZNbkykaq5C
 p3JMtyfQL7Wg3uJ5RMg8huxWbK/d72MErtCMqFnhT3+g8ZA+vVLJITC3Kr4ccDDuFqcf lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krcsp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 18:35:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KIWVHe181006;
        Wed, 20 May 2020 18:35:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 314gm7j5n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 18:35:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04KIZSSo012800;
        Wed, 20 May 2020 18:35:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 11:35:28 -0700
Date:   Wed, 20 May 2020 11:35:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: refactor eofb matching into a single helper
Message-ID: <20200520183527.GW17627@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
 <158993916213.976105.11958914131452778480.stgit@magnolia>
 <20200520064210.GG2742@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520064210.GG2742@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 08:42:11AM +0200, Christoph Hellwig wrote:
> On Tue, May 19, 2020 at 06:46:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the two eofb-matching logics into a single helper so that we
> > don't repeat ourselves.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_icache.c |   59 +++++++++++++++++++++++++++------------------------
> >  1 file changed, 31 insertions(+), 28 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index ac66e7d8698d..1f12c6a0c48e 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1436,6 +1436,33 @@ xfs_inode_match_id_union(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Is this inode @ip eligible for eof/cow block reclamation, given some
> > + * filtering parameters @eofb?  The inode is eligible if @eofb is null or
> > + * if the predicate functions match.
> > + */
> > +static bool
> > +xfs_inode_matches_eofb(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_eofblocks	*eofb)
> > +{
> > +	int			match;
> > +
> > +	if (!eofb)
> > +		return true;
> > +
> > +	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> > +		match = xfs_inode_match_id_union(ip, eofb);
> > +	else
> > +		match = xfs_inode_match_id(ip, eofb);
> > +	if (match)
> > +		return true;
> > +
> > +	/* skip the inode if the file size is too small */
> > +	return !(eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> > +		 XFS_ISIZE(ip) < eofb->eof_min_file_size);
> 
> This looks wrong - the size check should be applied if we did already
> find a match and not override it based on the current code, e.g.:
> 
> 	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> 		match = xfs_inode_match_id_union(ip, eofb);
> 	else
> 		match = xfs_inode_match_id(ip, eofb);
> 
> 	if (match) {
> 		/* skip the inode if the file size is too small */
> 		if ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
> 		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> 			return false;
> 	}
> 
> 	return match;

Ah, I see what I did wrong here; the size check was another opportunity
for us to say no even if the inode matched.  Ok, I'll go fix it.

--D
