Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819B7C35DF2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 04:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45AEB24673
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 04:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sgiC50Bf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgBYE1M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 23:27:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55344 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgBYE1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 23:27:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P4NIcJ190319;
        Tue, 25 Feb 2020 04:27:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uUZuUDd7A9zV59uBvE8zy2TbLfLX1VyWNz9rVlKEV14=;
 b=sgiC50BfsslKlir83YEnFHUzUO/RUdL9mDgHTbxK4g6jP3nDLQbAF6tgKvryMhfjvidg
 Tk8ab4VMOrWJZbh3C0ijYsdl6XCkTw+/H3obXerUbFhnXSqqOwZBlffH28Qr8eND3sog
 QV6jgTsvuLAHn9lOet3IEgzTkvh4KlJa43v1EIIMNu8opAdplsFx7/ziIfxPTSDcJyWa
 9S57Zva2NI6XabWTRv0SdJYD3RMzF75dr5cayiyW7Vr8WT6JngMZY7FEwrQXUV6xhgzE
 Mm8JZ7bp9KrHuSWbNukrzFGOF9hzG/ARAkTMTKDocDgSe/yKyL9kaKIggvpjbBs4m36S eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ycppr97dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 04:27:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P4M4vZ107024;
        Tue, 25 Feb 2020 04:27:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe12u960-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 04:27:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P4R9ap018640;
        Tue, 25 Feb 2020 04:27:09 GMT
Received: from localhost (/10.159.137.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 20:27:08 -0800
Date:   Mon, 24 Feb 2020 20:27:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20200225042707.GF6740@magnolia>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
 <20200225005718.GC10776@dread.disaster.area>
 <5de019d4-d19f-315d-0299-3926c49cf150@oracle.com>
 <20200225040652.GD10776@dread.disaster.area>
 <d3fdea13-ff1d-ed69-8005-60193c2d2e53@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3fdea13-ff1d-ed69-8005-60193c2d2e53@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250034
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:19:58PM -0700, Allison Collins wrote:
> 
> 
> On 2/24/20 9:06 PM, Dave Chinner wrote:
> > On Mon, Feb 24, 2020 at 07:00:35PM -0700, Allison Collins wrote:
> > > 
> > > 
> > > On 2/24/20 5:57 PM, Dave Chinner wrote:
> > > > On Sat, Feb 22, 2020 at 07:05:54PM -0700, Allison Collins wrote:
> > > > > This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
> > > > > members.  This helps to clean up the xfs_da_args structure and make it more uniform
> > > > > with the new xfs_name parameter being passed around.
> > > > 
> > > > Commit message should wrap at 68-72 columns.
> > > > 
> > > > > 
> > > > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > >    fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
> > > > >    fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
> > > > >    fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
> > > > >    fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
> > > > >    fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
> > > > >    fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
> > > > >    fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
> > > > >    fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
> > > > >    fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
> > > > >    fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
> > > > >    fs/xfs/scrub/attr.c             |  12 ++---
> > > > >    fs/xfs/xfs_trace.h              |  20 ++++----
> > > > >    12 files changed, 130 insertions(+), 123 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > > index 6717f47..9acdb23 100644
> > > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > > @@ -72,13 +72,12 @@ xfs_attr_args_init(
> > > > >    	args->geo = dp->i_mount->m_attr_geo;
> > > > >    	args->whichfork = XFS_ATTR_FORK;
> > > > >    	args->dp = dp;
> > > > > -	args->flags = flags;
> > > > > -	args->name = name->name;
> > > > > -	args->namelen = name->len;
> > > > > -	if (args->namelen >= MAXNAMELEN)
> > > > > +	memcpy(&args->name, name, sizeof(struct xfs_name));
> > > > > +	args->name.type = flags;
> > > > 
> > > > This doesn't play well with Christoph's cleanup series which fixes
> > > > up all the confusion with internal versus API flags. I guess the
> > > > namespace is part of the attribute name, but I think this would be a
> > > > much clearer conversion when placed on top of the way Christoph
> > > > cleaned all this up...
> > > > 
> > > > Have you looked at rebasing this on top of that cleanup series?
> > > > 
> > > > Cheers,
> > > > 
> > > Yes, there is some conflict between the sets here and there, but I think
> > > folks wanted to keep them separate for now.
> > 
> > That makes it really hard to form a clear view of what the code
> > looks like after both patchsets have been applied. :(
> > 
> > > Are you referring to
> > > "[780d29057781] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag"?  I'm
> > > pretty sure this set is already seated on top of that one.  This one is
> > > based on the latest for-next.
> > 
> > No, I'm talking about the series that ends up undoing that commit
> > (i.e. the DA_OP_INCOMPLETE flag goes away again) and turns
> > args->flags into args->attr_filter as the namespace filter for
> > lookups. THis also turn adds XFS_ATTR_INCOMPLETE into a lookup
> > filter.
> > 
> > With this separation of ops vs lookup filters, moving the lookup
> > filter into the xfs_name makes a bit more sense (i.e. the namespace
> > filter is passed with the attribute name), but as a standalone
> > movement it creates a bit of an impedence mismatch between the xname
> > and the use of these flags.
> > 
> > I think the end result will be fine, but it's making it hard for me
> > to reconcile the changes in the two patchsets...
> > 
> > Cheers,
> 
> I'd be happy to go through the sets and find the intersections. Or make a
> big super set if you like.  I got the impression though that Christoph didnt
> particularly like the delayed attr series or the idea of blending them.  But
> I do think it would be a good idea to take into consideration what the
> combination of them is going to look like.

At this point you might as well wait for me to actually put hch's attr
interface refactoring series into for-next (unless this series is
already based off of that??) though Christoph might be a bit time
constrained this week...

--D

> Allison
> 
> > 
> > Dave.
> > 
> 
> 
