Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC68BFC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83A8E21848
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XpWo4IOv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfKHVrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:47:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKHVrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 16:47:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8LhkQ2022549
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=oVLrYZqNww6l8JQwEVKiCz3ZIqyhJaxnkabbBIY6tg0=;
 b=XpWo4IOv5QDsNvDUu/D3p1gEQXarFsV8E5RB3vFkLjP61HVPJuXoGC4zpdWY6Ao6MnNk
 ono1i6ysQLBq+y53N8eCmXebxcqYZ3AdHAZse8Y1lR9uHlmmygY0N9r0gnATCq02wqbQ
 JJByW3eazg6osG8TPJM0j/CVOBxybWsGp8SzfAU2W14PeZQy8F7FzkZw+IZrDXS7/UT0
 /V4n4KLDc++MFpnaGfNF14TJ3/SsLUlaVx8Xd0a/DcTfEUwWg7FweArQZmePrxbkVH9s
 I8dUmdJ1Bu+Kuv99XMxT0ifFamgggqjgcw4AMG3QZeoxVM0ecVEeCdhynhb+dbIOkwbp Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w1fwh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:47:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8Lhju4076598
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:47:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w4k34g244-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:47:22 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8LlLNf030777
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:47:21 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 13:47:20 -0800
Date:   Fri, 8 Nov 2019 13:47:19 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 03/17] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20191108214719.GI6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-4-allison.henderson@oracle.com>
 <20191108012540.GL6219@magnolia>
 <3e1bb508-a78f-a3c0-2f17-d981b7b7705b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e1bb508-a78f-a3c0-2f17-d981b7b7705b@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 09:11:54AM -0700, Allison Collins wrote:
> On 11/7/19 6:25 PM, Darrick J. Wong wrote:
> > On Wed, Nov 06, 2019 at 06:27:47PM -0700, Allison Collins wrote:
> > > This patch embeds an xfs_name in xfs_da_args, replacing the name,
> > > namelen, and flags members.  This helps to clean up the xfs_da_args
> > > structure and make it more uniform with the new xfs_name parameter
> > > being passed around.
> > > 
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c        |  36 +++++++-------
> > >   fs/xfs/libxfs/xfs_attr_leaf.c   | 106 +++++++++++++++++++++-------------------
> > >   fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
> > >   fs/xfs/libxfs/xfs_da_btree.c    |   5 +-
> > >   fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
> > >   fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
> > >   fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
> > >   fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
> > >   fs/xfs/libxfs/xfs_dir2_node.c   |   8 +--
> > >   fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
> > >   fs/xfs/scrub/attr.c             |  12 ++---
> > >   fs/xfs/xfs_trace.h              |  20 ++++----
> > >   12 files changed, 128 insertions(+), 125 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 5a9624a..b77b985 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -72,13 +72,12 @@ xfs_attr_args_init(
> > >   	args->geo = dp->i_mount->m_attr_geo;
> > >   	args->whichfork = XFS_ATTR_FORK;
> > >   	args->dp = dp;
> > > -	args->flags = flags;
> > > -	args->name = name->name;
> > > -	args->namelen = name->len;
> > > -	if (args->namelen >= MAXNAMELEN)
> > > +	name->type = flags;
> > 
> > Is there a purpose for modifying the caller's @name, instead of setting
> > args.name.type = flags after the memcpy?
> Not really other than to just make them consistent so that the mem copy
> would cover all three members.  I think initially they were set
> individually, but people preferred the memcpy, and then later we decided to
> break the flags variable out of the name struct.  I can explicitly set
> args.name.type if folks prefer.
> 
> A subtle pitfall I noticed about using the name struct like this now:
> callers need to take care to abandon the original name struct or update the
> original pointer to this struct.  It's kind of easy to continue using the
> original struct like it's a convenience pointer, but it not the same memory
> so if args gets passed into some subroutine that modifies it, now you're out
> of sync.  If it doesnt get passed around or modified, it doesnt matter, but
> we've created a sort of usage rule about how to handle the name param which
> may not be entirely obvious to other developers.

Hm, maybe the da_args should keep a pointer to the caller's name, if
you're worried about coherency between different xfs_names?

Though, the only state that changes is the type field, right?  Maybe we
don't care and that should stay internal to the da_args anyway...

> > 
> > > +	memcpy(&args->name, name, sizeof(struct xfs_name));
> > > +	if (args->name.len >= MAXNAMELEN)
> > >   		return -EFAULT;		/* match IRIX behaviour */
> > > -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > > +	args->hashval = xfs_da_hashname(args->name.name, args->name.len);
> > >   	return 0;
> > >   }
> > > @@ -236,7 +235,7 @@ xfs_attr_try_sf_addname(
> > >   	 * Commit the shortform mods, and we're done.
> > >   	 * NOTE: this is also the error path (EEXIST, etc).
> > >   	 */
> > > -	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
> > > +	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
> > >   		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
> > >   	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > > @@ -357,6 +356,9 @@ xfs_attr_set(
> > >   	if (error)
> > >   		return error;
> > > +	/* Use name now stored in args */
> > > +	name = &args.name;
> > 
> > You could probably set this as part of the variable declaration, e.g.
> > 
> > struct xfs_name		*name = &args.name;
> No, because name is a parameter here, so you would loose the contents at the
> start of the function if we did this.  And then args init would memcopy and
> empty struct onto itself.  And then confusion would ensue.... :-(
> 
> > 
> > > +
> > >   	args.value = value;
> > >   	args.valuelen = valuelen;
> > >   	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> > > @@ -372,7 +374,7 @@ xfs_attr_set(
> > >   	 */
> > >   	if (XFS_IFORK_Q(dp) == 0) {
> > >   		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> > > -			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
> > > +			XFS_ATTR_SF_ENTSIZE_BYNAME(args.name.len, valuelen);
> > 
> > If you're going to keep the convenience variable @name, then please use
> > it throughout the function.
> I think this is the only place it's used for this function at this time.  I
> use it later in patch 15 though.  I think I stumbled across the name sync
> bug then, and corrected it with the parameter pointer assignment above just
> because it seemed like the right place to fix it.
> 
> Do you want the function to uniformly use an explicit reference, or the
> param?  Seems like a bit of a wart unfortunately :-(

One or the other, just not both mixed in the same function.

--D

> > 
> > >   		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> > >   		if (error)
> > 
> > <snip>
> > 
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > > index 4fd1223..129ec09 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > > @@ -2040,8 +2040,9 @@ xfs_da_compname(
> > >   	const unsigned char *name,
> > >   	int		len)
> > >   {
> > > -	return (args->namelen == len && memcmp(args->name, name, len) == 0) ?
> > > -					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
> > 
> > Wow that's gross. :)
> > 
> > 	if (args->name.len == len && !memcmp(args->name.name, name, len))
> > 		return XFS_CMP_EXACT;
> > 
> > 	return XFS_CMP_DIFFERENT;
> > 
> > Hmm, is that better?
> Sure, will fix.
> 
> Allison
> 
> > 
> > The rest looks reasonable...
> > 
> > --D
> > 
