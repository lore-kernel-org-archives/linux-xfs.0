Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF37C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75F320866
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BN+qYaWh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgCEBXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 20:23:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33292 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCEBXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 20:23:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0251N7cG068451;
        Thu, 5 Mar 2020 01:23:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bShf0khEhQQ/qZoor+4uuGDj3Y4o8mtrA4A8l0Vde8M=;
 b=BN+qYaWh69qVnA91Kj6Ynp3nmMx/IATM/azreJpJrgsA3ERIKISebC2ulpmK8EQjs4zR
 c+GhRFoBL2ot8IZasVrKSFI/6TisDppTzIlVY/CfvutFaYSvTzY9kq7QEBlGUIA4Y9sK
 f4BoQQOW0kiz4BkaPUcv5TfVultMn64BMR/bMTIIz6oM5iwusQvmW5tA038g2WipbcxL
 FYRpQyYu8628x734UcKEmFlh7WPBVzRY8AG4lmr+AvO41X4gm/umlOLjFCC4gVFFKMWC
 a4+rm3Ispwr9e619xQI/MeXEhjr8XaypzxzTXS0VwBtXBBGRHNnmn9ctvWFoeWbRBE1I lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yghn3duma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 01:23:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0251Ggnc144504;
        Thu, 5 Mar 2020 01:23:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yg1era0x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 01:23:19 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0251NIYV031825;
        Thu, 5 Mar 2020 01:23:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Mar 2020 17:23:18 -0800
Date:   Wed, 4 Mar 2020 17:23:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200305012317.GM8045@magnolia>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329250827.2423432.18007812133503266256.stgit@magnolia>
 <20200304182103.GB22037@bfoster>
 <20200304233459.GG1752567@magnolia>
 <20200304235335.GE10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304235335.GE10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 10:53:35AM +1100, Dave Chinner wrote:
> On Wed, Mar 04, 2020 at 03:34:59PM -0800, Darrick J. Wong wrote:
> > On Wed, Mar 04, 2020 at 01:21:03PM -0500, Brian Foster wrote:
> > > On Tue, Mar 03, 2020 at 07:28:28PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create an in-core fake root for AG-rooted btree types so that callers
> > > > can generate a whole new btree using the upcoming btree bulk load
> > > > function without making the new tree accessible from the rest of the
> > > > filesystem.  It is up to the individual btree type to provide a function
> > > > to create a staged cursor (presumably with the appropriate callouts to
> > > > update the fakeroot) and then commit the staged root back into the
> > > > filesystem.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > The code all seems reasonable, mostly infrastructure. Just a few high
> > > level comments..
> > > 
> > > It would be helpful if the commit log (or code comments) explained more
> > > about the callouts that are replaced for a staging tree (and why).
> > 
> > Ok.  I have two block comments to add.
> > 
> > > >  fs/xfs/libxfs/xfs_btree.c |  117 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_btree.h |   42 ++++++++++++++--
> > > >  fs/xfs/xfs_trace.h        |   28 +++++++++++
> > > >  3 files changed, 182 insertions(+), 5 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > > index e6f898bf3174..9a7c1a4d0423 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > > @@ -382,6 +382,8 @@ xfs_btree_del_cursor(
> > > >  	/*
> > > >  	 * Free the cursor.
> > > >  	 */
> > > > +	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
> > > > +		kmem_free((void *)cur->bc_ops);
> > > >  	kmem_cache_free(xfs_btree_cur_zone, cur);
> > > >  }
> > > >  
> > > > @@ -4908,3 +4910,118 @@ xfs_btree_has_more_records(
> > > >  	else
> > > >  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
> > > >  }
> > 
> > Add here a new comment:
> > 
> > /*
> >  * Staging Cursors and Fake Roots for Btrees
> >  * =========================================
> >  *
> >  * A staging btree cursor is a special type of btree cursor that callers
> >  * must use to construct a new btree index using the btree bulk loader
> >  * code.  The bulk loading code uses the staging btree cursor to
> >  * abstract the details of initializing new btree blocks and filling
> >  * them with records or key/ptr pairs.  Regular btree operations (e.g.
> >  * queries and modifications) are not supported with staging cursors,
> >  * and callers must not invoke them.
> >  *
> >  * Fake root structures contain all the information about a btree that
> >  * is under construction by the bulk loading code.  Staging btree
> >  * cursors point to fake root structures instead of the usual AG header
> >  * or inode structure.
> >  *
> >  * Callers are expected to initialize a fake root structure and pass it
> >  * into the _stage_cursor function for a specific btree type.  When bulk
> >  * loading is complete, callers should call the _commit_staged_btree
> >  * function for that specific btree type to commit the new btree into
> >  * the filesystem.
> >  */
> > 
> > 
> > > > +
> > > > +/* We don't allow staging cursors to be duplicated. */
> > 
> > /*
> >  * Don't allow staging cursors to be duplicated because they're supposed
> >  * to be kept private to a single thread.
> >  */
> 
> private to a single -thread- or a single -btree modification
> context-?

Private to a single btree rebuilding context, really. :)

ATM btree rebuilding contexts are single-threaded.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
