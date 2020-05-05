Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4010C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D06E6206B9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Czbt7Srh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgEENDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:03:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47366 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728268AbgEENDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 09:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588683821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R6E7jH19I6U2E3aC+aNZsbgOo02dnUnsraOHmMvjC9k=;
        b=Czbt7Srh+IHaIcoKWgh2BU9/vfaY0prwirwNQpiIGmR4b8eFmraOhwLP4tfZKi8WL10WUn
        mA1gnDpksKJ0Js6GaSX/fOZlw0IYc0QfCdI8u4cg5UTUWMuCqBldftj7KirFygLKRNEplM
        4sBgzzDN9+4w7gawjjzxHGg2JDCh7v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-Cd4eFMdfMyKJZk07BeZUog-1; Tue, 05 May 2020 09:03:22 -0400
X-MC-Unique: Cd4eFMdfMyKJZk07BeZUog-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94CA68014D6;
        Tue,  5 May 2020 13:03:21 +0000 (UTC)
Received: from redhat.com (ovpn-113-201.rdu2.redhat.com [10.10.113.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C74961169;
        Tue,  5 May 2020 13:03:20 +0000 (UTC)
Date:   Tue, 5 May 2020 08:03:19 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsdocs: capture some information about dirs vs.
 attrs and how they use dabtrees
Message-ID: <20200505130319.GA88638@redhat.com>
References: <20200413194600.GC6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413194600.GC6742@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 13, 2020 at 12:46:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Dave and I had a short discussion about whether or not xattr trees
> needed to have the same free space tracking that directories have, and
> a comparison of how each of the two metadata types interact with
> dabtrees resulted.  I've reworked this a bit to make it flow better as a
> book chapter, so here we go.
> 
> Original-mail: https://lore.kernel.org/linux-xfs/20200404085203.1908-1-chandanrlinux@gmail.com/T/#mdd12ad06cf5d635772cc38946fc5b22e349e136f
> Originally-from: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: various fixes suggested by Dave; reflow the paragraphs about
> directories to describe the relations between dabtree and dirents only once;
> don't talk about an unnamed "we".
> ---

Looks good to me.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

>  .../extended_attributes.asciidoc                   |   55 ++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> index 99f7b35..b7a6007 100644
> --- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> +++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> @@ -910,3 +910,58 @@ Log sequence number of the last write to this block.
>  
>  Filesystems formatted prior to v5 do not have this header in the remote block.
>  Value data begins immediately at offset zero.
> +
> +== Key Differences Between Directories and Extended Attributes
> +
> +Though directories and extended attributes can take advantage of the same
> +variable length record btree structures (i.e. the dabtree) to map name hashes
> +to directory entry records (dirent records) or extended attribute records,
> +there are major differences in the ways that each of those users embed the
> +btree within the information that they are storing.  The directory dabtree leaf
> +nodes contain mappings between a name hash and the location of a dirent record
> +inside the directory entry segment.  Extended attributes, on the other hand,
> +store attribute records directly in the leaf nodes of the dabtree.
> +
> +When XFS adds or removes an attribute record in any dabtree, it splits or
> +merges leaf nodes of the tree based on where the name hash index determines a
> +record needs to be inserted into or removed.  In the attribute dabtree, XFS
> +splits or merges sparse leaf nodes of the dabtree as a side effect of inserting
> +or removing attribute records.
> +
> +Directories, however, are subject to stricter constraints.  The userspace
> +readdir/seekdir/telldir directory cookie API places a requirement on the
> +directory structure that dirent record cookie cannot change for the life of the
> +dirent record.  XFS uses the dirent record's logical offset into the directory
> +data segment as the cookie, and hence the dirent record cannot change location.
> +Therefore, XFS cannot store dirent records in the leaf nodes of the dabtree
> +because the offset into the tree would change as other entries are inserted and
> +removed.
> +
> +Dirent records are therefore stored within directory data blocks, all of which
> +are mapped in the first directory segment.  The directory dabtree is mapped
> +into the second directory segment.  Therefore, directory blocks require
> +external free space tracking because they are not part of the dabtree itself.
> +Because the dabtree only stores pointers to dirent records in the first data
> +segment, there is no need to leave holes in the dabtree itself.  The dabtree
> +splits or merges leaf nodes as required as pointers to the directory data
> +segment are added or removed, and needs no free space tracking.
> +
> +When XFS adds a dirent record, it needs to find the best-fitting free space in
> +the directory data segment to turn into the new record.  This requires a free
> +space index for the directory data segment.  The free space index is held in
> +the third directory segment.  Once XFS has used the free space index to find
> +the block with that best free space, it modifies the directory data block and
> +updates the dabtree to point the name hash at the new record.  When XFS removes
> +dirent records, it leaves hole in the data segment so that the rest of the
> +entries do not move, and removes the corresponding dabtree name hash mapping.
> +
> +Note that for small directories, XFS collapses the name hash mappings and
> +the free space information into the directory data blocks to save space.
> +
> +In summary, the requirement for a free space map in the directory structure
> +results from storing the dirent records externally to the dabtree.  Attribute
> +records are stored directly in the dabtree leaf nodes of the dabtree (except
> +for remote attribute values which can be anywhere in the attr fork address
> +space) and do not need external free space tracking to determine where to best
> +insert them.  As a result, extended attributes exhibit nearly perfect scaling
> +until the computer runs out of memory.
> 

