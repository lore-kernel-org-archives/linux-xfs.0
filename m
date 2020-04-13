Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61EA3C2BA2B
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 19:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A8BF206E9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 19:37:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xpMLg0i0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387956AbgDMThS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 15:37:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387935AbgDMThQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Apr 2020 15:37:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DJWw1n013646;
        Mon, 13 Apr 2020 19:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QCYOSOnNKqesVbQFovgtZsEEP7MYZGP/5kZBtLje1UA=;
 b=xpMLg0i0MPbw9ZN31FzwxLc/rZK3/sO2jL+50iabouO9gjGt9roDCoP6jl3/zXVxMUEL
 Fv1GEyi7aEPFn2tGuTMJwn+c7avTka2vnFSPzZmhwzPxe8gthCwIKUPIuA+NPBDYqUXC
 PSVb7w1eh0hL67TEV2W584g/o1+puzY4RbUG9DpC60bxncuAaYl/QOA12iBj6cAYjzev
 eOaR+HE4FaqgcsqgmhqDCPRFsWJlXlE+QKsGB4GQefHGqM367lmLoSyERwiGRJmLBtZL
 fnSHi2Wnf02FKrD/IhlzGsYpQA2ci4f4XbjsvZ0cr2lUOELLAlt3bD1idWaaWdOlaCho Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30b5ar0h0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 19:37:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DJVsea156746;
        Mon, 13 Apr 2020 19:37:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30bqpd3cs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 19:37:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DJbBoh006291;
        Mon, 13 Apr 2020 19:37:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 12:37:10 -0700
Date:   Mon, 13 Apr 2020 12:37:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsdocs: capture some information about dirs vs. attrs
 and how they use dabtrees
Message-ID: <20200413193709.GH6749@magnolia>
References: <20200408232753.GC6741@magnolia>
 <20200409001608.GR24067@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409001608.GR24067@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 09, 2020 at 10:16:08AM +1000, Dave Chinner wrote:
> On Wed, Apr 08, 2020 at 04:27:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Dave and I had a short discussion about whether or not xattr trees
> > needed to have the same free space tracking that directories have, and
> > a comparison of how each of the two metadata types interact with
> > dabtrees resulted.  I've reworked this a bit to make it flow better as a
> > book chapter, so here we go.
> > 
> > Original-mail: https://lore.kernel.org/linux-xfs/20200404085203.1908-1-chandanrlinux@gmail.com/T/#mdd12ad06cf5d635772cc38946fc5b22e349e136f
> > Originally-from: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Couple of things.
> 
> We are talking about btrees and where the record data is being
> stored (internal or external). Hence I think it makes sense to refer
> to "attribute records" and "directory records" (or "dirent records")
> rather than "attributes" and "directory entries"...

Ok, I'll clean that up 

> "leaves" -> "leaf nodes"

Fixed.

> > ---
> >  .../extended_attributes.asciidoc                   |   49 ++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> > 
> > diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> > index 99f7b35..d61c649 100644
> > --- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> > +++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> > @@ -910,3 +910,52 @@ Log sequence number of the last write to this block.
> >  
> >  Filesystems formatted prior to v5 do not have this header in the remote block.
> >  Value data begins immediately at offset zero.
> > +
> > +== Key Differences Between Directories and Extended Attributes
> > +
> > +Though directories and extended attributes can take advantage of the same
> > +variable length record btree structures (i.e. the dabtree) to map name hashes
> > +to disk blocks, there are major differences in the ways that each of those
> > +users embed the btree within the information that they are storing.
> > +
> > +Directory blocks require external free space tracking because the directory
> > +blocks are not part of the dabtree itself.  The dabtree leaves for a directory
> > +map name hashes to external directory data blocks.  Extended attributes, on
> 
> "The dabtree leaves for ...." implies it is going somewhere, not
> that you are talking about leaf nodes. :) Perhaps:
> 
> "The directory dabtree leaf nodes contain a mapping between name
> hash and the location of the dirent record in the external directory
> data blocks."

<nod>

> > +the other hand, store all of the attributes in the leaves of the dabtree.
> 
> "... store the attribute records directly in the dabtree leaf
> nodes."

<nod>

> > +
> > +When we add or remove an extended attribute in the dabtree, we split or merge
> > +leaves of the tree based on where the name hash index tells us a leaf needs to
> > +be inserted into or removed.  In other words, we make space available or
> > +collapse sparse leaves of the dabtree as a side effect of inserting or
> > +removing attributes.
> > +
> > +The directory structure is very different.  Directory entries cannot change
> > +location because each entry's logical offset into the directory data segment
> > +is used as the readdir/seekdir/telldir cookie, and the cookie is required to
> > +be stable for the life of the entry.  Therefore, we cannot store directory
> > +entries in the leaves of a dabtree (which is indexed in hash order) because
> 
> The userspace readdir/seekdir/telldir directory cookie API places a
> requirement on the directory structure that dirent record cookie
> cannot change for the life of the dirent record. We use the dirent
> record's logical offset into the directory data segment for that
> cookie, and hence the dirent record cannot change location.
> Therefore, we cannot store directory records in the leaf nodes of
> the dabtree....

Ok, I'll massage that in. :)

> > +the offset into the tree would change as other entries are inserted and
> > +removed.  Hence when we remove directory entries, we must leave holes in the
> > +data segment so the rest of the entries do not move.
> > +
> > +The directory name hash index (the dabtree bit) is held in the second
> > +directory segment.  Because the dabtree only stores pointers to directory
> > +entries in the (first) data segment, there is no need to leave holes in the
> > +dabtree itself.  The dabtree merges or splits leaves as required as pointers
> > +to the directory data segment are added or removed.  The dabtree itself needs
> > +no free space tracking.
> > +
> > +When we go to add a directory entry, we need to find the best-fitting free
> 
> s/go to//

Fixed.

> > +space in the directory data segment to turn into the new entry.  This requires
> > +a free space index for the directory data segment.  The free space index is
> > +held in the third directory segment.  Once we've used the free space index to
> > +find the block with that best free space, we modify the directory data block
> > +and update the dabtree to point the name hash at the new entry.
> > +
> > +In other words, the requirement for a free space map in the directory
> > +structure results from storing the directory entry data externally to the
> > +dabtree.  Extended atttributes are stored directly in the leaves of the
> 
> dabtree leaf nodes

Fixed.

> > +dabtree (except for remote attributes which can be anywhere in the attr fork
> > +address space) and do not need external free space tracking to determine where
> > +to best insert them.  As a result, extended attributes exhibit nearly perfect
> > +scaling until we run out of memory.
> 
> Thanks for doing this, Darrick!

NP.  v2 is on its way.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
