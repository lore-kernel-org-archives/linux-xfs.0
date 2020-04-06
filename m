Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113A2C2BA80
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D54B422247
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:04:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajLdcnqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgDFQEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 12:04:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729345AbgDFQEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 12:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586189083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=liThTMheOfzq4D4Ac91orkYfZKpmUAxGjOZUByiPc7Y=;
        b=ajLdcnqUQOXWBpZPGJnGMdCGU6MS/91Hd/RmksluOnERPo3LcfZuc3/gNbQYkMItnLHzR8
        9Sb2ar4HCjQywx+Bh6lZm9t46zpGA0pTXliQ1kUzr999r/nsj6VfwtSFj3O+3msu+Cvv7q
        F+txlVl/AShq05c5tZbkhQczN1qlZLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-Btn2jWvJO3i2mqPDg8hzog-1; Mon, 06 Apr 2020 12:04:41 -0400
X-MC-Unique: Btn2jWvJO3i2mqPDg8hzog-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3EAC18A8C80;
        Mon,  6 Apr 2020 16:04:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CF7B60BE1;
        Mon,  6 Apr 2020 16:04:39 +0000 (UTC)
Date:   Mon, 6 Apr 2020 12:04:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reflink should force the log out if mounted
 with wsync
Message-ID: <20200406160437.GF20708@bfoster>
References: <20200403125522.450299-1-hch@lst.de>
 <20200403125522.450299-2-hch@lst.de>
 <20200406121437.GB20207@bfoster>
 <20200406153154.GA6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406153154.GA6742@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 06, 2020 at 08:31:54AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 06, 2020 at 08:14:37AM -0400, Brian Foster wrote:
> > On Fri, Apr 03, 2020 at 02:55:22PM +0200, Christoph Hellwig wrote:
> > > Reflink should force the log out to disk if the filesystem was mounted
> > > with wsync, the same as most other operations in xfs.
> > > 
> > 
> > Isn't WSYNC for namespace operations? Why is this needed for reflink?
> 
> The manpage says that 'wsync' (the mount option) is for making namespace
> operations synchronous.
> 
> However, xfs_init_fs_context sets XFS_MOUNT_WSYNC if the admin set
> the 'sync' mount option, which makes all IO synchronous.
>

Ok.. so we're considering reflink a form of I/O.. I suppose that makes
sense, though it would be nice to explain that in the commit log...

Reviewed-by: Brian Foster <bfoster@redhat.com>

> > > Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
> > 
> > At a glance this looks like a refactoring patch. What does this fix?
> 
> It probably ought to be 862bb360ef569f ("xfs: reflink extents from one
> file to another") but so much of that was refactored for 5.0 that
> backporting this fix will require changing a totally different function
> (xfs_reflink_remap_range) in a totally different file (xfs_reflink.c).
> 
> --D
> 
> > Brian
> > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_file.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 68e1cbb3cfcc..4b8bdecc3863 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -1059,7 +1059,11 @@ xfs_file_remap_range(
> > >  
> > >  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
> > >  			remap_flags);
> > > +	if (ret)
> > > +		goto out_unlock;
> > >  
> > > +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > > +		xfs_log_force_inode(dest);
> > >  out_unlock:
> > >  	xfs_reflink_remap_unlock(file_in, file_out);
> > >  	if (ret)
> > > -- 
> > > 2.25.1
> > > 
> > 
> 

