Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51032C47257
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 16:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0DE206B9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 16:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D44mZke6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgEEQUs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 12:20:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730215AbgEEQUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 12:20:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045GHnfn062501;
        Tue, 5 May 2020 16:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aZW1v/5SiddG1mgdD3m05lX5uP/Pb0yFcHaf0AcWMMg=;
 b=D44mZke6WQGGuXEWgo3xdXK4Am6UujxChH29oqG1QdxTSYe67tLb9YEcUupgYtziQR+s
 OLqXwIqf6Z6vsmb/nSMwZRwjsU2MREzOXQQvZ0NBBhx0WjgjJi/5Jc+Z7fvrkNT6Grkt
 AeEcGhDbMCoWF4QVbHdn+Z4hrKqtC9u7rVJaauGxMAcqPYYblmp4O87JlE5C5ra+hmlZ
 vB5hIfN+7mhNK8mO2Vx5HA4ZUW+BRzYIOMN95S2gHqTPyk6NG+nhD131dkp63rQ1dqrQ
 Swc8/5G80ECL40s+TxpURMCCYWx9w/HZoVcsboGWJzUq2xfE6je1DTmJ8FPLtwbmCiHI pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r5t00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 16:20:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045GHj4v138673;
        Tue, 5 May 2020 16:20:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r5exq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 16:20:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045GKesl013787;
        Tue, 5 May 2020 16:20:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 09:20:40 -0700
Date:   Tue, 5 May 2020 09:20:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsdocs: capture some information about dirs vs.
 attrs and how they use dabtrees
Message-ID: <20200505162039.GR5703@magnolia>
References: <20200413194600.GC6742@magnolia>
 <20200505135551.GA61176@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505135551.GA61176@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 05, 2020 at 09:55:51AM -0400, Brian Foster wrote:
> On Mon, Apr 13, 2020 at 12:46:00PM -0700, Darrick J. Wong wrote:
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
> > ---
> > v2: various fixes suggested by Dave; reflow the paragraphs about
> > directories to describe the relations between dabtree and dirents only once;
> > don't talk about an unnamed "we".
> > ---
> >  .../extended_attributes.asciidoc                   |   55 ++++++++++++++++++++
> >  1 file changed, 55 insertions(+)
> > 
> > diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> > index 99f7b35..b7a6007 100644
> > --- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> > +++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> > @@ -910,3 +910,58 @@ Log sequence number of the last write to this block.
> >  
> >  Filesystems formatted prior to v5 do not have this header in the remote block.
> >  Value data begins immediately at offset zero.
> > +
> > +== Key Differences Between Directories and Extended Attributes
> > +
> > +Though directories and extended attributes can take advantage of the same
> > +variable length record btree structures (i.e. the dabtree) to map name hashes
> > +to directory entry records (dirent records) or extended attribute records,
> > +there are major differences in the ways that each of those users embed the
> > +btree within the information that they are storing.  The directory dabtree leaf
> > +nodes contain mappings between a name hash and the location of a dirent record
> > +inside the directory entry segment.  Extended attributes, on the other hand,
> > +store attribute records directly in the leaf nodes of the dabtree.

Hmm, both you and Bill are right; maybe I don't want to have a
three-sentence paragraph where the first sentence constitutes 60% of the
words in that paragraph. :)

"Directories and extended attributes share the function of mapping names
to information, but the differences in the functionality requirements
applied to each type of structure influence their respective internal
formats.  Directories map variable length names to iterable directory
entry records (dirent records), whereas extended attributes map variable
length names to non-iterable attribute records.  Both structures can
take advantage of variable length record btree structures (i.e the
dabtree) to map name hashes, but there are major differences in the way
each type of structure integrate the dabtree index within the
information being stored.  The directory dabtree leaf nodes contain
mappings between a name hash and the location of a dirent record inside
the directory entry segment.  Extended attributes, on the other hand,
store attribute records directly in the leaf nodes of the dabtree."

How about that instead?

--D

> > +
> 
> Does the above mean to say "there are major differences in the ways each
> of these users embed information in the btree" as opposed to "embed the
> btree within the information?" The latter wording confuses me a bit,
> otherwise the rest looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +When XFS adds or removes an attribute record in any dabtree, it splits or
> > +merges leaf nodes of the tree based on where the name hash index determines a
> > +record needs to be inserted into or removed.  In the attribute dabtree, XFS
> > +splits or merges sparse leaf nodes of the dabtree as a side effect of inserting
> > +or removing attribute records.
> > +
> > +Directories, however, are subject to stricter constraints.  The userspace
> > +readdir/seekdir/telldir directory cookie API places a requirement on the
> > +directory structure that dirent record cookie cannot change for the life of the
> > +dirent record.  XFS uses the dirent record's logical offset into the directory
> > +data segment as the cookie, and hence the dirent record cannot change location.
> > +Therefore, XFS cannot store dirent records in the leaf nodes of the dabtree
> > +because the offset into the tree would change as other entries are inserted and
> > +removed.
> > +
> > +Dirent records are therefore stored within directory data blocks, all of which
> > +are mapped in the first directory segment.  The directory dabtree is mapped
> > +into the second directory segment.  Therefore, directory blocks require
> > +external free space tracking because they are not part of the dabtree itself.
> > +Because the dabtree only stores pointers to dirent records in the first data
> > +segment, there is no need to leave holes in the dabtree itself.  The dabtree
> > +splits or merges leaf nodes as required as pointers to the directory data
> > +segment are added or removed, and needs no free space tracking.
> > +
> > +When XFS adds a dirent record, it needs to find the best-fitting free space in
> > +the directory data segment to turn into the new record.  This requires a free
> > +space index for the directory data segment.  The free space index is held in
> > +the third directory segment.  Once XFS has used the free space index to find
> > +the block with that best free space, it modifies the directory data block and
> > +updates the dabtree to point the name hash at the new record.  When XFS removes
> > +dirent records, it leaves hole in the data segment so that the rest of the
> > +entries do not move, and removes the corresponding dabtree name hash mapping.
> > +
> > +Note that for small directories, XFS collapses the name hash mappings and
> > +the free space information into the directory data blocks to save space.
> > +
> > +In summary, the requirement for a free space map in the directory structure
> > +results from storing the dirent records externally to the dabtree.  Attribute
> > +records are stored directly in the dabtree leaf nodes of the dabtree (except
> > +for remote attribute values which can be anywhere in the attr fork address
> > +space) and do not need external free space tracking to determine where to best
> > +insert them.  As a result, extended attributes exhibit nearly perfect scaling
> > +until the computer runs out of memory.
> > 
> 
